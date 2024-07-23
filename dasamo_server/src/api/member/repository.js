const db = require('../../config/dbConfig');

const getMemberByEmail = async (email) => {
    const rows = await db.query('SELECT * FROM Member WHERE email = ?', [email]);
    return rows;
};

const getMemberIdByEmail = async (email) => {
    const rows = await db.query('SELECT memberId FROM Member WHERE email = ?', [email]);
    return rows;
};

const getMemberById = async (memberId) => {
    const rows = await db.query('SELECT profileImageUrl, name FROM Member WHERE memberId = ?', [memberId]);
    return rows;
};

const getReviewsByMemberId = async (memberId) => {
    const rows = await db.query(`SELECT
        i.url AS imageUrl,
        r.reviewId
        FROM Review r
        JOIN ReviewImage i ON r.reviewId = i.reviewId
        WHERE memberId = ?
        ORDER BY r.createdAt DESC
        `, [memberId]);
    return rows;
};

const getCommunitiesByMemberId = async (memberId) => {
    const rows = await db.query(`SELECT
        i.url AS imageUrl,
        c.communityId
        FROM Community c
        JOIN CommunityImage i ON c.communityId = i.communityId
        WHERE memberId = ?
        ORDER BY c.createdAt DESC
        `, [memberId]);
    return rows;
};

const getScrapsByMemberId = async (memberId) => {
    const rows = await db.query(`SELECT
        ri.url AS imageUrl,
        r.reviewId
    FROM
        Scrap s
    JOIN
        Review r ON s.feedId = r.reviewId
    JOIN
        ReviewImage ri ON r.reviewId = ri.reviewId
    WHERE
        s.memberId = ? AND s.state = 1
    ORDER BY s.createdAt DESC
`, [memberId]);
    return rows;
};

module.exports = {
    getMemberByEmail,
    getMemberById,
    getReviewsByMemberId,
    getCommunitiesByMemberId,
    getScrapsByMemberId
};