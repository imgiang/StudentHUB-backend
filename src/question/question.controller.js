const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const facebookApi = require('../utils/facebook-post.api');

module.exports = { addQuestion, findQuestions, findQuestionById, updateQuestionById, deleteQuesionById, getTagIdsByTagNames }

const QUESTIONS_PER_PAGE = 15;

async function addQuestion(req, res) {
    try {
        const question = await prisma.question.create({
            data: {
                userId: req.body.userId,
                title: req.body.title,
                content: req.body.content,
                TagsOnQuestions: {
                    createMany: {
                        data: await getTagIdsByTagNames(req.body.tags)
                    }
                },
            },
            include: {
                User: {
                    select: {
                        displayName: true
                    }
                }
            }
        });

        const facebookPost = await facebookApi.addPost(question, req.body.tags);
        await prisma.question.update({
            where: { id: question.id },
            data: { facebookId: facebookPost.id }
        });

        res.status(201).send(question);


    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function findQuestions(req, res) {
    try {
        const what = req.query.what
        const tags = req.query.tags ? { OR: req.query.tags.split(',').map(tag => new Object({ name: tag })) } : {}
        const page = req.query.page ? Number(req.query.page) : 1

        const questions = await prisma.question.findMany({
            include: {
                TagsOnQuestions: {
                    select: {
                        Tag: {
                            select: {
                                name: true
                            }
                        }
                    }
                },
                User: {
                    select: {
                        uid: true,
                        displayName: true,
                        photoURL: true
                    }
                },
                _count: {
                    select: {
                        Answer: true
                    }
                }
            },
            where: {
                AND: [{
                        deleted: false
                    },
                    {
                        title: {
                            search: what
                        },
                        content: {
                            search: what
                        },
                        TagsOnQuestions: {
                            some: {
                                Tag: tags
                            }
                        }

                    }
                ]

            },
            orderBy: {
                //use only one argument
                updatedAt: req.query.updatedAt,
                score: req.query.score
            },
            take: QUESTIONS_PER_PAGE,
            skip: QUESTIONS_PER_PAGE * (page - 1)
        })

        res.send(questions)
    } catch (error) {
        res.status(500).send(error.message)
    }
}

async function findQuestionById(req, res) {
    try {
        const question = await prisma.question.findMany({
            where: {
                id: Number(req.params.id),
                deleted: false
            },
            include: {
                User: true,
                Answer: {
                    include: {
                        AnswerComment: {
                            include: {
                                User: {
                                    select: {
                                        uid: true,
                                        displayName: true,
                                        photoURL: true
                                    }
                                }
                            },
                        },
                        AnswerVoter: {
                            select: {
                                userId: true,
                                state: true
                            }
                        }
                    },
                    where: {
                        deleted: false
                    }
                },
                QuestionComment: {
                    include: {
                        User: {
                            select: {
                                uid: true,
                                displayName: true
                            }
                        },
                    }
                },
                QuestionVoter: {
                    select: {
                        userId: true,
                        state: true
                    }
                },
                TagsOnQuestions: {
                    select: {
                        Tag: {
                            select: {
                                name: true
                            }
                        }
                    }
                }
            }
        });
        question[0].facebookLink =
            `${process.env.FACEBOOK_PAGE_POST_BASE_URL}/${question[0].facebookId.substring(question[0].facebookId.indexOf("_") + 1)}`
        res.send(question[0]);

    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function updateQuestionById(req, res) {
    try {
        const id = Number(req.params.id);

        const question = await prisma.question.update({
            where: {
                id: id
            },
            data: {
                title: req.body.title,
                content: req.body.content,
                TagsOnQuestions: {
                    deleteMany: {
                        questionId: id
                    },
                    createMany: {
                        data: await getTagIdsByTagNames(req.body.tags)
                    }
                }
            },
            include: {
                User: {
                    select: {
                        displayName: true
                    }
                }
            }
        });

        const facebookComment = await facebookApi.updatePost(question, req.body.tags);
        console.log(facebookComment);
        res.send(question);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function deleteQuesionById(req, res) {
    try {
        const question = await prisma.question.update({
            where: {
                id: Number(req.params.id)
            },
            data: {
                deleted: true
            }
        });

        await facebookApi.deletePost(question.facebookId);

        res.send({ message: question ? "Deleted question " + question.id : "Something wrong, try again." });


    } catch (error) {
        res.status(500).send(error.message)
    }
}

// Creat new tag if not exists and get all id 
async function getTagIdsByTagNames(tagNames) {
    try {
        const existTags = await prisma.tag.findMany({
                where: {
                    name: { in: tagNames }
                }
            })
            // get id of exist tags
        let tagIds = existTags.map(tag => new Object({ tagId: tag.id }))

        const existTagsName = existTags.map(tag => tag.name)
            // get new tags from request (which may contain both old and new tags)
        const newTagsName = tagNames.filter(name => !existTagsName.includes(name))

        // add new tags to TagsOnQuestions
        for (let tagName of newTagsName) {
            const newTag = await prisma.tag.create({
                    data: {
                        name: tagName
                    }
                })
                // push new tag id into result
            tagIds.push(new Object({ tagId: newTag.id }))
        }

        return tagIds
    } catch (error) {
        console.error(error);
    }
}