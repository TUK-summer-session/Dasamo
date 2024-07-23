const db = require('../../config/dbConfig');
const createResponse = require('../../utils/response');

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

const getReviewImageByReviewId = async (reviewId) => {
    const imageUrlResult = await db.query('SELECT url FROM ReviewImage WHERE ReviewImage.reviewId = ?', [reviewId]);
    let imageUrl = null;
    if (imageUrlResult.length > 0) {
        imageUrl = imageUrlResult[0].url;
    }
    return imageUrl;
};

const getQuestionAllByReviewId = async (reviewId) => {
    const questions = await db.query(`
        SELECT
            q.questionId,
            q.memberId,
            m.name,
            m.profileImageUrl,
            q.isQuestionForQuestion,
            q.parentQuestion,
            q.detail,
            q.createdAt,
            q.updatedAt
        FROM Question q
        JOIN Member m ON q.memberId = m.memberId
        WHERE q.reviewId = ?
        ORDER BY q.createdAt DESC
    `, [reviewId]);
    return questions;
};

const storeQuestions = async (createDTO) => {
    const result = await db.query(
        'INSERT INTO Question (memberId, reviewId, isQuestionForQuestion, parentQuestion, detail, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, NOW(), NOW())',
        [createDTO.memberId, createDTO.reviewId, createDTO.isQuestionForQuestion, createDTO.parentQuestion, createDTO.detail]
    );
}



const searchProducts = async (brandSearch, productSearch) => {
    const products = await db.query(
        'SELECT productId, name, brand FROM Product WHERE brand LIKE ? AND name LIKE ?',
        [`%${brandSearch}%`, `%${productSearch}%`]
    );
    return products;
};

const getAllProducts = async () => {
    const allProducts = await db.query(
        'SELECT * FROM Product;'
    );
    return allProducts;
}

const deleteReviewById = async (reviewId) => {
    await db.query('DELETE FROM Review WHERE reviewId = ?', [reviewId]);
};

const deleteSelectedTagsByReviewId = async (reviewId) => {
    await db.query('DELETE FROM SelectedTag WHERE reviewId = ?', [reviewId]);
};

const deleteLikesByReviewId = async (reviewId) => {
    await db.query('DELETE FROM `Like` WHERE feedId = ?', [reviewId]);
};

const deleteScrapsByReviewId = async (reviewId) => {
    await db.query('DELETE FROM Scrap WHERE feedId = ?', [reviewId]);
};

const deleteImageByReviewId = async (reviewId) => {
    await db.query('DELETE FROM ReviewImage WHERE reviewId = ?', [reviewId]);
};

const deleteQuestionsByReviewId = async (reviewId) => {
    await db.query('DELETE FROM Question WHERE reviewId = ?', [reviewId]);
};

const deleteQuestionById = async (questionId) => {
    await db.query('DELETE FROM Question WHERE questionId = ?', [questionId]);
};

const checkIfAlreadyLiked = async (memberId, feedId) => {
    const result = await db.query("SELECT * FROM `Like` WHERE memberId = ? AND feedId = ? AND `likeType` = 0", [memberId, feedId]);
    return result.length > 0;
};

const likeReviewPost = async (memberId, feedId) => {
    const result = await db.query("INSERT INTO `Like` (memberId, feedId, likeType, state, createdAt) VALUES (?, ?, 0, 1, NOW())", [memberId, feedId]);
    return result;
};

const unlikeReviewPost = async (memberId, feedId) => {
    const result = await db.query("DELETE FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = 0 AND state = 1", [memberId, feedId]);
    return result;
};

const checkIfAlreadyScraped = async (memberId, feedId) => {
    const result = await db.query("SELECT * FROM Scrap WHERE memberId = ? AND feedId = ?", [memberId, feedId]);
    return result.length > 0;
};

const scrapReviewPost = async (memberId, feedId) => {
    const result = await db.query("INSERT INTO Scrap (memberId, feedId, state, createdAt) VALUES (?, ?, 1, NOW())", [memberId, feedId]);
    return result;
};

const unscrapReviewPost = async (memberId, feedId) => {
    const result = await db.query("DELETE FROM Scrap WHERE memberId = ? AND feedId = ? AND state = 1", [memberId, feedId]);
    return result;
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
    getQuestionAllByReviewId,
    getReviewImageByReviewId,
    storeQuestions,
    searchProducts,
    deleteReviewById,
    deleteSelectedTagsByReviewId,
    deleteLikesByReviewId,
    deleteScrapsByReviewId,
    deleteImageByReviewId,
    deleteQuestionsByReviewId,
    deleteQuestionById,
    checkIfAlreadyLiked,
    likeReviewPost,
    unlikeReviewPost,
    checkIfAlreadyScraped,
    scrapReviewPost,
    unscrapReviewPost
    getAllProducts
    deleteQuestionById,
};
