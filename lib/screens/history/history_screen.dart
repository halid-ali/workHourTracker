import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/data/repo/slot_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/routes.dart';
import 'package:work_hour_tracker/screens/history/history_detail_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/utils/util.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
import "package:collection/collection.dart";
import 'package:work_hour_tracker/widgets/app_tooltip.dart';
import 'package:work_hour_tracker/widgets/fade_transition.dart';

class HistoryScreen extends StatefulWidget {
  HistoryScreen({Key key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  FilterBy filterBy = FilterBy.weekly;
  bool isAscendingSort = true;

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
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 10.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F3F4),
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFD3D3D3),
                      ),
                    ),
                    child: Row(
                      children: [
                        DropdownButton<FilterBy>(
                          icon: Icon(Icons.filter_list_sharp),
                          underline: Container(),
                          value: filterBy,
                          items: [
                            buildDropdownMenuItem(FilterBy.weekly),
                            buildDropdownMenuItem(FilterBy.monthly),
                            buildDropdownMenuItem(FilterBy.yearly),
                          ],
                          onChanged: (value) {
                            setState(() {
                              filterBy = value;
                            });
                          },
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          child: Icon(Icons.arrow_back_ios_sharp),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          child: Icon(Icons.arrow_forward_ios_sharp),
                        ),
                        SizedBox(width: 20),
                        AppTooltip(
                          isAscendingSort
                              ? 'Sort descending'
                              : 'Sort ascending',
                          InkWell(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationX(
                                  isAscendingSort ? 0 : math.pi),
                              child: Icon(Icons.sort_sharp),
                            ),
                            onTap: () {
                              setState(() {
                                isAscendingSort = !isAscendingSort;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
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
                      child: FutureBuilder(
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
                            stream:
                                SlotRepository.getWorkHourSlotsByUser(userId),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return AppLoading(S.of(context).history_load);
                              }

                              if (snapshot.hasError) {
                                return Text(S.of(context).history_load_error);
                              }

                              final slotModelDocs = snapshot.data.docs;
                              final slotModels = slotModelDocs
                                  .where((e) =>
                                      SlotModel.fromJson(e.id, e.data())
                                          .startTime
                                          .compareTo(Util.getDayStart()) <
                                      0)
                                  .map(
                                      (e) => SlotModel.fromJson(e.id, e.data()))
                                  .toList();

                              isAscendingSort
                                  ? sortAscending(slotModels)
                                  : sortDescending(slotModels);

                              var groupedSlots = groupBy<SlotModel, DateTime>(
                                slotModels,
                                (e) => DateTime(
                                  e.startTime.year,
                                  e.startTime.month,
                                  e.startTime.day,
                                ),
                              );

                              return Scrollbar(
                                thickness: 5,
                                hoverThickness: 5,
                                showTrackOnHover: true,
                                isAlwaysShown: true,
                                radius: Radius.zero,
                                child: ListView.builder(
                                  itemCount: groupedSlots.length,
                                  itemBuilder: (context, index) {
                                    return getSlotList(
                                        groupedSlots, index)[index];
                                  },
                                ),
                              );
                            },
                          );
                        },
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

  Widget buildDropdownMenuItem(FilterBy filter) {
    return DropdownMenuItem<FilterBy>(
      value: filter,
      child: Container(
        padding: EdgeInsets.only(right: 10),
        child: Text(filter.value.toUpperCase()),
      ),
    );
  }

  List<Widget> getSlotList(Map<DateTime, List<SlotModel>> slots, int index) {
    List<Widget> items = [];
    double bottom = index == slots.length - 1 ? 10 : 0;

    for (var slot in slots.entries) {
      DateFormat formatter = DateFormat('dd MMM yyyy, EEEE');
      String formatted = formatter.format(slot.key);
      Duration totalWorkDuration = getTotalWorkDuration(slot.value);
      Duration difference = totalWorkDuration - Duration(hours: 8);

      items.add(
        Container(
          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, bottom),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              FadeRouteTransition(
                page: HistoryDetailScreen(formatted, slot.value),
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Color(0xFFDEE2E6),
                border: Border.all(
                  width: 1,
                  color: Color(0xFFADB5BD),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatted,
                        style: GoogleFonts.openSans(fontSize: 21),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          '${slot.value.length} records',
                          style: GoogleFonts.openSans(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        child: Text(
                          Util.formatDuration(totalWorkDuration),
                          style: GoogleFonts.openSans(fontSize: 21),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.0, right: 3.0),
                        child: buildDifferenceIndicator(difference),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
        Container(
          padding: EdgeInsets.only(right: 5.0),
          child: duration.isNegative
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
        ),
        Container(
          height: 20,
          alignment: Alignment.centerRight,
          child: Text(
            Util.formatDuration(duration, addSign: true, padLeft: false),
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

  void sortAscending(List<SlotModel> slotModels) {
    slotModels.sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  void sortDescending(List<SlotModel> slotModels) {
    slotModels.sort((a, b) => a.startTime.compareTo(b.startTime));
  }
}

enum FilterBy {
  weekly,
  monthly,
  yearly,
}

extension FilterByExtension on FilterBy {
  String get value => this.toString().split('.').last;
}
