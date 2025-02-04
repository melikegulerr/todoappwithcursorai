import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo Uygulaması',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.deepPurple[300],
        useMaterial3: true,
      ),
      home: const TodoSayfasi(),
    );
  }
}

class TodoSayfasi extends StatefulWidget {
  const TodoSayfasi({super.key});

  @override
  State<TodoSayfasi> createState() => _TodoSayfasiState();
}

class _TodoSayfasiState extends State<TodoSayfasi> {
  final List<Todo> _todos = [
    Todo(baslik: 'Learn Flutter', tamamlandi: false),
    Todo(baslik: 'Yoga', tamamlandi: false),
  ];
  final TextEditingController _controller = TextEditingController();

  void _yeniGorevEkle() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Görev'),
        content: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Görev giriniz...',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _controller.clear();
            },
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                setState(() {
                  _todos.add(
                    Todo(
                      baslik: _controller.text,
                      tamamlandi: false,
                    ),
                  );
                });
                Navigator.pop(context);
                _controller.clear();
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'TO DO',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _todos.isEmpty
            ? const Center(
                child: Text(
                  'Henüz görev eklenmemiş',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: _todos.length,
                itemBuilder: (context, index) {
                  final todo = _todos[index];
                  return Dismissible(
                    key: Key(todo.baslik),
                    background: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.red,
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        _todos.removeAt(index);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${todo.baslik} silindi'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        leading: Checkbox(
                          value: todo.tamamlandi,
                          onChanged: (value) {
                            setState(() {
                              todo.tamamlandi = value!;
                            });
                          },
                        ),
                        title: Text(
                          todo.baslik,
                          style: TextStyle(
                            decoration: todo.tamamlandi
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor:
                                todo.tamamlandi ? Colors.black : null,
                            decorationThickness: 3,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _yeniGorevEkle,
        backgroundColor: Colors.deepPurple,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Todo {
  String baslik;
  bool tamamlandi;

  Todo({
    required this.baslik,
    required this.tamamlandi,
  });
}
