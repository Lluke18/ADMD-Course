import 'dart:math';
import 'package:flutter/material.dart';
import '../api/todo_api.dart';
import '../models/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _items = <Todo>[];
  final _input = TextEditingController();
  final _log = <String>[];
  int _nextId = 0;
  String? _filter;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    
    final a = Todo.fromJson({'userId': 1, 'id': 1, 'title': 'x', 'completed': false});
    final b = Todo.fromJson({'userId': 1, 'id': 1, 'title': 'x', 'completed': false});
    debugPrint('a == b: ${a == b}');

    _load();
  }

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  
  Future<void> _load({String path = '/todos'}) async {
    setState(() {
      _loading = true;
      _error = null;
      _log.clear();
    });
    try {
      final todos = await withRetry(
        () => fetchTodos(path: path),
        onLog: (msg) {
          debugPrint(msg);
          if (mounted) setState(() => _log.add(msg));
        },
      );
      if (!mounted) return;
      setState(() {
        _items
          ..clear()
          ..addAll(todos);
        _nextId = todos.fold<int>(0, (m, t) => max(m, t.id)) + 1;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load todos';
        _loading = false;
      });
    }
  }

  void _add() {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _items.add(Todo(userId: 1, id: _nextId++, title: text, completed: false));
    });
    _input.clear();
  }

  void _toggle(Todo todo) {
    final index = _items.indexWhere((t) => t.id == todo.id);
    if (index == -1) return;
    setState(() {
      _items[index] = _items[index].copyWith(completed: !_items[index].completed);
    });
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
      done += _items[i].completed ? 1 : 0;
    }
    return done;
  }

  @override
  Widget build(BuildContext context) {
    final visible =
        _items.where((t) => t.title.contains(_filter ?? '')).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('todo (Done: ${_countDone()})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reload from /todos',
            onPressed: _loading ? null : () => _load(),
          ),
          IconButton(
            icon: const Icon(Icons.bug_report),
            tooltip: 'Load invalid path (/nope)',
            onPressed: _loading ? null : () => _load(path: '/nope'),
          ),
        ],
      ),
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
            child: _loading && visible.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : visible.isEmpty
                    ? Center(child: Text(_error ?? 'No todos.'))
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
                              onToggle: () => _toggle(todo),
                            ),
                          );
                        },
                      ),
          ),
          
          if (_log.isNotEmpty)
            Container(
              width: double.infinity,
              height: 120,
              color: Colors.black12,
              padding: const EdgeInsets.all(8),
              child: ListView(
                children: [for (final line in _log) Text(line)],
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
        leading: Checkbox(value: todo.completed, onChanged: (_) => onToggle()),
        title: Text(todo.title),
      ),
    );
  }
}