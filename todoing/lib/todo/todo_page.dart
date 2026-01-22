import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:todoing/todo/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final TextEditingController _todoController = TextEditingController();
  // final todos = <Todo>[];
  final todos = <Todo>[
    Todo(id: "1", title: "Test", completed: false),
    Todo(id: "2", title: "Test 2", completed: true),
    Todo(id: "3", title: "Test 3", completed: false),
  ];

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
              setState(() {
                todos.add(
                  Todo(
                    id: const Uuid().v4(),
                    title: _todoController.text,
                    completed: false,
                  ),
                );
                // SOLVED - add text to the list of todos
                // SOLVED - hint: todos.add(Todo(id: const Uuid().v4(), title: 'this should be the text from the controller', completed: false));
              });
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
      appBar: AppBar(title: const Text('Display time')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          if (todo.completed) {
            return const SizedBox();
          }

          return ListTile(
            title: Text(todo.title),
            trailing: Checkbox(
              value: todo.completed,
              onChanged: (value) {
                final newTodo = todo.copyWith(completed: value ?? false);
                setState(() {
                  todos[index] = newTodo;
                });
              },
            ),
            onLongPress: () {
              setState(() {
                todos.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addTodo();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
