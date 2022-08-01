const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const facebookApi = require('../utils/facebook-comment.api');

module.exports = { addQuestionComment, updateQuestionCommentById, deleteQuestionCommentById };

async function addQuestionComment(req, res) {
    try {
        const comment = await prisma.questionComment.create({
            data: {
                questionId: req.body.questionId,
                userId: res.locals.uid,
                content: req.body.content
            },
            include: {
                User: {
                    select: {
                        uid: true,
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

        const facebookComment = await facebookApi.addComment(comment.Question.facebookId, comment);
        await prisma.questionComment.update({
            where: {
                id: comment.id
            },
            data: {
                facebookId: facebookComment.id
            }
        });

        res.status(201).send(comment);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function updateQuestionCommentById(req, res) {
    try {
        const comment = await prisma.questionComment.update({
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

        await facebookApi.updateComment(comment);

        res.send(comment);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function deleteQuestionCommentById(req, res) {
    try {
        const comment = await prisma.questionComment.delete({
            where: {
                id: Number(req.params.id)
            }
        });

        await facebookApi.deleteComment(comment.facebookId);

        const result = {
            message: comment
                ? `Deleted commnent ${req.params.id} of question ${comment.questionId}`
                : 'Something wrong, try again'
        };
        res.send(result);
    } catch (error) {
        res.status(500).send(error.message);
    }
}
