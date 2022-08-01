const { initializeApp } = require('firebase-admin/app');
const { auth, credential } = require("firebase-admin");

const serviceAccount = require("./firebase-key.json");

const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

initializeApp({
    credential: credential.cert(serviceAccount)
});

async function createOrUpdateUser(req, res) {
    try {
        const idToken = req.headers.authorization;
        if (idToken == null) {
            return res.status(401).send({ message: "Missing token" });

        } else {
            const decodedToken = await auth().verifyIdToken(idToken.substring(7));

            const decodedUid = decodedToken.uid;
            const UserRecord = await auth().getUser(decodedUid);

            const user = await prisma.user.upsert({
                where: { uid: decodedUid },
                create: {
                    uid: decodedUid,
                    displayName: UserRecord.displayName,
                    email: UserRecord.email,
                    phoneNumber: UserRecord.phoneNumber,
                    photoURL: UserRecord.photoURL
                },
                update: {
                    displayName: UserRecord.displayName,
                    email: UserRecord.email,
                    phoneNumber: UserRecord.phoneNumber,
                    photoURL: UserRecord.photoURL
                }
            });

            res.status(201).send({ message: "User updated", user });
        }
    } catch (error) {
        res.status(error.status || 500).send({ message: "Invalid token" });
    }
}

async function authorize(req, res, next) {
    try {
        const idToken = req.headers.authorization;
        if (idToken == null) {
            return res.status(401).send({ message: "Missing token" });

        } else {
            const decodedToken = await auth().verifyIdToken(idToken.substring(7));
            const expTime = new Date(decodedToken.exp * 1000);
            console.log(decodedToken);
            if (expTime < new Date()) {
                return res.status(401).send({ message: "Token expired" });
            } else {
                res.locals.uid = decodedToken.uid;
                const uid = res.locals.uid;
                const existUser = await prisma.user.findUnique({ where: { uid: uid } });

                if (existUser == null || decodedToken.uid !== uid) {
                    return res.status(403).send({ message: "Permisstion denied" });
                } else {
                    next();
                }
            }
        }
    } catch (error) {
        next(error);
        // res.status(error.status || 500).send({ message: "Something wrong, try again." });
    }
}

module.exports = { createOrUpdateUser, authorize };