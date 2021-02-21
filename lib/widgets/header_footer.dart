import 'package:flutter/material.dart';
import 'package:work_hour_tracker/widgets/header_footer_column.dart';

class HeaderFooter extends StatelessWidget {
  final List<HeaderFooterColumn> columns;

  const HeaderFooter({
    Key key,
    this.columns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [..._buildColumns()],
      ),
    );
  }

  List<Widget> _buildColumns() {
    List<Widget> widgetList = [];

    for (var i = 0; i < columns.length; i++) {
      widgetList.add(columns[i]);
      if (i < columns.length - 1) {
        widgetList.add(SizedBox(width: 2));
      }
    }

    return widgetList;
  }
}
