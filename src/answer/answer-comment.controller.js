const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
const facebookApi = require('../utils/facebook-comment.api');
module.exports = { addAnswerComment, updateAnswerCommentById, deleteAnswerCommentById };

async function addAnswerComment(req, res) {
    try {
        const comment = await prisma.answerComment.create({
            data: {
                answerId: req.body.answerId,
                userId: res.locals.uid,
                content: req.body.content
            },
            include: {
                Answer: {
                    select: {
                        facebookId: true
                    }
                },
                User: {
                    select: {
                        uid: true,
                        displayName: true
                    }
                }
            }
        });

        const facebookReply = await facebookApi.addComment(comment.Answer.facebookId, comment);
        await prisma.answerComment.update({
            where: {
                id: comment.id
            },
            data: {
                facebookId: facebookReply.id
            }
        });

        res.status(201).send(comment);
    } catch (error) {
        res.status(500).send(error.message);
    }
}

async function updateAnswerCommentById(req, res) {
    try {
        const comment = await prisma.answerComment.update({
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

async function deleteAnswerCommentById(req, res) {
    try {
        const comment = await prisma.answerComment.delete({
            where: {
                id: Number(req.params.id)
            }
        });
        const result = {
            message: comment
                ? `Deleted comment ${req.params.id} of answer ${comment.answerId}`
                : 'Something wrong, try again.'
        };

        await facebookApi.deleteComment(comment.facebookId);

        res.send(result);
    } catch (error) {
        res.status(500).send(error.message);
    }
}
