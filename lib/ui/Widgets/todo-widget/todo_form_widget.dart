import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sregep_productivity_app/data/repo/todo_repo.dart';
import 'package:sregep_productivity_app/ui/fonts/font_size.dart';
import 'package:sregep_productivity_app/ui/padding/padding_size.dart';

class TodoFormWidget extends StatefulWidget {
  final VoidCallback onTodoAdded;
  final Color primaryColor;

  const TodoFormWidget({
    super.key,
    required this.onTodoAdded,
    required this.primaryColor,
  });

  @override
  State<TodoFormWidget> createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {
  final _nameController = TextEditingController();
  final _dateController = TextEditingController();

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: widget.primaryColor),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });
    }
  }

  final TodoRepository _todoRepo = TodoRepository();

  void _submitData() async {
    if (_nameController.text.isEmpty || _dateController.text.isEmpty) return;

    await _todoRepo.insertTodo({
      'task': _nameController.text,
      'date': _dateController.text,
      'is_completed': 0,
    });

    _nameController.clear();
    _dateController.clear();
    widget.onTodoAdded();

    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: PaddingSize.getPaddingHor(context),
        vertical: PaddingSize.getPaddingVer(context),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: widget.primaryColor, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Add Name"),
          _buildTextField(
            controller: _nameController,
            hint: "Enter your todo name",
          ),
          SizedBox(height: screenSize.height * 0.03),
          _buildLabel("Add Date"),
          _buildTextField(
            controller: _dateController,
            hint: "dd/mm/yyyy",
            readOnly: true,
            onTap: _pickDate,
          ),
          SizedBox(height: screenSize.height * 0.025),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _submitData,
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: Text(
                "Add Todos",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: widget.primaryColor,
          fontWeight: FontWeight.w500,
          fontSize: ResponsiveText.getFontSizeForLabel(context),
          height: 1,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          color: Colors.grey.shade400,
          fontSize: ResponsiveText.getFontSizeForSeacrhBar(context),
          fontWeight: FontWeight.w400,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: PaddingSize.getPaddingTextConHor(context),
          vertical: 20,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: widget.primaryColor.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: widget.primaryColor, width: 2),
        ),
      ),
    );
  }
}
