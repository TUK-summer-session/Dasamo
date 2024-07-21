const db = require('../../config/dbConfig');

const getReviewById = async (reviewId) => {
    const [rows] = await db.query('SELECT * FROM Review WHERE reviewId = ?', [reviewId]);
    return rows[0];
};

const getProductById = async (productId) => {
    const [rows] = await db.query('SELECT * FROM Product WHERE productId = ?', [productId]);
    return rows[0];
};

const getMemberById = async (memberId) => {
    const [rows] = await db.query('SELECT memberId, profileImageUrl FROM Member WHERE memberId = ?', [memberId]);
    return rows[0];
};

const getTagsByReviewId = async (reviewId) => {
    const [tags] = await db.query(
        'SELECT name FROM Tag JOIN SelectedTag ON Tag.tagId = SelectedTag.tagId WHERE SelectedTag.reviewId = ?',
        [reviewId]
    );
    console.log(tags);
    return tags.map((tag, index) => tag.name + (index < tags.length - 1 ? '/' : '')).join('');
};


const getLikeState = async (memberId, feedId) => {
    const [rows] = await db.query(
        'SELECT state FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = 0',
        [memberId, feedId]
    );
    return rows[0];
};

const getScrapState = async (memberId, feedId) => {
    const [rows] = await db.query(
        'SELECT state FROM Scrap WHERE memberId = ? AND feedId = ?',
        [memberId, feedId]
    );
    return rows[0];
};

const getLikeCount = async (feedId) => {
    const [[result]] = await db.query(
        'SELECT COUNT(*) AS count FROM `Like` WHERE feedId = ? AND state = 1 AND likeType = 0',
        [feedId]
    );
    return result.count;
};

const getQuestionCount = async (feedId) => {
    const [[result]] = await db.query(
        'SELECT COUNT(*) AS count FROM Question WHERE reviewId = ?',
        [feedId]
    );
    return result.count;
};

const searchProducts = async (brandSearch, productSearch) => {
    const products = await db.query(
        'SELECT productId, name, brand FROM Product WHERE brand LIKE ? AND name LIKE ?',
        [`%${brandSearch}%`, `%${productSearch}%`]
    );
    return products;
};



module.exports = {
    getReviewById,
    getProductById,
    getMemberById,
    getTagsByReviewId,
    getLikeState,
    getScrapState,
    getLikeCount,
    getQuestionCount,
    searchProducts
};
