const router = require('express').Router()
const { addDocument, findAllDocuments, updateDocumentById, deleteDocumentByid } = require('./document.controller')

router.post("/", addDocument)
router.get("/", findAllDocuments)
router.put("/:id", updateDocumentById)
router.delete("/:id", deleteDocumentByid)

module.exports = router