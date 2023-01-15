import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  final int index;
  final Map item;
  final Function(Map) navigateTodoEdit;
  final Function(String) deleteById;
  const TodoCard({
    super.key,
    required this.index,
    required this.item,
    required this.navigateTodoEdit,
    required this.deleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'] as String;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${index + 1}'),
        ),
        title: Text(item['title']),
        subtitle: Text(item['description']),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit, color: Colors.blue),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete'),
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              // open edit page
              navigateTodoEdit(item);
            } else if (value == 'delete') {
              // delete and remove the item from
              deleteById(id);
            }
          },
        ),
      ),
    );
    ;
  }
}
