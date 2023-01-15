import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/screens/services/todo_service.dart';
import 'package:todoapp/utils/snackbar_helper.dart';

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;

    if (widget.todo != null) {
      isEdit = true;
      final title = todo!['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Todo' : 'Add Todo',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'Title',
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(
              hintText: 'Description',
            ),
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                isEdit ? 'Update' : 'Submit',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> updateData() async {
    // get data from the form
    final todo = widget.todo;

    if (todo == null) {
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descriptionController.text;

    // submit data to the server

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    // Submit updated data to the server
    final isSuccess = await TodoService.updateTodo(id, body);

    if (isSuccess) {
      // success
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Updation Success');
    } else {
      // fail
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Updation Failed');
    }
  }

  Future<void> submitData() async {
    // get the data from the form
    final title = titleController.text;
    final description = descriptionController.text;

    // submit data to the server

    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };

    final isSuccess = await TodoService.addTodo(body);

    // show success mor fail message based on status code

    if (isSuccess) {
      // success
      titleController.clear();
      descriptionController.clear();
      // ignore: use_build_context_synchronously
      showSuccessMessage(context, message: 'Creation Success');
    } else {
      // fail
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Creation Failed');
    }
  }
}
