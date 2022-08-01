const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

module.exports = { updateAnswerScoreById }

async function updateAnswerScoreById(req, res) {
    try {
        const userId = req.body.userId
        const answerId = Number(req.params.id)
        const state = req.body.state

        const answer = await prisma.answerVoter.findFirst({ where: { userId: userId, answerId: answerId } })
        const answerVoterId = answer ? answer.id : -1

        const answerVoter = await prisma.answerVoter.upsert({
            where: {
                id: answerVoterId
            },
            create: {
                userId: userId,
                answerId: answerId,
                state: state
            },
            update: {
                state: state
            }
        })
        res.send(answerVoter)
    } catch (error) {
        res.status(500).send(error.message)
    }
}