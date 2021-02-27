import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isObscureText;
  final bool isRequired;
  final String hintText;
  final IconData iconData;
  final Function validateFunc;
  final TextEditingController controller;

  CustomTextFormField({
    Key key,
    this.isObscureText = false,
    this.isRequired = false,
    @required this.hintText,
    this.iconData,
    this.validateFunc,
    @required this.controller,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  final _focusNode = FocusNode();
  Color _suffixIconColor = Colors.white;

  initState() {
    super.initState();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.controller.selection = TextSelection(
          baseOffset: 0,
          extentOffset: widget.controller.text.length,
        );
      }
    });

    widget.controller.addListener(() {
      setState(() {
        _suffixIconColor = widget.validateFunc(widget.controller.text) == null
            ? Colors.green
            : Colors.white;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isObscureText,
      validator: widget.validateFunc,
      focusNode: _focusNode,
      style: GoogleFonts.openSans(fontSize: 17),
      decoration: InputDecoration(
        errorStyle: GoogleFonts.openSans(fontSize: 13),
        errorMaxLines: 5,
        helperText: widget.isRequired ? S.of(context).required_field : '',
        helperStyle: GoogleFonts.openSans(fontSize: 13),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.openSans(fontSize: 17),
        icon: _getIcon(),
        suffixIcon: Icon(
          Icons.check,
          color: _suffixIconColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFE63946),
          ),
        ),
      ),
    );
  }

  Widget _getIcon() {
    if (widget.iconData != null) {
      return Icon(
        this.widget.iconData,
        color: Color(0xFF6C757D),
        size: 33,
      );
    }

    return null;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }
}
