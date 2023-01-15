import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:todoapp/screens/add_page.dart';
import 'package:http/http.dart' as http;
import 'package:todoapp/screens/services/todo_service.dart';
import 'package:todoapp/widget/todo_card.dart';

import '../utils/snackbar_helper.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  bool isLoading = true;

  List items = [];

  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todo List'),
        ),
        body: Visibility(
          visible: isLoading,
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: const Center(
                child: Text(
                  'No Item in todo',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index] as Map;
                  final id = item['_id'] as String;
                  return TodoCard(
                      index: index,
                      item: item,
                      navigateTodoEdit: navigateTodoEditPage,
                      deleteById: deleteById);
                },
              ),
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateTodoAddPage();
          },
          child: const Icon(Icons.add),
        ));
  }

  Future<void> navigateTodoEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateTodoAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => const AddTodoPage(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> fetchTodo() async {
    final response = await TodoService.fetchTodos();
    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Something went wrong');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoService.deleteById(id);
    if (isSuccess) {
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      // ignore: use_build_context_synchronously
      showErrorMessage(context, message: 'Something went wrong');
    }
  }
}
