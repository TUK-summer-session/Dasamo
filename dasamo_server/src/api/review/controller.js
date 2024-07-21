const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');
const repository = require('./repository');

exports.index = async (req, res) => {
    try {
        // Review 테이블에서 모든 리뷰 가져옴(임시)
        const reviews = await db.query('SELECT * FROM Review');

        const data = await Promise.all(reviews.map(async review => {
            const imageUrlResult = await db.query('SELECT url FROM ReviewImage WHERE `order` = 1 AND ReviewImage.reviewId = ?', [review.reviewId]);
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

exports.store = (req, res) => {
    res.send('Store review');
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
            return;
        }

        // 2. search product
        const [product] = await db.query(
            `SELECT * FROM Product WHERE productId = ?`,
            [reviewDetail.productId]
        );

        console.log(product);
        if (product.length === 0) {
            console.log('No product found with the given productId');
            return res.status(404).send(createResponse);
        }


        const [writer] = await db.query(
            `SELECT memberId, profileImageUrl FROM Member WHERE memberId = ?`,
            [reviewDetail.memberId]
        );

        const tagRows = await db.query('SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?', [reviewId]);
        const tags = tagRows.map((tag, index) => tag.name + (index < tagRows.length - 1 ? '/' : '')).join(''); // 마지막 태그는 / 삭제
        console.log(tags)


        const like = await db.query(
            'SELECT state FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = ?',
            [memberId, reviewId, 0]
        );
        console.log(like);

        const scrap = await db.query(
            `SELECT state FROM Scrap WHERE memberId = ? AND feedId = ?`,
            [memberId, reviewId]
        );

        const likeCountResult = await db.query(
            'SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1 AND likeType = 0',
            [reviewId]
        );
        const likeCount = likeCountResult[0].count;
        const questionCountResult = await db.query('SELECT COUNT(*) AS count FROM Scrap WHERE feedId = ? AND state = 1', [reviewId]);
        const questionCount = questionCountResult[0].count;


        const response = createResponse(200, '요청이 성공적으로 처리되었습니다.', {
            reviewDetail: {
                reviewId: reviewDetail.reviewId,
                title: reviewDetail.title,
                detail: reviewDetail.detail,
                score: reviewDetail.score,
                isLiked: like && like[0].state === 1,
                isScraped: scrap && scrap[0].state === 1,
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
