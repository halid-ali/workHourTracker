import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/data/repo/option_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/screens/history/history_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/util.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
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
                              return buildSlotDetail(widget.slots[index]);
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

  Widget buildSlotDetail(SlotModel slot) {
    return FutureBuilder(
      future: OptionRepository.getWorkHourOption(slot.optionId),
      builder: (context, AsyncSnapshot<OptionModel> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: AppLoading(''),
          );
        }

        if (snapshot.hasError) {
          return Text(S.of(context).option_data_load_error);
        }

        final option = snapshot.data;
        DateFormat formatter = DateFormat('HH:mm');
        String startTime = formatter.format(slot.startTime);
        String finishTime = formatter.format(slot.stopTime);
        String comment = slot.comment ?? 'N/A';

        return Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0),
          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Color(0xFFDEE2E6),
              border: Border.all(
                width: 1,
                color: Color(0xFFADB5BD),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option.name,
                        style: GoogleFonts.openSans(fontSize: 21),
                      ),
                    ),
                    Expanded(child: Container()),
                    Tooltip(
                      message: 'Start time',
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.all(0.0),
                      textStyle: GoogleFonts.openSans(
                          fontSize: 15, color: Colors.white),
                      decoration: BoxDecoration(color: Color(0xFF212529)),
                      child: Icon(
                        Icons.timer_sharp,
                        color: Color(0xFF38B000),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        '$startTime',
                        style: GoogleFonts.robotoMono(fontSize: 17),
                      ),
                    ),
                    SizedBox(width: 30),
                    Tooltip(
                      message: 'Finish time',
                      padding: EdgeInsets.all(5.0),
                      margin: EdgeInsets.all(0.0),
                      textStyle: GoogleFonts.openSans(
                          fontSize: 15, color: Colors.white),
                      decoration: BoxDecoration(color: Color(0xFF212529)),
                      child: Icon(
                        Icons.timer_off_sharp,
                        color: Color(0xFFD00000),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(left: 5.0),
                      child: Text(
                        '$finishTime',
                        style: GoogleFonts.robotoMono(fontSize: 17),
                      ),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xFFADB5BD),
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Comment',
                          style: GoogleFonts.openSans(fontSize: 17),
                        ),
                        Divider(thickness: 1, height: 10),
                        Text(
                          comment,
                          style: GoogleFonts.openSans(),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: [
                        Row(
                          children: [
                            Tooltip(
                              message: 'Break',
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.all(0.0),
                              textStyle: GoogleFonts.openSans(
                                  fontSize: 15, color: Colors.white),
                              decoration:
                                  BoxDecoration(color: Color(0xFF212529)),
                              child: Icon(
                                Icons.pause_circle_outline_sharp,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                Util.formatDuration(
                                  Duration(milliseconds: slot.pauseDuration),
                                ),
                                style: GoogleFonts.robotoMono(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Tooltip(
                              message: 'Work',
                              padding: EdgeInsets.all(5.0),
                              margin: EdgeInsets.all(0.0),
                              textStyle: GoogleFonts.openSans(
                                  fontSize: 15, color: Colors.white),
                              decoration:
                                  BoxDecoration(color: Color(0xFF212529)),
                              child: Icon(
                                Icons.play_circle_outline_sharp,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                Util.formatDuration(
                                  getTotalWorkDuration(slot),
                                ),
                                style: GoogleFonts.robotoMono(fontSize: 17),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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

  Duration getTotalWorkDuration(SlotModel slot) {
    return slot.stopTime.difference(slot.startTime) -
        Duration(milliseconds: slot.pauseDuration);
  }
}
