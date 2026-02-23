import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sregep_productivity_app/core/constants.dart';
import 'package:sregep_productivity_app/data/models/todo_model.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  todo.task ?? "",
                  style: GoogleFonts.outfit(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Date: ${todo.date}",
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onToggle,
            icon: Icon(
              todo.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete, color: AppColors.primary, size: 32),
          ),
        ],
      ),
    );
  }
}
