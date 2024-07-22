const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');
const repository = require('./repository');

exports.index = async (req, res) => {
    try {
        // Review 테이블에서 모든 리뷰 가져옴(임시)
        const reviews = await db.query('SELECT * FROM Review ORDER BY createdAt DESC');     // 최신순으로

        const data = await Promise.all(reviews.map(async review => {
            const imageUrlResult = await db.query('SELECT url FROM ReviewImage WHERE ReviewImage.reviewId = ?', [review.reviewId]);
            let imageUrl = null;
            if (imageUrlResult.length > 0) {
                imageUrl = imageUrlResult[0].url;
            }
            const tags = await db.query('SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?', [review.reviewId]);
            const tagNames = tags.map((tag, index) => tag.name + (index < tags.length - 1 ? '/' : '')).join(''); // 마지막 태그는 / 삭제
            const likeCount = await db.query('SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1', [review.reviewId]);
            const questionCount = await db.query('SELECT COUNT(*) AS count FROM Question WHERE reviewId = ?', [review.reviewId]);

            return {
                reviewId: review.reviewId,
                title: review.title,
                detail: review.detail.substring(0, 20),  // 미리보기용 20자로 자르기
                imageUrl: imageUrl,
                likeCount: likeCount[0].count,
                questionCount: questionCount[0].count,
                tags: tagNames
            };
        }));

        const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', { reviews: data });
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send('서버 오류가 발생했습니다.');
    }
};


exports.products = async (req, res) => {
    console.log('Product list');

    const { brandSearch, productSearch } = req.body;

    try {
        const products = await repository.searchProducts(brandSearch, productSearch);
        const formattedProducts = products.map(product => ({
            productId: product.productId,
            productName: product.name,
            brandName: product.brand
        }));
        
        const response = createResponse(200, '제품 리스트가 성공적으로 반환되었습니다.', { products: formattedProducts });
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }
};

exports.store = async (req, res) => {
    console.log('Store Review')
    const { memberId, title, detail, productId, score, tagIds } = req.body;
    const file = req.file;

    try {
        // 1. Review 객체 생성
        const result = await db.query(
            'INSERT INTO Review (memberId, title, detail, productId, score, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, NOW(), NOW())',
            [memberId, title, detail, productId, score]
        );
        
        const reviewId = result.insertId;

        // 2. SelectedTag 객체 생성
        const tags = tagIds.split('/');
        for (const tagId of tags) {
            await db.query(
                'INSERT INTO SelectedTag (reviewId, tagId) VALUES (?, ?)',
                [reviewId, tagId]
            );
        }

        // 3. ReviewImage 객체 생성
        if (file) {
            await db.query(
                'INSERT INTO ReviewImage (url, reviewId) VALUES (?, ?)',
                ["https://img1.daumcdn.net/thumb/R658x0.q70/?fname=https://t1.daumcdn.net/news/202105/21/dailylife/20210521220226237nxoo.jpg", reviewId] // 원래는 [file.path, reviewId] 로 s3업로드 url을 주지만 일단 임시 url 넣음, 콩 나오면 성공
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
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }
};

exports.uploadImage = (req, res) => {
    res.send('Upload review image');
};

exports.deleteImage = (req, res) => {
    res.send('Delete review image');
};


exports.getDetail = async (req, res) => {
    console.log(`Detail review ${req.params.reviewId}`);
    const { memberId } = req.body;
    console.log(`memberId ${memberId}`);
    const reviewId = req.params.reviewId;

    try {
        // 1. review 객체 찾기
        let [reviewDetail] = await db.query(
            `SELECT * FROM Review WHERE reviewId = ?`,
            [reviewId]
        );
        console.log(reviewDetail);  // 체크

        if (!reviewDetail) {
            console.log('No rows returned from query');
            return res.status(404).send(createResponse(404, '리뷰를 찾을 수 없습니다.'));
        }

        // 2. reviewImage
        const reviewImageUrl = await repository.getReviewImageByReviewId(reviewId) || null;
        console.log(reviewImageUrl);

        // 3. search product
        const [product] = await db.query(
            `SELECT * FROM Product WHERE productId = ?`,
            [reviewDetail.productId || null]
        );

        console.log(product);
        if (!product || product.length === 0) {
            console.log('No product found with the given productId');
            return res.status(404).send(createResponse(404, '해당 제품을 찾을 수 없습니다.'));
        }

        const [writer] = await db.query(
            `SELECT memberId, profileImageUrl, name FROM Member WHERE memberId = ?`,
            [reviewDetail.memberId || null]
        );

        const tagRows = await db.query('SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?', [reviewId]);
        const tags = tagRows.map((tag, index) => tag.name + (index < tagRows.length - 1 ? '/' : '')).join(''); // 마지막 태그는 / 삭제
        console.log(tags);

        const like = await db.query(
            'SELECT state FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = ?',
            [memberId || null, reviewId || null, 0]
        );

        const scrap = await db.query(
            `SELECT state FROM Scrap WHERE memberId = ? AND feedId = ?`,
            [memberId || null, reviewId || null]
        );

        const likeCountResult = await db.query(
            'SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1 AND likeType = 0',
            [reviewId || null]
        );
        const likeCount = likeCountResult[0].count;
        const questionCountResult = await db.query('SELECT COUNT(*) AS count FROM Scrap WHERE feedId = ? AND state = 1', [reviewId || null]);
        const questionCount = questionCountResult[0].count;

        const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', {
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
                updatedAt: reviewDetail.updatedAt
            },
            product,
            writer
        });

        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }
};

exports.delete = async (req, res) => {
    console.log(`Delete review ${req.params.reviewId}`);
    const { memberId } = req.body;
    const reviewId = req.params.reviewId;

    try {
        // 리뷰의 memberId 사용자와 일치?
        const [review] = await db.query('SELECT * FROM Review WHERE reviewId = ? AND memberId = ?', [reviewId, memberId]);
        if (!review) {
            console.log('Review not found or you do not have permission to delete this review.');
            return res.status(404).send(createResponse(404, '리뷰를 찾을 수 없거나 삭제 권한이 없습니다.'));
        }

        // 삭제 로직
        await repository.deleteLikesByReviewId(reviewId);
        await repository.deleteScrapsByReviewId(reviewId);
        await repository.deleteQuestionsByReviewId(reviewId);
        await repository.deleteImageByReviewId(reviewId);
        await repository.deleteSelectedTagsByReviewId(reviewId);
        await repository.deleteReviewById(reviewId);

        const response = createResponse(200, '리뷰가 성공적으로 삭제되었습니다.');
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }

    

};

exports.update = (req, res) => {
    console.log(`Update review ${req.params.reviewId}`);
};

exports.getQuestions = async (req, res) => {
    console.log(`Get comments for review ${req.params.reviewId}`);
    const reviewId = req.params.reviewId;

    try{
        const questions = await repository.getQuestionAllByReviewId(reviewId);
        const response = createResponse(200, '리뷰 댓글이 성공적으로 조회되었습니다.', {questions});
        res.send(response);

    }catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }

};

exports.storeQuestion = async (req, res) => {
    console.log(`Store comment for review ${req.params.reviewId}`);
    let createDTO = req.body;
    createDTO.reviewId = req.params.reviewId;

    try{
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
        const isOwned = await db.query('SELECT * FROM Question WHERE questionId = ? AND memberId = ?', [req.params.questionId, memberId]);
        console.log(isOwned);
        if (isOwned.length < 1) {
            console.log('Question not found or you do not have permission to delete this question.');
            return res.status(404).send(createResponse(404, '리뷰의 해당 댓글을 찾을 수 없거나 삭제 권한이 없습니다.'));
        }
        await repository.deleteQuestionById(req.params.questionId);
        const response = createResponse(200, '리뷰 댓글을 성공적으로 삭제했습니다.');
        res.send(response);
    } catch (error) {
        console.error('Query error:', error);
        res.status(500).send(createResponse(500, '서버 오류'));
    }
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
