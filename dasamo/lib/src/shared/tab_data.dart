// data.dart

class TabData {
  final String title;
  final List<String> images;

  TabData({required this.title, required this.images});
}

final List<TabData> tabDataList = [
  TabData(
    title: '내 리뷰',
    images: [
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
      'assets/images/salad.jpg',
    ],
  ),
  TabData(
    title: '내 운동',
    images: [
      'assets/images/profile.jpg',
      'assets/images/profile.jpg',
      'assets/images/profile.jpg',
    ],
  ),
  TabData(
    title: '스크랩',
    images: [
      'assets/images/product.jpg',
      'assets/images/product.jpg',
      'assets/images/product.jpg',
    ],
  ),
];
