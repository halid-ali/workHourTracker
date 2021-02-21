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

    for (var column in columns) {
      widgetList.add(column);
      widgetList.add(SizedBox(width: 2));
    }

    return widgetList;
  }
}
