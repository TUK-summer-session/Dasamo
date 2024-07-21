const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');

exports.index = async (req, res) => {
    console.log('Community home');
    try {
        const result = await db.query('SELECT * FROM Community');
        const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', result);
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
    }
};

exports.store = (req, res) => {
    res.send('Store community post');
    
};

exports.uploadImage = (req, res) => {
    res.send('Upload community image');
};

exports.deleteImage = (req, res) => {
    res.send('Delete community image');
};

exports.getComments = (req, res) => {
    res.send(`Get comments for community post ${req.params.communityId}`);
};

exports.storeComment = (req, res) => {
    res.send(`Store comment for community post ${req.params.communityId}`);
};

exports.like = (req, res) => {
    res.send(`Like community post ${req.params.communityId}`);
};

exports.unlike = (req, res) => {
    res.send(`Unlike community post ${req.params.communityId}`);
};
