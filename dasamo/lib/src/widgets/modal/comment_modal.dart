// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:dasamo/src/controllers/reviews_comments_controller.dart';
// import 'package:dasamo/src/widgets/comment/reviews_comment_input.dart';
// import 'package:dasamo/src/widgets/comment/reviews_comments.dart';

// class CommentModal extends StatelessWidget {
//   final int reviewId;

//   const CommentModal(
//       {required this.reviewId,
//       Key? key,
//       required CommentsController commentsController})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final CommentsController commentsController =
//         Get.find<CommentsController>();
//     double screenHeight = MediaQuery.of(context).size.height;

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(30),
//       ),
//       height: screenHeight * 0.7,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             height: 40,
//             alignment: Alignment.center,
//             child: Container(
//               height: 5,
//               width: 50,
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//           ),
//           Expanded(
//             child: Comments(reviewId: 888), // Comments 위젯에 reviewId를 전달
//           ),
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: CommentInput(
//               onSave: (comment) {
//                 print('저장된 댓글: $comment');
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
