const express = require("express");
const app = express();
const morgan = require("morgan");
const swaggerUi = require("swagger-ui-express");
const swaggerDocs = require("./swagger.json");
const cors = require("cors");
require("dotenv").config();

const user = require("./src/user/user.route");
const question = require("./src/question/question.route");
const answer = require("./src/answer/answer.route");
const document = require("./src/document/document.route");

if (process.env.NODE_ENV !== "test") {
  app.use(morgan("combined"));
}

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(
  "/api-docs",
  swaggerUi.serve,
  swaggerUi.setup(swaggerDocs, { explorer: true })
);

app.use("/api/users", user);
app.use("/api/questions", question);
app.use("/api/answers", answer);
app.use("/api/documents", document);

const PORT = process.env.PORT || 8080;
const server = app.listen(PORT, () => {
  console.log(`Listening on port ${PORT}`);
});

module.exports = server;
