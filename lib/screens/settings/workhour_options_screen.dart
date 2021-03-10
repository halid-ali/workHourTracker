import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/screens/settings/settings_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/widgets/app_toast.dart';
import 'package:work_hour_tracker/widgets/fade_transition.dart';

class WorkHourOptionsScreen extends StatefulWidget {
  WorkHourOptionsScreen({Key key}) : super(key: key);

  @override
  _WorkHourOptionsScreenState createState() => _WorkHourOptionsScreenState();
}

class _WorkHourOptionsScreenState extends State<WorkHourOptionsScreen> {
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
                              page: SettingsScreen(),
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            S.of(context).work_hour_options,
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
                    margin: EdgeInsets.only(bottom: 10),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).available_options,
                      style: GoogleFonts.openSans(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F3F4),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFD3D3D3),
                        ),
                      ),
                      child: _getWorkHourOptions(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      S.of(context).add_update_options,
                      style: GoogleFonts.openSans(
                        fontSize: 19,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F3F4),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFFD3D3D3),
                        ),
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

  Widget _getWorkHourOptions() {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return StreamBuilder(
      stream: firestore.collection('workHourOptions').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(S.of(context).error_occurred);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var options = snapshot.data.docs;
        options.sort(
          (a, b) => a
              .data()['name']
              .toString()
              .compareTo(b.data()['name'].toString()),
        );
        return Scrollbar(
          thickness: 5,
          hoverThickness: 5,
          showTrackOnHover: true,
          isAlwaysShown: true,
          radius: Radius.zero,
          child: ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              double bottom = index == options.length - 1 ? 10 : 0;
              String id = options[index].id;
              String name = options[index].data()['name'];
              String description = options[index].data()['description'];
              return Container(
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.only(
                  top: 10.0,
                  left: 10.0,
                  right: 10.0,
                  bottom: bottom,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFDEE2E6),
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFADB5BD),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.openSans(fontSize: 17),
                      ),
                    ),
                    Tooltip(
                      message: S.of(context).details,
                      padding: EdgeInsets.all(5.0),
                      textStyle: GoogleFonts.openSans(
                          fontSize: 15, color: Colors.white),
                      decoration: BoxDecoration(color: Color(0xFF212529)),
                      child: InkWell(
                        onTap: () => onDetailsTapped(name, description),
                        child: Icon(
                          Icons.info_outline_rounded,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: S.of(context).edit,
                      padding: EdgeInsets.all(5.0),
                      textStyle: GoogleFonts.openSans(
                          fontSize: 15, color: Colors.white),
                      decoration: BoxDecoration(color: Color(0xFF212529)),
                      child: InkWell(
                        onTap: () => print('edit'),
                        child: Icon(
                          Icons.edit_sharp,
                          color: Color(0xFF0077B6),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Tooltip(
                      message: S.of(context).delete,
                      padding: EdgeInsets.all(5.0),
                      textStyle: GoogleFonts.openSans(
                          fontSize: 15, color: Colors.white),
                      decoration: BoxDecoration(color: Color(0xFF212529)),
                      child: InkWell(
                        onTap: () => onDeleteTapped(firestore, id, name),
                        child: Icon(
                          Icons.delete_forever_sharp,
                          color: Color(0xFFBA181B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  void onDetailsTapped(String title, String contentString) {
    showDialog<AlertDialog>(
      context: context,
      builder: (context) {
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height * .3,
            horizontal: MediaQuery.of(context).size.width * .1,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
          backgroundColor: Colors.grey[200],
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title),
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
          titlePadding: EdgeInsets.all(20.0),
          shape: Border.all(width: 1, color: Colors.black),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contentString.replaceAll('#', '\n').replaceAll('\$', '  '),
                  style: GoogleFonts.ibmPlexMono(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void onDeleteTapped(
    FirebaseFirestore firestore,
    String optionId,
    String optionName,
  ) {
    showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(S.of(context).warning),
          insetPadding: EdgeInsets.symmetric(horizontal: 20),
          contentPadding: EdgeInsets.all(0),
          titlePadding: EdgeInsets.only(top: 10, left: 10, right: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
                border: Border.all(
              width: 1,
              color: Colors.white,
            )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).option_will_deleted(optionName),
                        style: GoogleFonts.openSans(),
                      ),
                      Text(
                        S.of(context).really_delete,
                        style: GoogleFonts.openSans(),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Container(
                          color: Color(0XFF161616),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            S.of(context).no.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: InkWell(
                        child: Container(
                          color: Color(0xFFDA1E28),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(15),
                          child: Text(
                            S.of(context).yes.toUpperCase(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          try {
                            firestore
                                .collection('workHourOptions')
                                .doc(optionId)
                                .delete();
                            AppToast.info(context,
                                S.of(context).option_deleted(optionName));
                          } catch (e) {
                            print(e);
                          } finally {
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        },
                      ),
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
}
