import 'package:flutter/material.dart';
import 'package:todoing/date_service.dart';
// import 'package:uuid/uuid.dart';
// import 'package:todoing/todo/todo.dart';
import 'package:todoing/todo/todo_page_view_model.dart';
import 'package:todoing/utils/locator.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TodoPageViewModel _todoPageViewModel = TodoPageViewModel(
    dateService: locator<DateService>(),
  );
  final TextEditingController _todoController = TextEditingController();
  // final todos = <Todo>[];

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: _todoController,
          decoration: const InputDecoration(labelText: "Enter Todo"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _todoPageViewModel.add(_todoController.text);
              _todoController.clear();
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: _todoPageViewModel.dateNotifier,
          builder: (context, date, child) {
            return Text("Time: ${date.hour}:${date.minute}:${date.second}");
          },
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: _todoPageViewModel.todosNotifier,
        builder: (context, todos, child) {
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];

              // if (todo.completed) {
              //   return const SizedBox();
              // }

              return ListTile(
                title: Text(
                  todo.title,
                  style: todo.completed
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                trailing: Checkbox(
                  value: todo.completed,
                  onChanged: (value) {
                    _todoPageViewModel.toggleDone(todo);
                  },
                ),
                onLongPress: () {
                  _todoPageViewModel.remove(todo);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _todoPageViewModel.resetDate();
            },
            child: const Icon(Icons.refresh_sharp),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            onPressed: () {
              _addTodo();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
