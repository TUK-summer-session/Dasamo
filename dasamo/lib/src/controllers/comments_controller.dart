import 'package:dasamo/src/shared/comments_data.dart';
import 'package:get/get.dart';

class CommentsController extends GetxController {
  // RxList는 GetX의 반응형 리스트로, 리스트의 상태가 변경될 때마다 UI를 자동으로 업데이트합니다.
  RxList<Map<String, dynamic>> commentsList = <Map<String, dynamic>>[].obs;

  // onInit은 컨트롤러가 초기화될 때 호출되는 메서드입니다.
  // 여기서 초기 데이터를 설정하는 메서드를 호출합니다.
  @override
  void onInit() {
    super.onInit();
    _initialData(); // 초기 데이터를 설정하는 메서드를 호출합니다.
  }

  // _initialData 메서드는 commentsData에서 초기 댓글 데이터를 가져와 commentsList에 설정합니다.
  void _initialData() {
    commentsList.assignAll(commentsData);
  }

  // fetchComments 메서드는 외부 소스(예: API)에서 데이터를 가져오는 로직을 추가할 수 있는 메서드입니다.
  void fetchComments() {
    // 데이터를 가져오는 로직 추가 (예: API 호출)
  }

  // addComment 메서드는 새로운 댓글을 commentsList에 추가하는 메서드입니다.
  void addComment(Map<String, dynamic> comment) {
    commentsList.add(comment);
  }

  // updateComment 메서드는 특정 인덱스의 댓글을 업데이트하는 메서드입니다.
  void updateComment(int index, Map<String, dynamic> comment) {
    commentsList[index] = comment;
  }

  // deleteComment 메서드는 특정 인덱스의 댓글을 삭제하는 메서드입니다.
  void deleteComment(int index) {
    commentsList.removeAt(index);
  }
}
