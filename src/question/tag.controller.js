const { PrismaClient } = require("@prisma/client");
const prisma = new PrismaClient();

module.exports = { getAllTags };

async function getAllTags(req, res) {
  try {
    const tags = await prisma.tag.findMany();
    res.send(tags);
  } catch (error) {
    res.status(error.status || 500).send(error);
  }
}
