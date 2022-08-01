const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const facebookApi = require('../utils/facebook-comment.api');

module.exports = { addAnswer, updateAnswerById, deleteAnswerById, verifyAnswer };

async function addAnswer(req, res) {
    try {
        const answer = await prisma.answer.create({
            data: {
                questionId: req.body.questionId,
                userId: req.body.userId,
                content: req.body.content
            },
            include: {
                User: {
                    select: {
                        displayName: true
                    }
                },
                Question: {
                    select: {
                        facebookId: true
                    }
                }
            }
        });
        const facebookComment = await facebookApi.addComment(answer.Question.facebookId, answer);
        await prisma.answer.update({
            where: {
                id: answer.id
            },
            data: {
                facebookId: facebookComment.id
            }
        });

        res.status(201).send(answer);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function updateAnswerById(req, res) {
    try {
        const answer = await prisma.answer.update({
            where: {
                id: Number(req.params.id)
            },
            data: {
                content: req.body.content
            },
            include: {
                User: {
                    select: {
                        displayName: true
                    }
                }
            }
        });

        await facebookApi.updateComment(answer);

        res.send(answer);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function deleteAnswerById(req, res) {
    try {
        const answer = await prisma.answer.update({
            where: {
                id: Number(req.params.id)
            },
            data: {
                deleted: true
            }
        });

        await facebookApi.deleteComment(answer.facebookId);

        const result = { message: answer ? `Deleted answer ${answer.id}` : "Something wrong, try again" };
        res.send(result);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function verifyAnswer(req, res) {
    try {
        const answer = await prisma.answer.update({
            where: {
                id: Number(req.params.id)
            },
            data: {
                verify: req.body.verify
            },
            include: {
                User: {
                    select: {
                        displayName: true
                    }
                }
            }
        });

        await facebookApi.updateComment(answer);

        res.send(answer);
    } catch (error) {
        res.status(500).send(error.message);
    }
}