// lib/src/controllers/comments_controller.dart

import 'package:dasamo/src/shared/community_data.dart';
import 'package:get/get.dart';

class CommunityController extends GetxController {
  RxList<Map<String, dynamic>> communityList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCommunity();
  }

  void _fetchCommunity() {
    communityList.assignAll(communityData);
  }

  void addComment(Map<String, dynamic> community) {
    communityList.add(community);
  }

  void updateComment(int index, Map<String, dynamic> community) {
    communityList[index] = community;
  }

  void deleteComment(int index) {
    communityList.removeAt(index);
  }
}
