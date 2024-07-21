const db = require('../../config/dbConfig');

exports.login = (req, res) => {
    res.send('User login');
};

exports.signup = (req, res) => {
    res.send('User signup');
};

exports.mypage = (req, res) => {
    res.send('User mypage');
};

exports.getNotice = (req, res) => {
    res.send('Get user notice');
};

exports.clearNotice = (req, res) => {
    res.send('Clear user notice');
};
