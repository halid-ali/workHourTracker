import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/data/repo/option_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/utils/util.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';

class HistoryItem extends StatefulWidget {
  final SlotModel slot;

  HistoryItem(this.slot, {Key key}) : super(key: key);

  @override
  _HistoryItemState createState() => _HistoryItemState();
}

class _HistoryItemState extends State<HistoryItem> {
  final TextEditingController workDurationController = TextEditingController();
  final TextEditingController pauseDurationController = TextEditingController();
  Duration pauseDuration;
  Duration workDuration;
  String comment;
  bool isPressed = false;
  int speedMillisecond = 200;

  @override
  void initState() {
    setState(() {
      pauseDuration = Duration(milliseconds: widget.slot.pauseDuration);
      workDuration = getTotalWorkDuration();
      setTextControllers(pauseDuration, workDuration);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: OptionRepository.getWorkHourOption(widget.slot.optionId),
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
        String startTime = formatter.format(widget.slot.startTime);
        String finishTime = formatter.format(widget.slot.stopTime);
        String comment = widget.slot.comment ?? 'N/A';

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
                              child: buildNumericUpDown(),
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
                              child: buildTextfield(),
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

  Widget buildNumericUpDown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 27,
            child: Container(
              child: TextField(
                maxLines: 1,
                readOnly: true,
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.bottom,
                controller: pauseDurationController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Column(
            children: [
              //Increase pause duration
              GestureDetector(
                child: InkWell(
                  onTap: increasePauseDuration,
                  child: Icon(Icons.keyboard_arrow_up_sharp, size: 15),
                ),
                onLongPress: () => onLongPressCallback(increasePauseDuration),
                onLongPressEnd: onLongPressEndCallback,
              ),
              //Decrease pause duration
              GestureDetector(
                child: InkWell(
                  onTap: decreasePauseDuration,
                  child: Icon(Icons.keyboard_arrow_down_sharp, size: 15),
                ),
                onLongPress: () => onLongPressCallback(decreasePauseDuration),
                onLongPressEnd: onLongPressEndCallback,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildTextfield() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.blue,
        ),
      ),
      child: SizedBox(
        width: 85,
        height: 27,
        child: Container(
          child: TextField(
            maxLines: 1,
            readOnly: true,
            textAlign: TextAlign.right,
            textAlignVertical: TextAlignVertical.bottom,
            controller: workDurationController,
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  void increasePauseDuration() {
    setState(() {
      if (pauseDuration.inMinutes >= getTotalDuration().inMinutes) return;

      pauseDuration = pauseDuration + Duration(minutes: 1);
      workDuration = workDuration - Duration(minutes: 1);
      setTextControllers(pauseDuration, workDuration);
    });
  }

  void decreasePauseDuration() {
    setState(() {
      if (pauseDuration.inMinutes <= 0) return;

      pauseDuration = pauseDuration - Duration(minutes: 1);
      workDuration = workDuration + Duration(minutes: 1);
      setTextControllers(pauseDuration, workDuration);
    });
  }

  void onLongPressCallback(Function func) async {
    int counter = 0;

    setState(() {
      isPressed = true;
    });

    do {
      func();
      counter++;
      await Future.delayed(Duration(milliseconds: speedMillisecond));

      setState(() {
        if (counter > 10 && counter < 50) {
          speedMillisecond = 100;
        } else if (counter > 50 && counter < 200) {
          speedMillisecond = 50;
        } else if (counter > 200 && counter < 500) {
          speedMillisecond = 25;
        } else if (counter > 500) {
          speedMillisecond = 10;
        }
      });
    } while (isPressed);
  }

  void onLongPressEndCallback(LongPressEndDetails details) {
    setState(() {
      isPressed = false;
      speedMillisecond = 100;
    });
  }

  void setTextControllers(Duration pause, Duration work) {
    pauseDurationController.text = Util.formatDuration(pause);
    workDurationController.text = Util.formatDuration(work);
  }

  Duration getTotalWorkDuration() {
    return widget.slot.stopTime.difference(widget.slot.startTime) -
        Duration(milliseconds: widget.slot.pauseDuration);
  }

  Duration getTotalDuration() {
    return widget.slot.stopTime.difference(widget.slot.startTime);
  }
}
