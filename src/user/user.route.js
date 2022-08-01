const router = require('express').Router()
const { findById, updateById, updateInterestedTagById, deleteById, findUsers } = require('./user.controller')
const { authorize, createOrUpdateUser } = require("../middlewares/firebase.middleware");

function getUid(req, res, next) {
    res.locals.uid = req.params.uid;
    next();
}

const authQueue = [getUid, authorize];

router.post("/login", createOrUpdateUser);
router.get("/", findUsers);
router.get("/:uid", findById);

router.put("/:uid", authQueue, updateById);
router.put("/tags/:uid", authQueue, updateInterestedTagById);
router.delete("/:uid", authQueue, deleteById);

module.exports = router;