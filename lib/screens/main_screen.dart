import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/data/model/settings_model.dart';
import 'package:work_hour_tracker/data/model/slot_model.dart';
import 'package:work_hour_tracker/data/repo/settings_repo.dart';
import 'package:work_hour_tracker/data/repo/slot_repo.dart';
import 'package:work_hour_tracker/main.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/utils/status.dart';
import 'package:work_hour_tracker/utils/work_hour_slot.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';
import 'package:work_hour_tracker/data/repo/option_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/settings.dart';
import 'package:work_hour_tracker/widgets/app_drawer.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
import 'package:work_hour_tracker/widgets/app_toast.dart';
import 'package:work_hour_tracker/widgets/header_footer.dart';
import 'package:work_hour_tracker/widgets/header_footer_column.dart';
import 'package:work_hour_tracker/widgets/track_button.dart';
import 'package:work_hour_tracker/utils/color_scheme.dart' as scheme;

class MainScreen extends StatefulWidget {
  MainScreen({Key key}) : super(key: key);

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF212529),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${S.of(context).appTitle} ${PlatformInfo.isWeb() ? 'Web' : 'Mobile'}',
                style: GoogleFonts.notoSerif(fontSize: 25, letterSpacing: 0.7),
              ),
              Text(
                'v1.2',
                style: GoogleFonts.notoSerif(fontSize: 25, letterSpacing: 0.7),
              ),
            ],
          ),
        ),
        drawer: AppDrawer(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: PlatformInfo.isWeb()
                    ? 600
                    : MediaQuery.of(context).size.width,
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
                    stream: SettingsRepository.getSettingsByUserId(userId),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return AppLoading(S.of(context).settings_data_load);
                      }

                      if (snapshot.hasError) {
                        return Text(S.of(context).settings_data_load_error);
                      }

                      final settingsData = snapshot.data.docs.first;
                      final settings = SettingsModel.fromJson(
                        settingsData.id,
                        settingsData.data(),
                      );
                      SessionManager.write(SessionKey.settingsId, settings.id);
                      final lang = settings.language;

                      return StreamBuilder(
                        stream: SlotRepository.getWorkHourSlotsByDate(
                            getDayStart()),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return AppLoading(S.of(context).workhour_data_load);
                          }

                          if (snapshot.hasError) {
                            return Text(S.of(context).workhour_data_load_error);
                          }

                          final slots = snapshot.data.docs
                              .map((e) => SlotModel.fromJson(e.id, e.data()))
                              .where((e) => e.userId == userId)
                              .toList();

                          return StreamBuilder(
                            stream: OptionRepository.getWorkHourOptions(userId),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return AppLoading(
                                    S.of(context).option_data_load);
                              }

                              if (snapshot.hasError) {
                                return Text(
                                    S.of(context).option_data_load_error);
                              }

                              var options = snapshot.data.docs
                                  .map((e) =>
                                      OptionModel.fromJson(e.id, e.data()))
                                  .toList();
                              options.sort((a, b) => a.name.compareTo(b.name));

                              if (slots.isEmpty ||
                                  slots.last.timerStatus ==
                                      Status.stopped.value) {
                                return MainScreenContent(
                                  lang: lang,
                                  userId: userId,
                                  lastOption: null,
                                  options: options,
                                  slots: slots,
                                );
                              } else {
                                return FutureBuilder(
                                  future: OptionRepository.getWorkHourOption(
                                      slots.last.optionId),
                                  builder: (context,
                                      AsyncSnapshot<OptionModel> snapshot) {
                                    if (!snapshot.hasData) {
                                      return AppLoading(
                                          S.of(context).last_option_data_load);
                                    }

                                    if (snapshot.hasError) {
                                      return Text(S
                                          .of(context)
                                          .last_option_data_load_error);
                                    }

                                    final option = snapshot.data;

                                    return MainScreenContent(
                                      lang: lang,
                                      userId: userId,
                                      lastOption: option,
                                      options: options,
                                      slots: slots,
                                    );
                                  },
                                );
                              }
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Timestamp getDayStart() {
    DateTime toTime = DateTime.now();
    toTime = DateTime(toTime.year, toTime.month, toTime.day);
    return Timestamp.fromMillisecondsSinceEpoch(toTime.millisecondsSinceEpoch);
  }
}

class MainScreenContent extends StatefulWidget {
  final String lang;
  final String userId;
  final OptionModel lastOption;
  final List<OptionModel> options;
  final List<SlotModel> slots;

  MainScreenContent({
    this.lang,
    this.userId,
    this.lastOption,
    this.options,
    this.slots,
  });

  @override
  _MainScreenContent createState() => _MainScreenContent();
}

class _MainScreenContent extends State<MainScreenContent> {
  final SlidableController _slidableController = SlidableController();
  final TextEditingController commentController = TextEditingController();
  final DisplayFormat displayFormat = AppSettings.displayFormat;

  scheme.ColorScheme _colorScheme;
  WorkHourSlot _currentSlot;
  OptionModel _currentOption;

  @override
  void initState() {
    setState(() {
      if (widget.slots.isNotEmpty &&
          widget.slots.last.timerStatus != Status.stopped.value) {
        _currentOption = widget.lastOption;
        _currentSlot = WorkHourSlot.fromSlot(widget.slots.last);
      }
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => WorkHourTracker.of(context).setLocale(Locale(widget.lang)),
    );

    Timer.periodic(
      displayFormat == DisplayFormat.hourMinute
          ? Duration(minutes: 1)
          : Duration(seconds: 1),
      (Timer t) {
        if (this.mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        buildDropdownButton(),
        SizedBox(height: 20),
        buildButtons(),
        SizedBox(height: 20),
        buildListHeader(),
        SizedBox(height: 2),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(1),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
            ),
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 1),
              itemCount: widget.slots.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    getSlidable(
                      widget.slots,
                      index,
                      index % 2 != 0,
                    )
                  ],
                );
              },
            ),
          ),
        ),
        SizedBox(height: 2),
        buildFooter(widget.slots),
      ],
    );
  }

  Widget buildDropdownButton() {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(width: 1, color: Colors.grey[400]),
      ),
      child: DropdownButton<OptionModel>(
        icon: Icon(Icons.arrow_drop_down_sharp),
        isExpanded: true,
        underline: Container(),
        value: _currentOption,
        hint: Text(
          S.of(context).dropdownDefault,
          style: GoogleFonts.openSans(fontSize: 21),
        ),
        items: getMenuItems(),
        onChanged: _currentSlot == null || isNone()
            ? (OptionModel value) {
                setState(() {
                  _currentOption = value;
                  _currentSlot = WorkHourSlot(widget.userId, _currentOption.id);
                });
              }
            : null,
      ),
    );
  }

  List<DropdownMenuItem<OptionModel>> getMenuItems() {
    List<DropdownMenuItem<OptionModel>> menuItems = [];

    for (var option in widget.options) {
      if (!option.isActive) continue;

      menuItems.add(
        DropdownMenuItem<OptionModel>(
          value: option,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                option.name,
                style: GoogleFonts.openSans(fontSize: 21),
              ),
              Tooltip(
                message: option.description,
                padding: EdgeInsets.all(5.0),
                margin: EdgeInsets.all(20.0),
                textStyle:
                    GoogleFonts.openSans(fontSize: 15, color: Colors.white),
                decoration: BoxDecoration(color: Color(0xFF212529)),
                child: Icon(Icons.info_outline_rounded),
              ),
            ],
          ),
        ),
      );
    }

    return menuItems;
  }

  Widget buildButtons() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TrackButton(
            icon: Icons.play_arrow_sharp,
            color: Color(0xFF3FA34D),
            onPressCallback: startFunc,
            isActiveCallback: () => isPaused() || isStopped() || isNone(),
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.pause_sharp,
            color: Color(0xFF0077B6),
            onPressCallback: breakFunc,
            isActiveCallback: () => isRunning(),
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.stop_sharp,
            color: Color(0xFFD90429),
            onPressCallback: stopFunc,
            isActiveCallback: () => isRunning() || isPaused(),
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.save_sharp,
            color: Color(0xFF22333B),
            onPressCallback: () {},
            isActiveCallback: () => true,
          ),
        ],
      ),
    );
  }

  Widget getSlidable(List<SlotModel> slotModels, int index, bool isOdd) {
    var slot = WorkHourSlot.fromSlot(slotModels[index]);
    return Slidable(
      key: Key(slot.workSlot.id),
      controller: _slidableController,
      actionPane: SlidableStrechActionPane(),
      closeOnScroll: true,
      actionExtentRatio: 0.20,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            SlotRepository.deleteWorkHourSlot(slot.workSlot.id);
            slotModels.removeAt(index);
          });
        },
      ),
      secondaryActions: [
        Container(
          height: double.infinity,
          color: Colors.blue,
          child: IconButton(
            onPressed: () {
              print('edit');
            },
            icon: Icon(
              Icons.edit_sharp,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: double.infinity,
          color: Colors.red,
          child: IconButton(
            onPressed: () {
              _slidableController.activeState.dismiss();
            },
            icon: Icon(
              Icons.delete_forever_sharp,
              color: Colors.white,
            ),
          ),
        ),
      ],
      child: buildListRow(
        widget.options
            .firstWhere(
              (e) => e.id == slot.optionId,
              orElse: () => null,
            )
            .name,
        DateFormat('HH:mm').format(slot.startTime),
        slot.stopTime != null
            ? DateFormat('HH:mm').format(slot.stopTime)
            : '--:--',
        slot.pauseDuration,
        slot.workDuration,
        isOdd,
      ),
    );
  }

  Widget buildListHeader() {
    return HeaderFooter(
      columns: [
        HeaderFooterColumn(
          flex: 4,
          text: S.of(context).listHeaderOption,
          textColor: scheme.ColorScheme.blue().textColor,
          borderColor: scheme.ColorScheme.blue().borderColor,
          backgroundColor: scheme.ColorScheme.blue().backgroundColor,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: S.of(context).listHeaderStart,
          textColor: scheme.ColorScheme.blue().textColor,
          borderColor: scheme.ColorScheme.blue().borderColor,
          backgroundColor: scheme.ColorScheme.blue().backgroundColor,
          alignment: Alignment.center,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: S.of(context).listHeaderBreak,
          textColor: scheme.ColorScheme.blue().textColor,
          borderColor: scheme.ColorScheme.blue().borderColor,
          backgroundColor: scheme.ColorScheme.blue().backgroundColor,
          alignment: Alignment.center,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: S.of(context).listHeaderWork,
          textColor: scheme.ColorScheme.blue().textColor,
          borderColor: scheme.ColorScheme.blue().borderColor,
          backgroundColor: scheme.ColorScheme.blue().backgroundColor,
          alignment: Alignment.center,
        ),
      ],
    );
  }

  Widget buildListRow(
    String option,
    String startHour,
    String stopHour,
    Duration breakDuration,
    Duration totalWorkHour,
    bool isOdd,
  ) {
    var fontColor = Color(0xFF212529);
    return Column(
      children: [
        Container(
          color: isOdd ? Color(0xFFDEE2E6) : Color(0xFFCED4DA),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    option,
                    minFontSize: 1,
                    maxFontSize: 23,
                    maxLines: 2,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 23,
                      color: fontColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Container(
                        child: AutoSizeText(
                          startHour,
                          minFontSize: 1,
                          maxFontSize: 23,
                          maxLines: 1,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 23,
                            color: fontColor,
                          ),
                        ),
                      ),
                      Container(
                        child: AutoSizeText(
                          stopHour,
                          minFontSize: 1,
                          maxFontSize: 23,
                          maxLines: 1,
                          style: GoogleFonts.ibmPlexMono(
                            fontSize: 23,
                            color: fontColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    formatDisplay(breakDuration, true),
                    minFontSize: 1,
                    maxFontSize: 23,
                    maxLines: 1,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 23,
                      color: fontColor,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  padding: EdgeInsets.only(right: 5),
                  alignment: Alignment.centerRight,
                  child: AutoSizeText(
                    formatDisplay(totalWorkHour, true),
                    minFontSize: 1,
                    maxFontSize: 23,
                    maxLines: 1,
                    style: GoogleFonts.ibmPlexMono(
                      fontSize: 23,
                      color: fontColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFooter(List<SlotModel> workSlots) {
    Duration totalWork = workSlots
        .map<WorkHourSlot>((e) => WorkHourSlot.fromSlot(e))
        .map<Duration>((e) => e.getWorkDuration())
        .fold(Duration.zero, (p, e) => p + e);

    Duration totalBreak = workSlots
        .map<WorkHourSlot>((e) => WorkHourSlot.fromSlot(e))
        .map<Duration>((e) => e.getPauseDuration())
        .fold(Duration.zero, (p, e) => p + e);

    setColorScheme(totalWork);

    return HeaderFooter(
      columns: [
        HeaderFooterColumn(
          flex: 6,
          text: S.of(context).footerTotal,
          textColor: _colorScheme.textColor,
          borderColor: _colorScheme.borderColor,
          backgroundColor: _colorScheme.backgroundColor,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: formatDisplay(totalBreak, false),
          textColor: _colorScheme.textColor,
          borderColor: _colorScheme.borderColor,
          backgroundColor: _colorScheme.backgroundColor,
          alignment: Alignment.centerRight,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: formatDisplay(totalWork, false),
          textColor: _colorScheme.textColor,
          borderColor: _colorScheme.borderColor,
          backgroundColor: _colorScheme.backgroundColor,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }

  Future<void> showCommentDialog() {
    return showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .1,
          ),
          backgroundColor: Colors.grey[200],
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Comment'),
                  InkWell(
                    onTap: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Icon(Icons.close_sharp),
                  ),
                ],
              ),
              Divider(thickness: 1, color: Colors.black),
            ],
          ),
          titlePadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          contentPadding: EdgeInsets.all(20.0),
          shape: Border.all(width: 1, color: Colors.black),
          content: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextFormField(
                  maxLines: 9,
                  controller: commentController,
                  style: GoogleFonts.openSans(),
                  decoration: InputDecoration(
                    hintText: 'Comment about the option',
                    hintStyle: GoogleFonts.openSans(color: Color(0xFFCED4DA)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Color(0xFFADB5BD)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(0),
                      borderSide: BorderSide(color: Color(0xFF6C757D)),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                InkWell(
                  onTap: () => Navigator.of(context, rootNavigator: true).pop(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 30,
                    ),
                    color: Color(0xFF6C757D),
                    child: Text(
                      'Save and Stop',
                      style: GoogleFonts.openSans(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String formatDisplay(Duration duration, bool isDigitalDisplay) {
    String prefix;
    String suffix;
    String prefixUnit = displayFormat == DisplayFormat.hourMinute
        ? S.of(context).hour_unit
        : S.of(context).minute_unit;
    String suffixUnit = displayFormat == DisplayFormat.hourMinute
        ? S.of(context).minute_unit
        : S.of(context).second_unit;

    if (displayFormat == DisplayFormat.hourMinute) {
      prefix = duration.inHours.remainder(60).toString().padLeft(2, '0');
      suffix = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    } else {
      prefix = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      suffix = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    }

    return isDigitalDisplay
        ? '$prefix:$suffix'
        : '$prefix$prefixUnit $suffix$suffixUnit';
  }

  void setColorScheme(Duration duration) {
    int workHourLimit = 480; // 8 hours
    int overTimeLimit = 570; // 9.5 hours

    var totalWorkDuration = displayFormat == DisplayFormat.hourMinute
        ? duration.inMinutes
        : duration.inSeconds;

    setState(() {
      if (totalWorkDuration == 0) {
        _colorScheme = scheme.ColorScheme.grey();
      } else if (totalWorkDuration < workHourLimit) {
        _colorScheme = scheme.ColorScheme.green();
      } else if (totalWorkDuration < overTimeLimit) {
        _colorScheme = scheme.ColorScheme.yellow();
      } else {
        _colorScheme = scheme.ColorScheme.red();
      }
    });
  }

  Timestamp getDayStart() {
    DateTime toTime = DateTime.now();
    toTime = DateTime(toTime.year, toTime.month, toTime.day);
    return Timestamp.fromMillisecondsSinceEpoch(toTime.millisecondsSinceEpoch);
  }

  Status getStatus() => _currentSlot?.status ?? null;

  bool isRunning() => getStatus() == Status.running;

  bool isPaused() => getStatus() == Status.paused;

  bool isStopped() => getStatus() == Status.stopped;

  bool isNone() => getStatus() == Status.none;

  void startFunc() {
    if (_currentSlot == null || isRunning() || isStopped()) return;

    setState(() {
      _currentSlot.start();
    });
    AppToast.info(context, S.of(context).timer_started);

    print('start tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }

  void stopFunc() async {
    if (_currentSlot == null || isStopped() || isNone()) return;

    await showCommentDialog();
    setState(() {
      _currentSlot.stop(commentController.text);
      _currentOption = null;
      _currentSlot = null;
    });

    commentController.clear();
    AppToast.info(context, S.of(context).timer_stopped);
    print('stopp tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }

  void breakFunc() {
    if (_currentSlot == null || isPaused() || isStopped() || isNone()) return;

    setState(() {
      _currentSlot.pause();
    });

    AppToast.info(context, S.of(context).timer_paused);
    print('break tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }
}

enum DisplayFormat {
  hourMinute,
  minuteSecond,
}
