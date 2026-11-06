import 'package:flutter/material.dart';

class Todo {
  Todo(this.id, this.title);
  final int id;
  final String title;
  bool done = false;
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _items = <Todo>[];
  final _input = TextEditingController();
  int _nextId = 0;
  String? _filter; 

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  
  void _add() {
    if (_input.text.trim().isEmpty) return;
    setState(() {
      _items.add(Todo(_nextId++, _input.text.trim()));
    });
    _input.clear();
  }

  
  void _toggle(int i) {
    setState(() {
      _items[i].done = !_items[i].done; //here it's 2
    })
    ;
  }

  
  void _remove(Todo todo) {
    final index = _items.indexWhere((t) => t.id == todo.id);
    setState(() {
      _items.removeWhere((t) => t.id == todo.id);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Todo deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _items.insert(index.clamp(0, _items.length), todo);
            });
          },
        ),
      ),
    );
  }

  
  int _countDone() {
    int done = 0;
    for (var i = 0; i < _items.length; i++) {
      done += _items[i].done ? 1 : 0;
    }
    return done;
  }

  @override
  Widget build(BuildContext context) {
    final visible = _items.where(
      (t) => t.title.contains(_filter ?? "")).toList(); // it's 3

    return Scaffold(
      appBar: AppBar(title: Text('todo (Done: ${_countDone()})')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _input,
              decoration: const InputDecoration(hintText: 'enter new'),
            ),
          ),
          Expanded(
            child: visible.isEmpty
                ? const Center(child: Text('No todos.'))
                : ListView.builder(
                    itemCount: visible.length,
                    itemBuilder: (context, i) {
                      final todo = visible[i];
                      return Dismissible(
                        key: ValueKey(todo.id),
                        direction: DismissDirection.endToStart,
                        background: Container(color: Colors.red),
                        onDismissed: (_) => _remove(todo),
                        child: TodoTile(
                          todo: todo,
                          onToggle: () => _toggle(i),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
    );
  }
}


class TodoTile extends StatelessWidget {
  const TodoTile({super.key, required this.todo, required this.onToggle});

  final Todo todo;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(value: todo.done, onChanged: (_) => onToggle()),
        title: Text(todo.title),
      ),
    );
  }
}