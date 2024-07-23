const db = require("../../config/dbConfig");
const createResponse = require("../../utils/response");
const repository = require("./repository");
const upload = require("../../config/multer");

exports.index = async (req, res) => {
  try {
    // Review 테이블에서 모든 리뷰 가져옴(임시)
    const reviews = await db.query(
      "SELECT * FROM Review ORDER BY createdAt DESC"
    ); // 최신순으로

    const data = await Promise.all(
      reviews.map(async (review) => {
        const imageUrlResult = await db.query(
          "SELECT url FROM ReviewImage WHERE ReviewImage.reviewId = ?",
          [review.reviewId]
        );
        let imageUrl = null;
        if (imageUrlResult.length > 0) {
          imageUrl = imageUrlResult[0].url;
        }
        const tags = await db.query(
          "SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?",
          [review.reviewId]
        );
        const tagNames = tags
          .map((tag, index) => tag.name + (index < tags.length - 1 ? "/" : ""))
          .join(""); // 마지막 태그는 / 삭제
        const likeCount = await db.query(
          "SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1",
          [review.reviewId]
        );
        const bookMarkState = await db.query(
          "SELECT COUNT(*) AS count FROM `Scrap` WHERE feedId = ? AND state = 1",
          [review.reviewId]
        )
        const questionCount = await db.query(
          "SELECT COUNT(*) AS count FROM Question WHERE reviewId = ?",
          [review.reviewId]
        );

        return {
          reviewId: review.reviewId,
          memberId: review.memberId,
          title: review.title,
          detail: review.detail.substring(0, 20), // 미리보기용 20자로 자르기
          imageUrl: imageUrl,
          likeCount: likeCount[0].count,
          questionCount: questionCount[0].count,
          tags: tagNames,
        };
      })
    );

    const response = createResponse(200, "요청이 성공적으로 처리되었습니다.", {
      reviews: data,
    });
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send("서버 오류가 발생했습니다.");
  }
};

exports.products = async (req, res) => {
  console.log("Product list");

  try {
    const products = await repository.getAllProducts();
    const response = createResponse(
      200,
      "제품 리스트가 성공적으로 반환되었습니다.",
      { products: products }
    );
    res.send(response);
  } catch (error) {
    console.log("Query error : ", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
};

exports.store = async (req, res) => {
    console.log("Store Review");
    const { memberId, title, detail, productId, score, tagIds } = req.body;
    const file = req.file;
    
  
    try {
      // `memberId`를 숫자로 변환
      console.log("memberId: ", memberId);
  
      // 1. Review 객체 생성
      const result = await db.query(
        "INSERT INTO Review (memberId, title, detail, productId, score, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, NOW(), NOW())",
        [memberId, title, detail, productId, score]
      );
  
      const reviewId = result.insertId;
  
      // 2. SelectedTag 객체 생성
      const tags = tagIds.split("/").map(Number); // 문자열을 숫자로 변환
      for (const tagId of tags) {
        await db.query(
          "INSERT INTO SelectedTag (reviewId, tagId) VALUES (?, ?)",
          [reviewId, tagId]
        );
        }

        // 3. ReviewImage 객체 생성
        if (file) {
            await db.query(
                'INSERT INTO ReviewImage (url, reviewId) VALUES (?, ?)',
                [file.location, reviewId] 
            );
        } else {
            await db.query(
                'INSERT INTO ReviewImage (url, reviewId) VALUES (?, ?)',
                ["https://cdn.pixabay.com/photo/2016/09/20/07/25/food-1681977_1280.png", reviewId] // 사과 넣으면 파일 업로드 실패
            );
        }

        const response = createResponse(200, '리뷰가 성공적으로 생성되었습니다.', { reviewId });
        res.send(response);
    } catch (error) {
      console.error("Query error:", error);
      res.status(500).send(createResponse(500, `서버 오류`));
    }
  };
  

exports.uploadImage = (req, res) => {
  res.send("Upload review image");
};

exports.deleteImage = (req, res) => {
  res.send("Delete review image");
};

exports.getDetail = async (req, res) => {
    console.log(`Detail review ${req.params.reviewId}`);
    const memberId = parseInt(req.query.memberId, 10);
    console.log(`memberId ${memberId}`);
    const reviewId = req.params.reviewId;
  
    try {
      // 1. review 객체 찾기
      let [reviewDetail] = await db.query(
        `SELECT * FROM Review WHERE reviewId = ?`,
        [reviewId]
      );
      console.log(reviewDetail); // 체크
  
      if (!reviewDetail) {
        console.log("No rows returned from query");
        return res
          .status(404)
          .send(createResponse(404, "리뷰를 찾을 수 없습니다."));
      }
  
      // 2. reviewImage
      const reviewImageUrl =
        (await repository.getReviewImageByReviewId(reviewId)) || null;
      console.log(reviewImageUrl);
  
      // 3. search product
      const [product] = await db.query(
        `SELECT * FROM Product WHERE productId = ?`,
        [reviewDetail.productId || null]
      );
  
      console.log(product);
      if (!product || product.length === 0) {
        console.log("No product found with the given productId");
        return res
          .status(404)
          .send(createResponse(404, "해당 제품을 찾을 수 없습니다."));
      }
  
      const [writer] = await db.query(
        `SELECT memberId, profileImageUrl, name FROM Member WHERE memberId = ?`,
        [reviewDetail.memberId || null]
      );
  
      const tagRows = await db.query(
        "SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?",
        [reviewId]
      );
      const tags = tagRows
        .map((tag, index) => tag.name + (index < tagRows.length - 1 ? "/" : ""))
        .join(""); // 마지막 태그는 / 삭제
      console.log(tags);
  
      const like = await db.query(
        "SELECT state FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = ?",
        [memberId || null, reviewId || null, 0]
      );
  
      const scrap = await db.query(
        `SELECT state FROM Scrap WHERE memberId = ? AND feedId = ?`,
        [memberId || null, reviewId || null]
      );
  
      const likeCountResult = await db.query(
        "SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1 AND likeType = 0",
        [reviewId || null]
      );
      const likeCount = likeCountResult[0].count;
      const questionCountResult = await db.query(
        "SELECT COUNT(*) AS count FROM Scrap WHERE feedId = ? AND state = 1",
        [reviewId || null]
      );
      const questionCount = questionCountResult[0].count;
  
      // Check if the current user is the author of the review
      const isAuthor = reviewDetail.memberId === memberId;
  
      const response = createResponse(200, "요청이 성공적으로 처리되었습니다.", {
        reviewDetail: {
          reviewId: reviewDetail.reviewId,
          title: reviewDetail.title,
          detail: reviewDetail.detail,
          imageUrl: reviewImageUrl,
          score: reviewDetail.score,
          isLiked: like.length > 0 && like[0].state === 1,
          isScraped: scrap.length > 0 && scrap[0].state === 1,
          likeCount: likeCount,
          questionCount: questionCount,
          tags: tags,
          createdAt: reviewDetail.createdAt,
          updatedAt: reviewDetail.updatedAt,
        },
        product,
        writer,
        isAuthor, // Add isAuthor to the response
      });
  
      res.send(response);
    } catch (error) {
      console.error("Query error:", error);
      res.status(500).send(createResponse(500, "서버 오류"));
    }
  };
  

exports.delete = async (req, res) => {
  console.log(`Delete review ${req.params.reviewId}`);
  const { memberId } = req.body;
  const reviewId = req.params.reviewId;

  try {
    // 리뷰의 memberId 사용자와 일치?
    const [review] = await db.query(
      "SELECT * FROM Review WHERE reviewId = ? AND memberId = ?",
      [reviewId, memberId]
    );
    if (!review) {
      console.log(
        "Review not found or you do not have permission to delete this review."
      );
      return res
        .status(404)
        .send(
          createResponse(404, "리뷰를 찾을 수 없거나 삭제 권한이 없습니다.")
        );
    }

    // 삭제 로직
    await repository.deleteLikesByReviewId(reviewId);
    await repository.deleteScrapsByReviewId(reviewId);
    await repository.deleteQuestionsByReviewId(reviewId);
    await repository.deleteImageByReviewId(reviewId);
    await repository.deleteSelectedTagsByReviewId(reviewId);
    await repository.deleteReviewById(reviewId);

    const response = createResponse(200, "리뷰가 성공적으로 삭제되었습니다.");
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }

};

exports.update = (req, res) => {
  console.log(`Update review ${req.params.reviewId}`);
};

exports.getQuestions = async (req, res) => {
  console.log(`Get comments for review ${req.params.reviewId}`);
  const reviewId = req.params.reviewId;

  try {
    const questions = await repository.getQuestionAllByReviewId(reviewId);
    const response = createResponse(
      200,
      "리뷰 댓글이 성공적으로 조회되었습니다.",
      { questions }
    );
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
    try {
        const questions = await repository.getQuestionAllByReviewId(reviewId);
        const response = createResponse(200, '리뷰 댓글이 성공적으로 조회되었습니다.', { questions });
        res.send(response);

    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }

};

exports.storeQuestion = async (req, res) => {
  console.log(`Store comment for review ${req.params.reviewId}`);
  let createDTO = req.body;
  createDTO.reviewId = req.params.reviewId;

  try {
    await repository.storeQuestions(createDTO);
    const response = createResponse(
      200,
      "리뷰 댓글을 성공적으로 저장했습니다."
    );
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
    try {
        await repository.storeQuestions(createDTO);
        const response = createResponse(200, '리뷰 댓글을 성공적으로 저장했습니다.');
        res.send(response);

    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }
};

exports.deleteQuestion = async (req, res) => {
  console.log(`Delete comment ${req.params.questionId}`);
  const { memberId } = req.body;
  try {
    const isOwned = await db.query(
      "SELECT * FROM Question WHERE questionId = ? AND memberId = ?",
      [req.params.questionId, memberId]
    );
    console.log(isOwned);
    if (isOwned.length < 1) {
      console.log(
        "Question not found or you do not have permission to delete this question."
      );
      return res
        .status(404)
        .send(
          createResponse(
            404,
            "리뷰의 해당 댓글을 찾을 수 없거나 삭제 권한이 없습니다."
          )
        );
    }
    await repository.deleteQuestionById(req.params.questionId);
    const response = createResponse(
      200,
      "리뷰 댓글을 성공적으로 삭제했습니다."
    );
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
};

// 태그 리스트 불러오기 api
exports.getTags = async (req, res) => {
  try {
    // 1. 전체 태그를 데이터베이스에서 조회
    const tags = await db.query("SELECT * FROM Tag");

    const result = tags.map((row) => ({
      tagId: row.tagId,
      name: row.name,
    }));

    // 2. 조회된 태그를 클라이언트에 응답
    const response = createResponse(
      200,
      "태그 목록이 성공적으로 반환되었습니다.",
      { tags: result }
    );
    res.send(response);
  } catch (error) {
    console.error("Query error:", error);
    res.status(500).send(createResponse(500, "서버 오류"));
  }
};


// 좋아요 추가
exports.storeLike = async (req, res) => {
    const memberId = req.body.memberId;
    const feedId = req.params.reviewId;

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

        await repository.likeReviewPost(memberId, feedId);
        const response = createResponse(200, "리뷰 좋아요 성공");
        res.status(200).send(response);
    } catch (error) {
        console.error("Query error:", error);
        res.status(500).send(createResponse(500, "서버 에러"));
    }
};


// 좋아요 취소
exports.unlike = async (req, res) => {
    const memberId = req.body.memberId;
    const feedId = req.params.reviewId;

    if (!memberId || !feedId) {
        return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
        const alreadyLiked = await repository.checkIfAlreadyLiked(memberId, feedId);
        if (!alreadyLiked) {
            return res
                .status(401)
                .send(createResponse(401, "이미 리뷰 좋아요가 해제된 게시글입니다."));
        }

        await repository.unlikeReviewPost(memberId, feedId);
        const response = createResponse(200, "리뷰 좋아요 취소 성공");
        res.status(200).send(response);
    } catch (error) {
        console.error("Query error:", error);
        res.status(500).send(createResponse(500, "서버 에러"));
    }
};

exports.scrap = async (req, res) => {
    console.log(`Scrap review ${req.params.reviewId}`);
    const memberId = req.body.memberId;
    const feedId = req.params.reviewId;

    if (!memberId || !feedId) {
        return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
        const alreadyLiked = await repository.checkIfAlreadyScraped(memberId, feedId);
        if (alreadyLiked) {
            return res
                .status(401)
                .send(createResponse(401, "이미 스크랩한 게시글입니다."));
        }

        await repository.scrapReviewPost(memberId, feedId);
        const response = createResponse(200, "리뷰 스크랩 성공");
        res.status(200).send(response);
    } catch (error) {
        console.error("Query error:", error);
        res.status(500).send(createResponse(500, "서버 에러"));
    }
};

exports.unscrap = async (req, res) => {
    console.log(`Unscrap review ${req.params.reviewId}`);
    const memberId = req.body.memberId;
    const feedId = req.params.reviewId;

    if (!memberId || !feedId) {
        return res.status(400).send(createResponse(400, "요청이 잘못되었습니다."));
    }

    try {
        const alreadyLiked = await repository.checkIfAlreadyScraped(memberId, feedId);
        if (!alreadyLiked) {
            return res
                .status(401)
                .send(createResponse(401, "이미 스크랩이 해제된 게시글입니다."));
        }

        await repository.unscrapReviewPost(memberId, feedId);
        const response = createResponse(200, "리뷰 스크랩 취소 성공");
        res.status(200).send(response);
    } catch (error) {
        console.error("Query error:", error);
        res.status(500).send(createResponse(500, "서버 에러"));
    }
    
}

