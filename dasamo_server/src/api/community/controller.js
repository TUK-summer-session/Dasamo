const db = require("../../config/dbConfig");
const createResponse = require("../../utils/response");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const {
  getCommunityById,
  deleteCommunityById,
  getCommentsByCommunityId,
  storeComment,
  checkIfAlreadyLiked,
  likeCommunityPost,
  unlikeCommunityPost,
} = require("./repository");

exports.index = async (req, res) => {
  console.log("Community home");
  try {
    const result = await db.query(`
      SELECT c.community_id, c.member_id, c.detail, c.created_at, c.updated_at, 
             m.profile_image_url, 
             ARRAY_REMOVE(ARRAY_AGG(ci.url ORDER BY ci."order"), NULL) AS image_urls
      FROM Community c
      JOIN Member m ON c.member_id = m.member_id
      LEFT JOIN CommunityImage ci ON c.community_id = ci.community_id
      GROUP BY c.community_id, m.profile_image_url
    `);

    const communities = result.rows.map((row) => ({
      communityId: row.community_id,
      memberId: row.member_id,
      profileImageUrl: row.profile_image_url,
      imageUrls: row.image_urls,
      detail: row.detail,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
    }));

    const response = createResponse(200, "요청이 성공적으로 처리되었습니다.", {
      communities,
    });
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

// Multer 설정 - 파일 업로드를 쉽게 처리할 수 있도록 도와주는 미들웨어
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/"); // 업로드된 파일이 저장될 디렉토리
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(null, file.fieldname + "-" + uniqueSuffix + "-" + file.originalname);
  },
});

const upload = multer({ storage: storage });

exports.uploadImage = [
  upload.array("files", 10), // 'files' 필드에 대해 최대 10개의 파일 업로드 처리
  async (req, res) => {
    const { communityId } = req.body;
    const files = req.files;

    if (!communityId || files.length === 0) {
      return res
        .status(400)
        .send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
      // 이미지 URL을 CommunityImage 테이블에 삽입
      const imageInsertPromises = files.map((file, index) => {
        return db.query(
          'INSERT INTO CommunityImage (community_id, url, "order") VALUES ($1, $2, $3)',
          [communityId, file.path, index]
        );
      });

      await Promise.all(imageInsertPromises);

      const response = createResponse(200, "이미지 업로드 성공");
      res.status(200).send(response);
    } catch (error) {
      console.error("Query error:", error);
      res.status(500).send(createResponse(500, "서버 에러"));
    }
  },
];

exports.store = [
  upload.array("files", 10), // 'files' 필드에 대해 최대 10개의 파일 업로드 처리
  async (req, res) => {
    const { memberId, detail } = req.body;
    const files = req.files;

    if (!memberId || !detail || files.length === 0) {
      return res
        .status(400)
        .send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
      // DB에 데이터 삽입
      const result = await db.query(
        "INSERT INTO Community (member_id, detail, created_at, updated_at) VALUES ($1, $2, NOW(), NOW()) RETURNING community_id",
        [memberId, detail]
      );

      const communityId = result.rows[0].community_id;

      // 이미지 URL을 CommunityImage 테이블에 삽입
      const imageInsertPromises = files.map((file, index) => {
        return db.query(
          'INSERT INTO CommunityImage (community_id, url, "order") VALUES ($1, $2, $3)',
          [communityId, file.path, index]
        );
      });

      await Promise.all(imageInsertPromises);

      const response = createResponse(200, "커뮤니티 저장 성공", {
        communityId,
      });
      res.status(200).send(response);
    } catch (error) {
      console.error("Query error:", error);
      res.status(500).send(createResponse(500, "서버 에러"));
    }
  },
];

exports.deleteCommunity = async (req, res) => {
  const { communityId } = req.body;

  if (!communityId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const community = await getCommunityById(communityId);

    if (!community) {
      return res
        .status(400)
        .send(createResponse(400, "존재하지 않는 커뮤니티입니다."));
    }

    // 커뮤니티와 관련된 댓글 삭제
    await db.query("DELETE FROM Comment WHERE community_id = $1", [
      communityId,
    ]);

    // 커뮤니티와 관련된 이미지 파일 URL 조회
    const imagePaths = await db.query(
      "SELECT url FROM CommunityImage WHERE community_id = $1",
      [communityId]
    );

    // 데이터베이스에서 커뮤니티 삭제
    await deleteCommunityById(communityId);

    // 서버에서 이미지 파일 삭제
    imagePaths.rows.forEach((image) => {
      if (fs.existsSync(image.url)) {
        fs.unlinkSync(image.url);
      }
    });

    const response = createResponse(200, "커뮤니티 및 관련 데이터 삭제 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

exports.getComments = async (req, res) => {
  const { communityId } = req.body;

  if (!communityId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const comments = await getCommentsByCommunityId(communityId);

    const response = createResponse(200, "요청이 성공적으로 처리되었습니다.", {
      communityId,
      comments,
    });
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

exports.storeComment = async (req, res) => {
  const { memberId, communityId, isCommentForComment, parentComment, detail } =
    req.body;

  if (
    !memberId ||
    !communityId ||
    typeof isCommentForComment !== "boolean" ||
    !detail
  ) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    await storeComment({
      memberId,
      communityId,
      isCommentForComment,
      parentComment,
      detail,
    });
    const response = createResponse(200, "커뮤니티 댓글 저장 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

exports.like = async (req, res) => {
  const { memberId } = req.body;
  const { communityId } = req.params;

  if (!memberId || !communityId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const alreadyLiked = await checkIfAlreadyLiked(memberId, communityId);
    if (alreadyLiked) {
      return res
        .status(401)
        .send(createResponse(401, "이미 좋아요를 누른 게시글입니다."));
    }

    await likeCommunityPost(memberId, communityId);
    const response = createResponse(200, "커뮤니티 좋아요 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

exports.unlike = async (req, res) => {
  const { memberId } = req.body;
  const { communityId } = req.params;

  if (!memberId || !communityId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const alreadyLiked = await checkIfAlreadyLiked(memberId, communityId);
    if (!alreadyLiked) {
      return res
        .status(401)
        .send(createResponse(401, "이미 좋아요가 해제된 게시글입니다."));
    }

    await unlikeCommunityPost(memberId, communityId);
    const response = createResponse(200, "커뮤니티 좋아요 취소 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};
