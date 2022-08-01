const router = require('express').Router()
const { addAnswer, updateAnswerById, deleteAnswerById, verifyAnswer } = require("./answer.controller")
const { updateAnswerScoreById } = require("./answer-voter.controller")
const { addAnswerComment, updateAnswerCommentById, deleteAnswerCommentById } = require("./answer-comment.controller");
const { authorize } = require('../middlewares/firebase.middleware');

function getUid(req, res, next) {
    res.locals.uid = req.body.userId;
    next();
}

const authQueue = [getUid, authorize];

router.post("/", authQueue, addAnswer);
router.put("/:id", authQueue, updateAnswerById);
router.delete("/:id", authQueue, deleteAnswerById);
router.put("/verify/:id", authQueue, verifyAnswer);

router.put("/score/:id", authQueue, updateAnswerScoreById);

router.post("/comments", authorize, addAnswerComment);
router.put("/comments/:id", authQueue, updateAnswerCommentById);
router.delete("/comments/:id", authQueue, deleteAnswerCommentById);

module.exports = router