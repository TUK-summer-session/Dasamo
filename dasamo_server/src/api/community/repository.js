const db = require("../../config/dbConfig");

const getCommunityById = async (communityId) => {
  const result = await db.query("SELECT * FROM Community WHERE community_id = $1", [communityId]);
  return result.rows[0];
};

const deleteCommunityById = async (communityId) => {
  await db.query("DELETE FROM Community WHERE community_id = $1", [communityId]);
};

const getCommentsByCommunityId = async (communityId) => {
  const result = await db.query(`
    SELECT 
      comment_id AS "commentId",
      member_id AS "memberId",
      is_comment_for_comment AS "isCommentForComment",
      parent_comment AS "parentComment",
      detail,
      created_at AS "createdAt",
      updated_at AS "updatedAt"
    FROM Comment
    WHERE community_id = $1
    ORDER BY created_at ASC
  `, [communityId]);
  return result.rows;
};

const storeComment = async (commentData) => {
  const { memberId, communityId, isCommentForComment, parentComment, detail } = commentData;
  const result = await db.query(`
    INSERT INTO Comment (member_id, community_id, is_comment_for_comment, parent_comment, detail, created_at, updated_at)
    VALUES ($1, $2, $3, $4, $5, NOW(), NOW())
    RETURNING comment_id
  `, [memberId, communityId, isCommentForComment, parentComment, detail]);

  return result.rows[0];
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
};
