import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/data/database_helper.dart';
import 'package:sregep_productivity_app/data/models/todo_model.dart';
import 'package:sregep_productivity_app/core/constants.dart';
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

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final data = await DatabaseHelper.instance.queryTodos(_isCompleted);
    setState(() {
      _todos = data.map((item) => TodoModel.fromMap(item)).toList();
    });
  }

  void handleToggle(TodoModel todo) async {
    await DatabaseHelper.instance.updateTodoStatus(todo.id!, !todo.isCompleted);
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
