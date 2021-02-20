import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:work_hour_tracker/classes/work_hour_slot.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/widgets/track_button.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  final SlidableController _slidableController = SlidableController();
  final List<String> _options = ['Projekt', 'Allgemeine', 'Fortbildung'];
  final List<WorkHourSlot> _workSlots = [];
  String _selectedOption;

  bool _isStarted = false;
  bool _isStopped = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _workSlots.add(WorkHourSlot.withSampleData('Random Option'));
    _workSlots.add(WorkHourSlot.withSampleData('My Slot'));
    _workSlots.add(WorkHourSlot.withSampleData('Quite Long Option'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${widget.title} ${PlatformInfo.isWeb() ? 'Web' : 'Mobile'}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: PlatformInfo.isWeb()
                  ? 500
                  : MediaQuery.of(context).size.width,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
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
                      'Select an option',
                      style: GoogleFonts.openSans(fontSize: 19),
                    ),
                    items: _options.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(
                          option,
                          style: GoogleFonts.openSans(fontSize: 19),
                        ),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        _selectedOption = value;
                        _isStarted = true;
                      });
                    },
                  ),
                ),
                SizedBox(height: 20),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TrackButton(
                        icon: Icons.play_arrow_sharp,
                        color: Colors.green,
                        onPressCallback: _startFunc,
                        isActiveCallback: () => _isStarted,
                      ),
                      SizedBox(width: 20),
                      TrackButton(
                        icon: Icons.pause_sharp,
                        color: Colors.blue,
                        onPressCallback: _breakFunc,
                        isActiveCallback: () => _isPaused,
                      ),
                      SizedBox(width: 20),
                      TrackButton(
                        icon: Icons.stop_sharp,
                        color: Colors.red,
                        onPressCallback: _stopFunc,
                        isActiveCallback: () => _isStopped,
                      ),
                      SizedBox(width: 20),
                      TrackButton(
                        icon: Icons.save_sharp,
                        color: Colors.amber,
                        onPressCallback: () {},
                        isActiveCallback: () => true,
                      ),
                    ],
                  ),
                ),
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
                      separatorBuilder: (context, index) => SizedBox(height: 1),
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
                SizedBox(height: 20),
                _buildFooter(),
              ],
            ),
          ),
        ),
        drawer: Drawer(),
      ),
    );
  }

  Widget _getSlidable(WorkHourSlot workSlot, bool isOdd) {
    return Slidable(
      controller: _slidableController,
      actionPane: SlidableStrechActionPane(),
      closeOnScroll: true,
      actionExtentRatio: 0.20,
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
              setState(() {
                _workSlots.remove(workSlot);
              });
              print('delete');
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
    return Container(
      child: Row(
        children: [
          _buildColumn('Option', 4),
          SizedBox(width: 2),
          _buildColumn('Start', 2),
          SizedBox(width: 2),
          _buildColumn('Break', 2),
          SizedBox(width: 2),
          _buildColumn('Total', 2),
        ],
      ),
    );
  }

  Widget _buildColumn(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[300],
          border: Border.all(
            width: 1,
            color: Colors.blue[700],
          ),
        ),
        padding: EdgeInsets.all(5),
        child: Text(
          text,
          style: GoogleFonts.openSans(
            color: Colors.blue[800],
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
    return Column(
      children: [
        Container(
          color: isOdd ? Colors.grey[200] : Colors.grey[300],
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    option,
                    style: GoogleFonts.ibmPlexMono(fontSize: 23),
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
                        alignment: Alignment.centerLeft,
                        child: Text(
                          startHour,
                          style: GoogleFonts.ibmPlexMono(fontSize: 23),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          stopHour,
                          style: GoogleFonts.ibmPlexMono(fontSize: 23),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${breakDuration.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
                    '${breakDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: GoogleFonts.ibmPlexMono(fontSize: 23),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    '${totalWorkHour.inMinutes.remainder(60).toString().padLeft(2, '0')}:'
                    '${totalWorkHour.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                    style: GoogleFonts.ibmPlexMono(fontSize: 23),
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

    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Container(
              child: Text(
                'Totals',
                style: GoogleFonts.openSans(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: totalWork.inSeconds > 500
                        ? Colors.red[900]
                        : Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDuration(totalBreak),
                style: GoogleFonts.openSans(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: totalWork.inSeconds > 500
                        ? Colors.red[900]
                        : Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDuration(totalWork),
                style: GoogleFonts.openSans(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: totalWork.inSeconds > 500
                        ? Colors.red[900]
                        : Colors.black),
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: totalWork.inSeconds > 500
            ? Colors.redAccent[100]
            : Colors.grey[400],
        border: Border.all(
          width: 1,
          color: totalWork.inSeconds > 500 ? Colors.red[900] : Colors.black,
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    var totalMinutes = duration.inMinutes;
    var totalSeconds = duration.inSeconds - totalMinutes * 60;
    return '${totalMinutes.toString().padLeft(2, '0')}:'
        '${totalSeconds.toString().padLeft(2, '0')}';
  }

  void _startFunc() {
    if (!_isStarted) return;

    setState(() {
      _isStarted = false;
      _isStopped = true;
      _isPaused = true;

      if (_workSlots.isEmpty || _workSlots.last.isStopped) {
        var workSlot = WorkHourSlot(_selectedOption);
        workSlot.start();
        _workSlots.add(workSlot);
      } else if (_workSlots.last.isPaused) {
        _workSlots.last.start();
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

      _workSlots.last.stop();
    });

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

    print('break tapped at ${DateFormat('HH:mm.ss').format(DateTime.now())}');
  }
}
