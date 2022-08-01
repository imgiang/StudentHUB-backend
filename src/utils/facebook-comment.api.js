const axios = require('axios');
const { URL } = require('url');

const MY_URL = new URL('https://graph.facebook.com');
MY_URL.search = `?access_token=${process.env.FACEBOOK_LONG_LIVED_TOKEN}`;

module.exports = { addComment, updateComment, deleteComment };

async function addComment(objectId, comment) {
    try {
        MY_URL.pathname = `/v13.0/${objectId}/comments`;

        const message = generateComment(comment);
        const response = await axios.post(MY_URL.toString(), { message });
        return response.data;
    } catch (error) {
        return error;
    }
}

async function updateComment(comment) {
    try {
        MY_URL.pathname = `/v13.0/${comment.facebookId}`;

        const message = generateComment(comment);
        const response = await axios.post(MY_URL.toString(), { message });
        return response.data;
    } catch (error) {
        return error;
    }
}

async function deleteComment(commentId) {
    try {
        MY_URL.pathname = `/v13.0/${commentId}`;

        const response = await axios.delete(MY_URL.toString());
        return response.data;
    } catch (error) {
        return error;
    }
}

function generateComment(comment) {
    let message = "";
    if (comment.verify == true) {
        message += "✅ ";
    } else {
        message = message.substring(message.indexOf("FROM"));
    }
    message += `FROM: ${comment.User.displayName}`;
    message += `\n\n`;
    message += `${comment.content}`;
    return message;
}