import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/data/models/todo_model.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/data/repo/todo_repo.dart';
import 'package:sregep_productivity_app/ui/Widgets/todo-widget/todo_form_widget.dart';
import 'package:sregep_productivity_app/ui/Widgets/todo-widget/todo_item_widget.dart';
import 'package:sregep_productivity_app/ui/fonts/font_size.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool _isCompleted = false;
  List<TodoModel> _todos = [];

  String _searchQuery = "";
  List<TodoModel> _filteredTodos = [];

  double getFontSizeForTitle(double width) {
    if (width >= 1600) return 64;
    if (width >= 1200) return 48;
    if (width >= 800) return 44;
    if (width > 480) return 40;
    return 38;
  }

  double getFontSizeForSubTitle(double width) {
    if (width >= 1600) return 38;
    if (width >= 1200) return 30;
    if (width >= 800) return 28;
    if (width >= 480) return 24;
    return 20;
  }

  final TodoRepository _todoRepo = TodoRepository();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _runFilter(String enteredKeyword) {
    List<TodoModel> result = [];

    if (enteredKeyword.isEmpty) {
      result = _todos;
    } else {
      result = _todos
          .where(
            (todo) =>
                todo.task.toLowerCase().contains(enteredKeyword.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _filteredTodos = result;
    });
  }

  Future<void> _loadTodos() async {
    final data = await _todoRepo.queryTodos(_isCompleted);
    setState(() {
      _todos = data.map((item) => TodoModel.fromMap(item)).toList();
      if (_searchQuery.isEmpty) {
        _filteredTodos = _todos;
      } else {
        _runFilter(_searchQuery);
      }
    });
  }

  void handleDelete(int id) async {
    await _todoRepo.deleteTodo(id);

    _loadTodos();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item has been deleted'),
          backgroundColor: AppColors.primary,
        ),
      );
    }
  }

  void handleToggle(TodoModel todo) async {
    await _todoRepo.updateTodoStatus(todo.id!, !todo.isCompleted);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 1000) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: _buildDesktopMode(),
              );
            } else {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: _buildMobileMode(),
              );
            }
          },
        ),
      ),
    );
  }

  // WIDGET UNTUK KONDISI DEKTOP, MOBILE, DAN TABLET

  Widget _buildMobileMode() {
    final screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: screenSize.height * 0.06),
        _buildHeader(),
        SizedBox(height: screenSize.height * 0.02),
        const Divider(thickness: 1),
        const SizedBox(height: 10),
        _buildSearchBar(),
        const SizedBox(height: 10),
        const Divider(thickness: 1),
        const SizedBox(height: 20),
        _buildSectionTitle('Add your todo~', 'Do you have any todo list?'),
        const SizedBox(height: 15),
        TodoFormWidget(onTodoAdded: _loadTodos, primaryColor: AppColors.accent),
        const SizedBox(height: 30),
        const Divider(thickness: 1),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Your Todos', 'Do you have any list?'),
            Switch(
              value: _isCompleted,
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
        _filteredTodos.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Text(
                    "No task found :(",
                    style: GoogleFonts.outfit(fontSize: 18, color: Colors.grey),
                  ),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredTodos.length,
                itemBuilder: (context, index) {
                  final todo = _filteredTodos[index];
                  return TodoItemWidget(
                    todo: todo,
                    onToggle: () => handleToggle(todo),
                    onDelete: () => handleDelete(todo.id!),
                  );
                },
              ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDesktopMode() {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(left: screenSize.width * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenSize.height * 0.06),
          _buildHeader(),
          SizedBox(height: screenSize.height * 0.01),
          const Divider(thickness: 1),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    SizedBox(height: screenSize.height * 0.03),
                    const Divider(thickness: 1),
                    SizedBox(height: screenSize.height * 0.03),
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
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenSize.width * 0.02,
                ),
                child: Container(
                  height: screenSize.height * 0.7,
                  width: 1,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionTitle(
                          'Your Todos',
                          'Do you have any list?',
                        ),
                        Switch(
                          value: _isCompleted,
                          activeTrackColor: AppColors.accent,
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
                    _filteredTodos.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 50),
                              child: Text(
                                "No task found :(",
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
                            itemCount: _filteredTodos.length,
                            itemBuilder: (context, index) {
                              final todo = _filteredTodos[index];
                              return TodoItemWidget(
                                todo: todo,
                                onToggle: () => handleToggle(todo),
                                onDelete: () => handleDelete(todo.id!),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Todos",
          style: GoogleFonts.outfit(
            color: AppColors.accent,
            fontSize: getFontSizeForTitle(screenSize.width),
            fontWeight: FontWeight.w500,
            height: 1,
          ),
        ),
        Text(
          "Schdule your todos",
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: ResponsiveText.getSubTitleFontSize(context),
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
            fontSize: ResponsiveText.getFontSizeForStatsTitle(context),
            fontWeight: FontWeight.w400,
            height: 1,
          ),
        ),
        Text(
          subtitle,
          style: GoogleFonts.outfit(
            color: Colors.grey,
            fontSize: ResponsiveText.getFontSizeForSubStats(context),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // BUILD SEARCH QUERY

  Widget _buildSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search Your Todos",
          style: GoogleFonts.outfit(
            fontSize: ResponsiveText.getFontSizeForStatsTitle(context),
            color: AppColors.accent,
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.accent, width: 2),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;

                if (value.isEmpty) {
                  _filteredTodos = _todos;
                } else {
                  _filteredTodos = _todos
                      .where(
                        (todo) => todo.task.toLowerCase().contains(
                          value.toLowerCase(),
                        ),
                      )
                      .toList();
                }
              });
            },
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              hintText: "Search any task..",
              hintStyle: GoogleFonts.outfit(
                fontSize: ResponsiveText.getFontSizeForSeacrhBar(context),
                color: Colors.grey,
              ),
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 15, right: 12),
                child: Icon(Icons.search, size: 25, color: Colors.grey),
              ),
              prefixIconConstraints: const BoxConstraints(
                minHeight: 40,
                minWidth: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
