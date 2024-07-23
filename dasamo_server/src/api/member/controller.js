const db = require("../../config/dbConfig");
const repository = require("./repository");
const createResponse = require("../../utils/response");

exports.login = async (req, res) => {
  const { id, nickname, email, profileImageUrl } = req.body;
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
          // 데이터베이스 삽입 결과로부터 insertId를 정수로 변환하여 memberId에 할당
          const memberId = parseInt(result.insertId, 10);
          member = { memberId, email, nickname, profileImageUrl };
      }
      // TODO: 토큰 인증은 마지막의 마지막에 구현

      const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', { member });
      res.send(response);
  } catch (error) {
      console.error('카카오 사용자 정보 요청 실패', error);
      res.status(500).send('서버 오류가 발생했습니다.');
  }
};

exports.signup = (req, res) => {
  res.send("User signup");
};

exports.mypage = async (req, res) => {
    console.log('User mypage');
    const memberId = parseInt(req.query.memberId, 10);
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

    const response = createResponse(
      200,
      "마이페이지 요청이 성공적으로 처리되었습니다.",
      {
        profile,
        scraps,
        reviews,
        communities,
      }
    );
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
};

exports.getNotice = (req, res) => {
  res.send("Get user notice");
};

exports.clearNotice = (req, res) => {
  res.send("Clear user notice");
};
