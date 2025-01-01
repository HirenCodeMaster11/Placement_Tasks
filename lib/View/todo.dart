import 'package:flutter/material.dart';
import 'package:placement_tasks/provider/todo.dart';
import 'package:provider/provider.dart';

import '../modal/todoModal.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.1,
        title: const Text(
          'Todo View',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(provider.isGrid ? Icons.list : Icons.grid_view),
            onPressed: provider.toggleView,
          ),
          IconButton(
            icon:
            Icon(provider.isDarkTheme ? Icons.dark_mode : Icons.light_mode),
            onPressed: provider.toggleTheme,
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, provider, child) {
          if (provider.todos.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: provider.isGrid
                ? GridView.builder(
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: provider.todos.length,
              itemBuilder: (context, index) {
                return GridTodoCard(provider.todos[index]);
              },
            )
                : ListView.builder(
              itemCount: provider.todos.length,
              itemBuilder: (context, index) {
                return ListTodoTile(provider.todos[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget ListTodoTile(TodoModal todo) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        leading: Icon(
          todo.completed ? Icons.check_circle : Icons.close,
          color: todo.completed ? Colors.green : Colors.red,
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Provider.of<TodoProvider>(context).isDarkTheme
                ? Colors.grey[800]
                : Colors.black,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          todo.completed ? 'Completed' : 'Pending',
          style: TextStyle(
            color: todo.completed ? Colors.green : Colors.red,
            fontWeight: FontWeight.w400,
          ),
        ),
        tileColor: todo.completed ? Colors.green.shade50 : Colors.red.shade50,
      ),
    );
  }
  Widget GridTodoCard(TodoModal todo) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: todo.completed ? Colors.green.shade100 : Colors.red.shade100,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              todo.completed ? Icons.check_circle : Icons.close,
              color: todo.completed ? Colors.green : Colors.red,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              todo.title,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Provider.of<TodoProvider>(context).isDarkTheme
                    ? Colors.grey[800]
                    : Colors.black,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                todo.completed ? 'Completed' : 'Pending',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: todo.completed
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
