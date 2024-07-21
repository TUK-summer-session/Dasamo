import 'package:flutter/material.dart';

class MoreBottomModal extends StatelessWidget {
  final VoidCallback cancelTap;
  final VoidCallback cameraTap;
  final VoidCallback galleryTap;

  const MoreBottomModal({
    required this.cancelTap,
    required this.cameraTap,
    required this.galleryTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('카메라로 촬영'),
                  onTap: cameraTap,
                ),
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('갤러리에서 선택'),
                  onTap: galleryTap,
                ),
                Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: const Text(
                      '닫기',
                      textAlign: TextAlign.center,
                    ),
                    onTap: cancelTap,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
