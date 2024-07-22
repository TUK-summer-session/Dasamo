const express = require('express');
const router = express.Router();

const multer = require('multer');
const upload = multer({ dest: 'storage/' });

const apiMemberController = require('../api/member/controller');
const apiReviewController = require('../api/review/controller');
const apiCommunityController = require('../api/community/controller');

const { logRequestTime } = require('../middleware/log');

// router.get('/', webController.home);
// router.get('/page/:route', logRequestTime, webController.page);
router.use(logRequestTime);

// File upload
router.post('/file', upload.single('file'), (req, res) => {
    console.log(req.file);
    res.json(req.file);
});

// Member APIs
router.post('/api/members/login', apiMemberController.login);
router.post('/api/members/signup', apiMemberController.signup);
router.get('/api/members/mypage', apiMemberController.mypage);
router.get('/api/members/notice', apiMemberController.getNotice);
router.post('/api/members/notice', apiMemberController.clearNotice);

// Review APIs
router.get('/api/reviews', apiReviewController.index);
router.get('/api/reviews/products', apiReviewController.products);
router.post('/api/reviews', upload.single('file'), apiReviewController.store);
router.post('/api/reviews/image', apiReviewController.uploadImage);
router.delete('/api/reviews/image', apiReviewController.deleteImage);
router.get('/api/reviews/:reviewId', apiReviewController.getDetail);
router.delete('/api/reviews/:reviewId', apiReviewController.delete);
router.put('/api/reviews/:reviewId', apiReviewController.update);
router.get('/api/reviews/questions/:reviewId', apiReviewController.getQuestions);
router.post('/api/reviews/questions/:reviewId', apiReviewController.storeQuestion);
router.delete('/api/reviews/questions/:questionId', apiReviewController.deleteQuestion);
router.post('/api/reviews/like/:reviewId', apiReviewController.storeLike);
router.post('/api/reviews/scrap/:reviewId', apiReviewController.scrap);
router.delete('/api/reviews/like/:reviewId', apiReviewController.unlike);
router.delete('/api/reviews/scrap/:reviewId', apiReviewController.unscrap);

// Community APIs
router.get('/api/community', apiCommunityController.index);
router.post('/api/community', apiCommunityController.store);
router.put('/api/community/:communityId', apiCommunityController.update);
router.delete('/api/community/image', apiCommunityController.deleteCommunity);
router.get('/api/community/comments/:communityId', apiCommunityController.getComments);
router.post('/api/community/comments/:communityId', apiCommunityController.storeComment);
router.delete('/api/community/comments/:commentId', apiCommunityController.deleteComment);
router.post('/api/community/like/:communityId', apiCommunityController.storeLike);
router.delete('/api/community/like/:communityId', apiCommunityController.unlike);

module.exports = router;
