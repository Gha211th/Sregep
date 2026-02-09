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
            children: [
              SizedBox(height: screenSize.height * 0.08),
              _buildHeader(),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Your Todos",
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 36,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Schdule your todos",
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
