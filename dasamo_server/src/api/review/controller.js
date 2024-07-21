const db = require('../../config/dbConfig');

exports.index = (req, res) => {
    res.send('Review home');
};

exports.products = (req, res) => {
    res.send('Product list');
};

exports.store = (req, res) => {
    res.send('Store review');
};

exports.uploadImage = (req, res) => {
    res.send('Upload review image');
};

exports.deleteImage = (req, res) => {
    res.send('Delete review image');
};

exports.show = (req, res) => {
    res.send(`Show review ${req.params.reviewId}`);
};

exports.delete = (req, res) => {
    res.send(`Delete review ${req.params.reviewId}`);
};

exports.update = (req, res) => {
    res.send(`Update review ${req.params.reviewId}`);
};

exports.getComments = (req, res) => {
    res.send(`Get comments for review ${req.params.reviewId}`);
};

exports.storeComment = (req, res) => {
    res.send(`Store comment for review ${req.params.reviewId}`);
};

exports.deleteComment = (req, res) => {
    res.send(`Delete comment ${req.params.questionId}`);
};

exports.like = (req, res) => {
    res.send(`Like review ${req.params.reviewId}`);
};

exports.scrap = (req, res) => {
    res.send(`Scrap review ${req.params.reviewId}`);
};

exports.unlike = (req, res) => {
    res.send(`Unlike review ${req.params.reviewId}`);
};

exports.unscrap = (req, res) => {
    res.send(`Unscrap review ${req.params.reviewId}`);
};
