const db = require("../../config/dbConfig");
const createResponse = require("../../utils/response");
const multer = require("multer");
const fs = require("fs");
const path = require("path");
const repository = require('./repository');


// 커뮤니티 목록 조회
exports.index = async (req, res) => {
  console.log("Community home");
  const memberId = req.body.memberId;
  try {
    const result = await repository.getCommunitiesWithMembers(memberId);

    const communities = result.map((row) => ({
      communityId: row.communityId,
      detail: row.detail,
      isLiked: (row.isLiked == 1),
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      member: {
        memberId: row.memberId,
        name: row.name,
        profileImageUrl: row.profileImageUrl,
      },
      image: {
        imageid: row.communityImageId,
        url: row.url,
      }
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

// Multer 설정
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "uploads/");
  },
  filename: (req, file, cb) => {
    const uniqueSuffix = Date.now() + "-" + Math.round(Math.random() * 1e9);
    cb(
      null,
      file.fieldname + "-" + uniqueSuffix + path.extname(file.originalname)
    );
  },
});

const upload = multer({ storage: storage });

// // 단일 이미지 업로드
// exports.uploadImage = [
//   upload.single("file"),
//   async (req, res) => {
//     const { communityId } = req.body;
//     const file = req.file;

//     if (!communityId || !file) {
//       return res
//         .status(400)
//         .send(createResponse(400, "요청이 잘못되었습니다."));
//     }

//     try {
//       await db.query(
//         "INSERT INTO CommunityImage (communityId, url, `order`) VALUES (?, ?, ?)",
//         [communityId, file.path, 0]
//       );

//       const response = createResponse(200, "이미지 업로드 성공");
//       res.status(200).send(response);
//     } catch (error) {
//       console.error("Query error:", error);
//       res.status(500).send(createResponse(500, "서버 에러"));
//     }
//   },
// ];

// 커뮤니티 저장
exports.store = [
  upload.single("file"), // 단일 파일 업로드
  async (req, res) => {
    const { memberId, detail } = req.body;
    const file = req.file; // 단일 파일을 처리하기 위한 변수

    if (!memberId || !detail || !file) {
      return res
        .status(400)
        .send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
      // 커뮤니티 데이터 삽입
      const result = await db.query(
        "INSERT INTO Community (memberId, detail, createdAt, updatedAt) VALUES (?, ?, NOW(), NOW())",
        [memberId, detail]
      );

      // 새로 생성된 커뮤니티의 ID를 가져옵니다
      const communityId = (
        await db.query("SELECT LAST_INSERT_ID() AS communityId")
      )[0].communityId;

      // 커뮤니티가 정상적으로 생성되었는지 확인
      if (!communityId) {
        return res.status(500).send(createResponse(500, "커뮤니티 생성 실패"));
      }

      // 이미지 URL을 CommunityImage 테이블에 삽입
      await db.query(
        "INSERT INTO CommunityImage (communityId, url) VALUES (?, ?)",
        [communityId, file.path] // order 열 제거
      );

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

// 커뮤니티 수정 - PUT 요청
exports.update = [
  upload.single("file"), // 단일 파일 업로드
  async (req, res) => {
    const { communityId, memberId, detail } = req.body;
    const file = req.file; // 업로드된 파일 처리 변수

    if (!communityId || !memberId || !detail) {
      return res
        .status(400)
        .send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
      // 커뮤니티 데이터 업데이트
      await db.query(
        "UPDATE Community SET memberId = ?, detail = ?, updatedAt = NOW() WHERE communityId = ?",
        [memberId, detail, communityId]
      );

      // 새로운 이미지가 업로드되었는지 확인
      if (file) {
        // 기존 이미지 URL을 가져와서 삭제합니다.
        const [existingImage] = await db.query(
          "SELECT url FROM CommunityImage WHERE communityId = ? LIMIT 1",
          [communityId]
        );

        if (existingImage) {
          // 파일 시스템에서 기존 이미지 삭제
          const existingImagePath = existingImage.url;
          if (fs.existsSync(existingImagePath)) {
            fs.unlinkSync(existingImagePath);
          }

          // 기존 이미지를 삭제합니다.
          await db.query("DELETE FROM CommunityImage WHERE communityId = ?", [
            communityId,
          ]);
        }

        // 새로운 이미지 URL을 CommunityImage 테이블에 삽입
        await db.query(
          "INSERT INTO CommunityImage (communityId, url) VALUES (?, ?)",
          [communityId, file.path]
        );
      }

      const response = createResponse(200, "커뮤니티 수정 성공", {
        communityId,
      });
      res.status(200).send(response);
    } catch (error) {
      console.error("Query error:", error);
      res.status(500).send(createResponse(500, "서버 에러"));
    }
  },
];

// 커뮤니티 삭제 -- 수정 필요
exports.deleteCommunity = async (req, res) => {
  const { communityId } = req.body;

  if (!communityId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const community = await repository.getCommunityById(communityId);

    if (!community) {
      return res
        .status(400)
        .send(createResponse(400, "존재하지 않는 커뮤니티입니다."));
    }

    await db.query("DELETE FROM Comment WHERE community_id = ?", [communityId]);

    const imagePaths = await db.query(
      "SELECT url FROM CommunityImage WHERE community_id = ?",
      [communityId]
    );

    await repository.deleteCommunityById(communityId);

    imagePaths.forEach((image) => {
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

// 댓글 조회
exports.getComments = async (req, res) => {
    const communityIdString = req.params.communityId;
    const communityId = parseInt(communityIdString, 10);

  try {
    const comments = await repository.getCommentsByCommunityId(communityId);

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

// 댓글 저장
exports.storeComment = async (req, res) => {
  const communityId = req.params.communityId;
  const { memberId, isCommentForComment, parentComment, detail } = req.body;

  if ( !memberId || !detail ) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    await repository.storeComment({
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

// 댓글 삭제
exports.deleteComment = async (req, res) => {
  const commentId = req.params.commentId;
  const memberId = req.body.memberId;

  try {
    const isOwned = await repository.checkCommentOwnership(commentId, memberId);
    
    if (!isOwned) {
      console.log('Comment not found or you do not have permission to delete this comment.');
      return res.status(404).send(createResponse(404, '댓글을 찾을 수 없거나 삭제 권한이 없습니다.'));
    }

    await repository.deleteCommentById(commentId);
    const response = createResponse(200, '댓글을 성공적으로 삭제했습니다.');
    res.send(response);
  } catch (error) {
    console.error('Query error:', error);
    res.status(500).send(createResponse(500, '서버 오류'));
  }
};


// 좋아요 추가
exports.storeLike = async (req, res) => {
  const memberId = req.body.memberId;
  const feedId = req.params.communityId;

  if (!memberId || !feedId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const alreadyLiked = await repository.checkIfAlreadyLiked(memberId, feedId);
    if (alreadyLiked) {
      return res
        .status(401)
        .send(createResponse(401, "이미 좋아요를 누른 게시글입니다."));
    }

    await repository.likeCommunityPost(memberId, feedId);
    const response = createResponse(200, "커뮤니티 좋아요 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};

// 좋아요 취소
exports.unlike = async (req, res) => {
  const memberId = req.body.memberId;
  const feedId = req.params.communityId;

  if (!memberId || !feedId) {
    return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
  }

  try {
    const alreadyLiked = await repository.checkIfAlreadyLiked(memberId, feedId);
    if (!alreadyLiked) {
      return res
        .status(401)
        .send(createResponse(401, "이미 좋아요가 해제된 게시글입니다."));
    }

    await repository.unlikeCommunityPost(memberId, feedId);
    const response = createResponse(200, "커뮤니티 좋아요 취소 성공");
    res.status(200).send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 에러"));
  }
};
