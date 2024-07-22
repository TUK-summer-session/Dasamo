const db = require("../../config/dbConfig");

const getCommunityById = async (communityId) => {
  const result = await db.query("SELECT * FROM Community WHERE community_id = $1", [communityId]);
  return result.rows[0];
};

// 커뮤니티와 회원, 이미지를 조인하여 가져오는 쿼리 함수
const getCommunitiesWithMembers = async () => {
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
        m.profileImageUrl
      FROM Community c
      JOIN CommunityImage i ON c.communityId = i.communityId
      JOIN Member m ON c.memberId = m.memberId
      ORDER BY c.createdAt DESC
    `);
    return result;
  } catch (error) {
    throw new Error('쿼리 실행 중 오류 발생');
  }
};

const deleteCommunityById = async (communityId) => {
  await db.query("DELETE FROM Community WHERE community_id = $1", [communityId]);
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

const checkIfAlreadyLiked = async (memberId, communityId) => {
  const result = await db.query("SELECT * FROM Likes WHERE member_id = $1 AND feed_id = $2 AND like_type = 1 AND state = 1", [memberId, communityId]);
  return result.rows.length > 0;
};

const likeCommunityPost = async (memberId, communityId) => {
  const result = await db.query("INSERT INTO Likes (member_id, feed_id, like_type, state, created_at) VALUES ($1, $2, 1, 1, NOW())", [memberId, communityId]);
  return result;
};

const unlikeCommunityPost = async (memberId, communityId) => {
  const result = await db.query("DELETE FROM Likes WHERE member_id = $1 AND feed_id = $2 AND like_type = 1 AND state = 1", [memberId, communityId]);
  return result;
};

module.exports = {
  getCommunityById,
  deleteCommunityById,
  getCommentsByCommunityId,
  storeComment,
  checkIfAlreadyLiked,
  likeCommunityPost,
  unlikeCommunityPost,
  getCommunitiesWithMembers,
};
