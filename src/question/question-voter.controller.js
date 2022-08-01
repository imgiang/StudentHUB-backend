const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

module.exports = { updateQuestionScoreById }

async function updateQuestionScoreById(req, res) {
    try {
        const questionId = Number(req.params.id);
        const userId = req.body.userId;
        const state = req.body.state;

        const question = await prisma.questionVoter.findFirst({ where: { userId: userId, questionId: questionId } });
        const questionVoterId = question ? question.id : -1;

        const questionVoter = await prisma.questionVoter.upsert({
            where: {
                id: questionVoterId
            },
            create: {
                userId: userId,
                questionId: questionId,
                state: state
            },
            update: {
                state: state
            }
        });

        res.send(questionVoter);
    } catch (error) {
        res.status(500).send(error.message);
    }
}