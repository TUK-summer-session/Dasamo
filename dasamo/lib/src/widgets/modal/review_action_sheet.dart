import 'package:flutter/material.dart';

class ReviewActionSheet extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReviewActionSheet({
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.edit_outlined, color: Colors.black54),
            title: Text('수정하기'),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.delete_outline_outlined, color: Colors.red),
            title: Text('삭제하기'),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
