const db = require("../../config/dbConfig");

const getCommunityById = async (communityId) => {
  const result = await db.query("SELECT * FROM Community WHERE community_id = $1", [communityId]);
  return result.rows[0];
};

const checkCommunityOwnership = async (memberId, communityId) => {
  const result = await db.query('SELECT * FROM Community WHERE communityId = ? AND memberId = ?', [communityId, memberId]);
  return result.length > 0;
}

const getCommunitiesWithMembers = async (memberId) => {
  try {
    const result = await db.query(`
      SELECT
        c.communityId,
        c.detail,
        c.createdAt,
        c.updatedAt,
        i.communityImageId,
        i.url,
        m.memberId,
        m.email,
        m.name,
        m.profileImageUrl,
        IF(l.likeType = 1, TRUE, FALSE) AS isLiked
      FROM Community c
      JOIN CommunityImage i ON c.communityId = i.communityId
      JOIN Member m ON c.memberId = m.memberId
      LEFT JOIN \`Like\` l ON c.communityId = l.feedId AND l.likeType = 1 AND l.memberId = ?
      ORDER BY c.createdAt DESC
    `, [memberId]);
    return result;
  } catch (error) {
    throw new Error('쿼리 실행 중 오류 발생');
  }
};



const deleteCommunityById = async (communityId) => {
  await db.query("DELETE FROM Community WHERE communityId = ?", [communityId]);
};

const deleteImageByCommunityId = async (communityId) => {
  await db.query('DELETE FROM CommunityImage WHERE communityId = ?', [communityId]);
};

const deleteCommentByCommunityId = async (communityId) => {
  await db.query('DELETE FROM Comment WHERE communityId = ?', [communityId]);
};

const deleteLikesByCommunityId = async (feedId) => {
  await db.query('DELETE FROM `Like` WHERE feedId = ? AND likeType = ?', [feedId, 1]);
};


const getCommentsByCommunityId = async (communityId) => {
  const comments = await db.query(`
      SELECT
          q.commentId,
          q.memberId,
          m.name,
          m.profileImageUrl,
          q.isCommentForComment,
          q.parentComment,
          q.detail,
          q.createdAt,
          q.updatedAt
      FROM Comment q
      JOIN Member m ON q.memberId = m.memberId
      WHERE q.communityId = ?
      ORDER BY q.createdAt DESC
  `, [communityId]);
  return comments;
};

const storeComment = async (commentData) => {
  const { memberId, communityId, isCommentForComment, parentComment, detail } = commentData;
  const result = await db.query(`
    INSERT INTO Comment (memberId, communityId, isCommentForComment, parentComment, detail, createdAt, updatedAt)
    VALUES (?, ?, ?, ?, ?, NOW(), NOW());
  `, [memberId, communityId, isCommentForComment, parentComment, detail]);

  return result;
};

const checkIfAlreadyLiked = async (memberId, feedId) => {
  const result = await db.query("SELECT * FROM `Like` WHERE memberId = ? AND feedId = ? AND `likeType` = 1", [memberId, feedId]);
  return result.length > 0;
};

const likeCommunityPost = async (memberId, feedId) => {
  const result = await db.query("INSERT INTO `Like` (memberId, feedId, likeType, state, createdAt) VALUES (?, ?, 1, 1, NOW())", [memberId, feedId]);
  return result;
};

const unlikeCommunityPost = async (memberId, feedId) => {
  const result = await db.query("DELETE FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = 1 AND state = 1", [memberId, feedId]);
  return result;
};

const checkIsLiked = async (member, feedId) => { 
  const result = db.query(
    'SELECT state FROM `Like` WHERE memberId = ? AND feedId = ? AND likeType = ?',
    [memberId, feedId, 1]);
    return result.length > 0;

};

const checkCommentOwnership = async (commentId, memberId) => {
  const query = `SELECT * FROM Comment WHERE commentId = ? AND memberId = ?`;
  const result = await db.query(query, [commentId, memberId]);
  return result.length > 0;
};

const deleteCommentById = async (commentId) => {
  await db.query('DELETE FROM Comment WHERE commentId = ?', [commentId]);
};

module.exports = {
  getCommunityById,
  checkCommunityOwnership,
  deleteCommunityById,
  deleteCommentByCommunityId,
  getCommentsByCommunityId,
  storeComment,
  checkIfAlreadyLiked,
  likeCommunityPost,
  unlikeCommunityPost,
  getCommunitiesWithMembers,
  checkIsLiked,
  deleteCommentById,
  checkCommentOwnership,
  deleteImageByCommunityId,
  deleteLikesByCommunityId,
};
