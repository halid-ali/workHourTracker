import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/screens/history/history_detail_item.dart';
import 'package:work_hour_tracker/screens/history/history_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/widgets/fade_transition.dart';

class HistoryDetailScreen extends StatefulWidget {
  final String dateHeader;
  final List<SlotModel> slots;

  HistoryDetailScreen(this.dateHeader, this.slots, {Key key}) : super(key: key);

  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: PlatformInfo.isWeb()
                    ? 600
                    : MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    color: Color(0xFF1D3557),
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          child: Icon(
                            Icons.arrow_back_ios_sharp,
                            color: Color(0xFFF1FAEE),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            FadeRouteTransition(
                              page: HistoryScreen(),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.dateHeader,
                            style: GoogleFonts.merriweather(
                              color: Color(0xFFF1FAEE),
                              fontSize: 21,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Separator
                  Container(
                    height: 10,
                    color: Color(0xFFE63946),
                    margin: EdgeInsets.only(bottom: 20),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F3F4),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.slots.length,
                            itemBuilder: (context, index) {
                              return HistoryItem(widget.slots[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSlotItem(String title, String detail) {
    return Row(
      children: [
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            '$title: ',
            style: GoogleFonts.robotoMono(fontSize: 17),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          child: Text(
            detail,
            style: GoogleFonts.robotoMono(fontSize: 17),
          ),
        ),
      ],
    );
  }
}
