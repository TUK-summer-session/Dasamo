const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');
const repository = require('./repository');

exports.login = async (req, res) => {
    const { id, nickname, email, profileImageUrl} = req.body;
    try {

      console.log(`ID: ${id}`);
      console.log(`Nickname: ${nickname}`);
      console.log(`Email: ${email}`);
      console.log(`ProfileImage: ${profileImageUrl}`);

      // db에 이메일 일치하는 놈 있으면 memberId 리턴
      let memberResult = await repository.getMemberByEmail(email);
      let member = memberResult[0];
      if (memberResult.length < 1) {
          // 없으면 새로 저장해서 memberId 넣어줌
          const result = await db.query(
              'INSERT INTO Member (email, name, profileImageUrl) VALUES (?, ?, ?)',
              [email, nickname, profileImageUrl]
          );
          member = { memberId: result.insertId, email, nickname, profileImageUrl };
      }
      // TODO: 토큰 인증은 마지막의 마지막에 구현

      const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', {member});
      res.send(response);
    } catch (error) {
      console.error('카카오 사용자 정보 요청 실패', error);
      res.status(500).send('서버 오류가 발생했습니다.');
    }
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
