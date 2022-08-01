const { PrismaClient } = require('@prisma/client')
const prisma = new PrismaClient()

module.exports = { addDocument, findAllDocuments, updateDocumentById, deleteDocumentByid }

async function addDocument(req, res) {
    try {
        const document = await prisma.document.create({
            data: req.body
        })
        res.status(201).send(document)
    } catch (error) {
        res.status(500).send(error.message)
    }
}

async function findAllDocuments(req, res) {
    try {
        const documents = await prisma.document.findMany()
        res.send(documents)
    } catch (error) {
        res.status(500).send(error.message)
    }
}


async function updateDocumentById(req, res) {
    try {
        const document = await prisma.document.update({
            where: {
                id: req.params.id
            },
            data: req.body
        })
        res.send(document)
    } catch (error) {
        res.status(500).send(error.message)
    }
}


async function deleteDocumentByid(req, res) {
    try {
        const document = await prisma.document.delete({
            where: {
                id: req.params.id
            }
        })
        const result = { message: document ? `Deleted document ${document.id}` : `Somethin wrong, try again.` }
        res.send(result)
    } catch (error) {
        res.status(500).send(error.message)
    }
}