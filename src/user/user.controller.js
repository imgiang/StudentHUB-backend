const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();
const { getTagIdsByTagNames } = require("../question/question.controller");

module.exports = {
  findUsers,
  findById,
  updateById,
  updateInterestedTagById,
  deleteById,
};

const USERS_PER_PAGE = 36;

// find by name, email
async function findUsers(req, res) {
  try {
    const what = req.query.what;
    const page = req.query.page ? Number(req.query.page) : 1;
    const users = await prisma.user.findMany({
      where: {
        displayName: {
          search: what,
        },
        email: {
          search: what,
        },
      },
      include: {
        InterestedTag: {
          select: {
            Tag: {
              select: {
                name: true,
              },
            },
          },
        },
        _count: {
          select: {
            Answer: true,
            Question: true,
          },
        },
      },
      take: USERS_PER_PAGE,
      skip: USERS_PER_PAGE * (page - 1),
    });
    res.send(users);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

async function findById(req, res) {
  try {
    const user = await prisma.user.findUnique({
      where: {
        uid: req.params.uid,
      },
      include: {
        Question: true,
        QuestionComment: true,
        Answer: true,
        AnswerComment: true,
        InterestedTag: {
          select: {
            Tag: {
              select: {
                name: true,
              },
            },
          },
        },
      },
    });
    res.send(user);
  } catch (error) {
    res.status(500).send(error.message);
  }
}
// not for updating interested tags
async function updateById(req, res) {
  try {
    const user = await prisma.user.update({
      where: {
        uid: req.params.uid,
      },
      data: req.body,
    });
    res.send(user);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

async function updateInterestedTagById(req, res) {
  try {
    const uid = req.params.uid;

    const user = await prisma.user.update({
      where: {
        uid: uid,
      },
      data: {
        InterestedTag: {
          deleteMany: {
            userId: uid,
          },
          createMany: {
            data: await getTagIdsByTagNames(req.body.tags),
          },
        },
      },
      select: {
        uid: true,
        InterestedTag: {
          select: {
            Tag: {
              select: {
                name: true,
              },
            },
          },
        },
      },
    });
    res.send(user);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

async function deleteById(req, res) {
  try {
    const user = await prisma.user.delete({
      where: {
        uid: req.params.uid,
      },
    });
    res.send({
      message: user ? "Delete user " + user.uid : "Something wrong, try again",
    });
  } catch (error) {
    res.status(500).send(error.message);
  }
}
