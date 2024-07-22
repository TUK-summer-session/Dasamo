const db = require('../../config/dbConfig');
const repository = require('./repository');
const createResponse = require("../../utils/response");

exports.login = (req, res) => {
    res.send('User login');
};

exports.signup = (req, res) => {
    res.send('User signup');
};

exports.mypage = async (req, res) => {
    console.log('User mypage');
    const memberId = req.body.memberId;

    try {
        // 1. 내정보 땡겨오기
        if (!memberId) {
            return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
        }
        const profile = await repository.getMemberById(memberId);
        console.log(memberId);

        // 2. 스크랩 가져오기
        const scraps = await repository.getScrapsByMemberId(memberId);
        // 3. 내가올린 리뷰 가져오기
        const reviews = await repository.getReviewsByMemberId(memberId);
        // 4. 내가올린 커뮤니티 가져오기
        const communities = await repository.getCommunitiesByMemberId(memberId);

        const response = createResponse(200, '마이페이지 요청이 성공적으로 처리되었습니다.',
            {
                profile, scraps, reviews, communities
            }
        );
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }

};

exports.getNotice = (req, res) => {
    res.send('Get user notice');
};

exports.clearNotice = (req, res) => {
    res.send('Clear user notice');
};


