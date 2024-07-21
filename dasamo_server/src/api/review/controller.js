const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');

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
            const questionCount = await db.query('SELECT COUNT(*) AS count FROM Scrab WHERE feedId = ? AND state = 1', [review.reviewId]);

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
