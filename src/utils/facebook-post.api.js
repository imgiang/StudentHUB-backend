const axios = require("axios");
const { URL } = require("url");

const MY_URL = new URL(process.env.FACEBOOK_GRAPH_API);
MY_URL.searchParams.append(
  "access_token",
  process.env.FACEBOOK_LONG_LIVED_TOKEN
);

module.exports = { addPost, updatePost, deletePost };

async function addPost(question, tags) {
  try {
    MY_URL.pathname = `/v13.0/${process.env.PAGE_ID}/feed`;

    const message = generateMessage(question, tags);
    const response = await axios.post(MY_URL.toString(), { message });
    return response.data;
  } catch (error) {
    return error;
  }
}

async function updatePost(question, tags) {
  try {
    MY_URL.pathname = `/v13.0/${question.facebookId}`;

    const message = generateMessage(question, tags);
    const response = await axios.post(MY_URL.toString(), { message });
    return response.data;
  } catch (error) {
    return error;
  }
}

async function deletePost(postId) {
  try {
    MY_URL.pathname = `/v13.0/${postId}`;
    const response = await axios.delete(MY_URL.toString());
    return response.data;
  } catch (error) {
    return error;
  }
}

function generateMessage(question, tags) {
  let message = "";
  message += `FROM: ${question.User.displayName}`;
  message += `\n\n`;
  message += `Q: ${question.title}\n`;
  message += `${question.content}`;
  message += `\n\n`;
  tags.forEach((tag) => {
    message += `#${tag} `;
  });
  message += `\n`;
  message += `LINK: https://luanbt.live/questions/${question.id}`;

  if (process.env.NODE_ENV == "dev") {
    message += `\n`;
    message += `LINK: http://localhost:3000/questions/${question.id}`;
  }

  return message;
}
