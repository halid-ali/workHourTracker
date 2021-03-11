import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/classes/status.dart';
import 'package:work_hour_tracker/classes/work_hour_slot.dart';
import 'package:work_hour_tracker/data/model/work_hour_option_model.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/utils/login.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/settings.dart';
import 'package:work_hour_tracker/widgets/app_drawer.dart';
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
  final SlidableController _slidableController = SlidableController();
  final DisplayFormat _displayFormat = AppSettings.displayFormat;
  final List<WorkHourSlot> _workSlots = [];
  scheme.ColorScheme _colorScheme;
  WorkHourSlot _currentSlot;
  String _selectedOption;

  bool _isStarted = false;
  bool _isStopped = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      Duration(seconds: 1),
      (Timer t) => setState(() {
        if (_currentSlot != null && _currentSlot.status == Status.running) {
          _currentSlot.workDuration;
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xFF212529),
          title: Text(
            '${S.of(context).appTitle} ${PlatformInfo.isWeb() ? 'Web' : 'Mobile'}',
            style: GoogleFonts.notoSerif(fontSize: 25, letterSpacing: 0.7),
          ),
        ),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildDropdownButton(),
                  SizedBox(height: 20),
                  _buildButtons(),
                  SizedBox(height: 20),
                  _buildListHeader(),
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
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 1),
                        itemCount: _workSlots.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              _getSlidable(_workSlots[index], index % 2 != 0)
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 2),
                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
        drawer: AppDrawer(),
      ),
    );
  }

  Widget _buildDropdownButton() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder(
      stream: firestore.collection('workHourOptions').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(S.of(context).error_occurred);
        }

        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }

        var options = snapshot.data.docs;
        options.sort(
          (a, b) => a
              .data()['name']
              .toString()
              .compareTo(b.data()['name'].toString()),
        );

        return Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(width: 1, color: Colors.grey[400]),
          ),
          child: DropdownButton<String>(
            icon: Icon(Icons.arrow_drop_down_sharp),
            isExpanded: true,
            underline: Container(),
            value: _selectedOption,
            hint: Text(
              S.of(context).dropdownDefault,
              style: GoogleFonts.openSans(fontSize: 21),
            ),
            items: _getMenuItems(options
                .map((e) => WorkHourOption.fromJson(e.id, e.data()))
                .toList()),
            onChanged: !_isStopped && Login.isLogged()
                ? (String value) {
                    setState(() {
                      _selectedOption = value;
                      _isStarted = true;
                    });
                  }
                : null,
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<String>> _getMenuItems(List<WorkHourOption> options) {
    List<DropdownMenuItem<String>> menuItems = [];

    for (var option in options) {
      menuItems.add(
        DropdownMenuItem<String>(
          value: option.name,
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

  Widget _buildButtons() {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TrackButton(
            icon: Icons.play_arrow_sharp,
            color: Color(0xFF3FA34D),
            onPressCallback: _startFunc,
            isActiveCallback: () => _isStarted,
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.pause_sharp,
            color: Color(0xFF0077B6),
            onPressCallback: _breakFunc,
            isActiveCallback: () => _isPaused,
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.stop_sharp,
            color: Color(0xFFD90429),
            onPressCallback: _stopFunc,
            isActiveCallback: () => _isStopped,
          ),
          SizedBox(width: 20),
          TrackButton(
            icon: Icons.save_sharp,
            color: Color(0xFF22333B),
            onPressCallback: () {},
            isActiveCallback: () => _isStopped,
          ),
        ],
      ),
    );
  }

  Widget _getSlidable(WorkHourSlot workSlot, bool isOdd) {
    return Slidable(
      key: Key(workSlot.option),
      controller: _slidableController,
      actionPane: SlidableStrechActionPane(),
      closeOnScroll: true,
      actionExtentRatio: 0.20,
      dismissal: SlidableDismissal(
        child: SlidableDrawerDismissal(),
        onDismissed: (actionType) {
          setState(() {
            _workSlots.remove(workSlot);
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
      child: _buildListRow(
        workSlot.option,
        DateFormat('HH:mm').format(workSlot.startTime),
        workSlot.stopTime != null
            ? DateFormat('HH:mm').format(workSlot.stopTime)
            : '--:--',
        workSlot.breakDuration,
        workSlot.workDuration,
        isOdd,
      ),
    );
  }

  Widget _buildListHeader() {
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

  Widget _buildListRow(
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
                    _formatDisplay(breakDuration, true),
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
                    _formatDisplay(totalWorkHour, true),
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

  Widget _buildFooter() {
    Duration totalWork = _workSlots
        .map<Duration>((e) => e.workDuration)
        .fold(Duration.zero, (p, e) => p + e);

    Duration totalBreak = _workSlots
        .map<Duration>((e) => e.breakDuration)
        .fold(Duration.zero, (p, e) => p + e);

    _setColorScheme(totalWork);

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
          text: _formatDisplay(totalBreak, false),
          textColor: _colorScheme.textColor,
          borderColor: _colorScheme.borderColor,
          backgroundColor: _colorScheme.backgroundColor,
          alignment: Alignment.centerRight,
        ),
        HeaderFooterColumn(
          flex: 2,
          text: _formatDisplay(totalWork, false),
          textColor: _colorScheme.textColor,
          borderColor: _colorScheme.borderColor,
          backgroundColor: _colorScheme.backgroundColor,
          alignment: Alignment.centerRight,
        ),
      ],
    );
  }

  String _formatDisplay(Duration duration, bool isDigitalDisplay) {
    String prefix;
    String suffix;
    String prefixUnit = _displayFormat == DisplayFormat.hourMinute ? 'h' : 'm';
    String suffixUnit = _displayFormat == DisplayFormat.hourMinute ? 'm' : 's';

    if (_displayFormat == DisplayFormat.hourMinute) {
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

  void _setColorScheme(Duration duration) {
    int workHourLimit = 480; // 8 hours
    int overTimeLimit = 570; // 9.5 hours

    var totalWorkDuration = _displayFormat == DisplayFormat.hourMinute
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

  void _startFunc() {
    if (!_isStarted) return;

    setState(() {
      _isStarted = false;
      _isStopped = true;
      _isPaused = true;

      if (_workSlots.isEmpty || _workSlots.last.isStopped) {
        _currentSlot = WorkHourSlot(_selectedOption);
        _currentSlot.start();
        _workSlots.add(_currentSlot);
        AppToast.info(context, S.of(context).timer_started);
      } else if (_workSlots.last.isPaused) {
        _workSlots.last.start();
        AppToast.info(context, S.of(context).timer_resumed);
      }
    });

    print('start tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }

  void _stopFunc() {
    if (!_isStopped) return;

    setState(() {
      _selectedOption = null;
      _isStarted = false;
      _isStopped = false;
      _isPaused = false;

      _currentSlot.stop();
      _currentSlot = null;
    });

    AppToast.info(context, S.of(context).timer_stopped);
    print('stopp tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }

  void _breakFunc() {
    if (!_isPaused) return;

    setState(() {
      _isStarted = true;
      _isStopped = true;
      _isPaused = false;

      _workSlots.last.pause();
    });

    AppToast.info(context, S.of(context).timer_paused);
    print('break tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }
}

enum DisplayFormat {
  hourMinute,
  minuteSecond,
}
