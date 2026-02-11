import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/data/models/todo_model.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/data/repo/todo_repo.dart';
import 'todos/widgets/todo_form_widget.dart';
import 'todos/widgets/todo_item_widget.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool _isCompleted = false;
  List<TodoModel> _todos = [];

  final TodoRepository _todoRepo = TodoRepository();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final data = await _todoRepo.queryTodos(_isCompleted);
    setState(() {
      _todos = data.map((item) => TodoModel.fromMap(item)).toList();
    });
  }

  void handleDelete(int id) async {
    await _todoRepo.deleteTodo(id);

    _loadTodos();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item has been deleted'), backgroundColor: AppColors.accent),
      );
    }
  }

  void handleToggle(TodoModel todo) async {
    await _todoRepo.updateTodoStatus(todo.id!, !todo.isCompleted);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.08),
              _buildHeader(),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 20),
              _buildSectionTitle(
                'Add your todo~',
                'Do you have any todo list?',
              ),
              const SizedBox(height: 15),
              TodoFormWidget(
                onTodoAdded: _loadTodos,
                primaryColor: AppColors.accent,
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionTitle('Your Todos', 'Do you have any list?'),
                  Switch(
                    value: _isCompleted,
                    activeThumbColor: Colors.white,
                    activeTrackColor: AppColors.accent,
                    inactiveTrackColor: AppColors.accent,
                    inactiveThumbColor: Colors.white,
                    onChanged: (value) {
                      setState(() {
                        _isCompleted = value;
                      });
                      _loadTodos();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _todos.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          "No task found here:(",
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _todos.length,
                      itemBuilder: (context, index) {
                        final todo = _todos[index];
                        return TodoItemWidget(
                          todo: todo,
                          onToggle: () => handleToggle(todo),
                          onDelete: () => handleDelete(todo.id!),
                        );
                      },
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Todos",
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 42,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Schdule your todos",
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: 20,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
