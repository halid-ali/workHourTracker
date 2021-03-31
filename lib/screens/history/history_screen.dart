import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/data/repo/slot_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
import "package:collection/collection.dart";

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
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
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              S.of(context).history,
                              style: GoogleFonts.merriweather(
                                color: Color(0xFFF1FAEE),
                                fontSize: 21,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Icon(
                            Icons.close_sharp,
                            color: Color(0xFFF1FAEE),
                          ),
                          onTap: () => Navigator.pushNamed(
                              context, RouteGenerator.homePage),
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
                          FutureBuilder(
                            future: SessionManager.read(SessionKey.userId),
                            builder: (context, AsyncSnapshot<String> snapshot) {
                              if (!snapshot.hasData) {
                                return AppLoading(S.of(context).user_data_load);
                              }

                              if (snapshot.hasError) {
                                return Text(S.of(context).user_data_load_error);
                              }

                              final userId = snapshot.data;

                              return StreamBuilder(
                                stream: SlotRepository.getWorkHourSlotsByUser(
                                    userId),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return AppLoading(
                                        S.of(context).history_load);
                                  }

                                  if (snapshot.hasError) {
                                    return Text(
                                        S.of(context).history_load_error);
                                  }

                                  final slotModelDocs = snapshot.data.docs;
                                  final slotModels = slotModelDocs
                                      .map((e) =>
                                          SlotModel.fromJson(e.id, e.data()))
                                      .toList();
                                  slotModels.sort((a, b) =>
                                      a.startTime.compareTo(b.startTime));
                                  var groupedSlots =
                                      groupBy<SlotModel, DateTime>(
                                    slotModels,
                                    (e) => DateTime(
                                      e.startTime.year,
                                      e.startTime.month,
                                      e.startTime.day,
                                    ),
                                  );

                                  return ListView.separated(
                                    shrinkWrap: true,
                                    itemCount: groupedSlots.length,
                                    separatorBuilder: (context, index) {
                                      return Divider(thickness: 1, height: 1);
                                    },
                                    itemBuilder: (context, index) {
                                      return getSlotList(groupedSlots)[index];
                                    },
                                  );
                                },
                              );
                            },
                          ),
                          Divider(thickness: 1, height: 1),
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

  List<Widget> getSlotList(Map<DateTime, List<SlotModel>> slots) {
    List<Widget> items = [];

    for (var slot in slots.entries) {
      DateFormat formatter = DateFormat('dd MMM yyyy, EEEE');
      String formatted = formatter.format(slot.key);
      Duration totalWorkDuration = getTotalWorkDuration(slot.value);
      Duration difference = totalWorkDuration - Duration(hours: 8);

      items.add(
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatted,
                      style: GoogleFonts.openSans(fontSize: 21),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      formatDuration(totalWorkDuration),
                      style: GoogleFonts.openSans(fontSize: 21),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 5.0),
                    alignment: Alignment.centerRight,
                    child: buildDifferenceIndicator(difference),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return items;
  }

  Widget buildDifferenceIndicator(Duration duration) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        duration.isNegative
            ? Transform.rotate(
                angle: -.78, // -45 deg
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  maxRadius: 10,
                  child: Icon(
                    Icons.arrow_downward_sharp,
                    size: 15,
                  ),
                ),
              )
            : Transform.rotate(
                angle: .78, // 45 deg
                child: CircleAvatar(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  maxRadius: 10,
                  child: Icon(
                    Icons.arrow_upward_sharp,
                    size: 15,
                  ),
                ),
              ),
        Container(
          height: 20,
          alignment: Alignment.centerRight,
          child: Text(
            formatDuration(duration, addSign: true),
            style: GoogleFonts.robotoMono(),
          ),
        ),
      ],
    );
  }

  Duration getTotalWorkDuration(List<SlotModel> slots) {
    Duration totalDuration = slots
        .where((e) => e.stopTime != null)
        .map<Duration>((e) => e.stopTime.difference(e.startTime))
        .fold(Duration.zero, (p, e) => p + e);

    Duration totalPauseDuration = slots
        .where((e) => e.stopTime != null)
        .map<Duration>((e) => Duration(milliseconds: e.pauseDuration))
        .fold(Duration.zero, (p, e) => p + e);

    return totalDuration - totalPauseDuration;
  }

  String formatDuration(Duration duration, {bool addSign = false}) {
    var buffer = StringBuffer();
    if (addSign) {
      buffer.write(duration.isNegative ? '-' : '+');
    }

    duration = Duration(milliseconds: duration.inMilliseconds.abs());

    var hours = duration.inHours.remainder(60);
    var minutes = duration.inMinutes.remainder(60);

    buffer.write(
        hours > 0 ? hours.toString() + S.of(context).hour_unit + ' ' : '');
    buffer.write(
        minutes > 0 ? minutes.toString() + S.of(context).minute_unit : '');

    return buffer.toString().padLeft(7, ' ');
  }
}
