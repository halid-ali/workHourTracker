import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/data/model/option_model.dart';
import 'package:work_hour_tracker/data/repo/option_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/screens/settings/settings_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
import 'package:work_hour_tracker/widgets/app_toast.dart';
import 'package:work_hour_tracker/widgets/fade_transition.dart';

class OptionsScreen extends StatefulWidget {
  OptionsScreen({Key key}) : super(key: key);

  @override
  _OptionsScreenState createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController optionNameController = TextEditingController();
  final TextEditingController optionDescController = TextEditingController();
  String panelHeader = '';
  String buttonTitle = '';
  bool isActive = false;
  bool isAddPanelVisible = false;
  bool isEditPanelVisible = false;
  OptionModel workHourOption;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: FutureBuilder(
              future: SessionManager.read(SessionKey.userId),
              builder: (context, AsyncSnapshot<String> snapshot) {
                if (!snapshot.hasData) {
                  return AppLoading(S.of(context).option_data_load);
                }

                if (snapshot.hasError) {
                  return Text(S.of(context).option_data_load_error);
                }

                final userId = snapshot.data;

                return Padding(
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                S.of(context).available_options,
                                style: GoogleFonts.openSans(
                                  fontSize: 19,
                                ),
                              ),
                              Tooltip(
                                message: S.of(context).add_new_option,
                                padding: EdgeInsets.all(5.0),
                                textStyle: GoogleFonts.openSans(
                                    fontSize: 15, color: Colors.white),
                                decoration:
                                    BoxDecoration(color: Color(0xFF212529)),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEditPanelVisible = false;
                                      isAddPanelVisible = true;
                                      isActive = false;
                                      panelHeader = S.of(context).add_option;
                                      workHourOption = OptionModel();
                                      buttonTitle = S.of(context).add;
                                    });
                                  },
                                  child: Icon(Icons.add_sharp),
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
                            child: _getWorkHourOptions(userId),
                          ),
                        ),
                        isAddPanelVisible || isEditPanelVisible
                            ? Container(
                                padding: EdgeInsets.only(
                                  top: 20.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 10.0,
                                ),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  panelHeader,
                                  style: GoogleFonts.openSans(
                                    fontSize: 19,
                                  ),
                                ),
                              )
                            : Container(),
                        _buildAddEditPanel(userId),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget _getWorkHourOptions(String userId) {
    return StreamBuilder(
      stream: OptionRepository.getWorkHourOptions(userId),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(S.of(context).option_data_load_error);
        }

        if (!snapshot.hasData) {
          return AppLoading(S.of(context).option_data_load);
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
              var option = OptionModel.fromJson(
                options[index].id,
                options[index].data(),
              );
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
                        option.name,
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
                        onTap: () => _onDetailsTapped(
                          option.name,
                          option.description,
                        ),
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
                        onTap: () {
                          setState(() {
                            isAddPanelVisible = false;
                            isEditPanelVisible = true;
                            panelHeader = S.of(context).edit_option;
                            workHourOption = option;
                            isActive = workHourOption.isActive;
                            buttonTitle = S.of(context).edit;
                          });
                        },
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
                        onTap: () => _onDeleteTapped(
                          option.id,
                          option.name,
                        ),
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

  void onAddOption(String userId) async {
    var workHourOption = OptionModel(
      userId: userId,
      name: optionNameController.text.trim(),
      description: optionDescController.text.trim(),
      isActive: isActive,
    );

    OptionRepository.addWorkHourOption(workHourOption).then((value) {
      setState(() {
        optionNameController.text = '';
        optionDescController.text = '';
        isAddPanelVisible = false;
      });
      AppToast.success(
        context,
        S.of(context).new_option_added(workHourOption.name),
      );
    }).catchError((error) {
      AppToast.error(
          context,
          '${S.of(context).add_error_message}\n'
          '${S.of(context).console_details}');
      print(error);
    });
  }

  void onEditOption(String userId) async {
    var updatedOption = OptionModel(
      id: workHourOption.id,
      userId: userId,
      name: optionNameController.text.trim(),
      description: optionDescController.text.trim(),
      isActive: isActive,
    );

    OptionRepository.updateWorkHourOption(updatedOption).then((value) {
      setState(() {
        optionNameController.text = '';
        optionDescController.text = '';
        isEditPanelVisible = false;
      });
    }).catchError((error) {
      AppToast.error(
          context,
          '${S.of(context).update_error_message}\n'
          '${S.of(context).console_details}');
      print(error);
    });
  }

  Widget _buildAddEditPanel(String userId) {
    if (!isAddPanelVisible && !isEditPanelVisible) return Container();

    if (isEditPanelVisible) {
      optionNameController.text = workHourOption.name;
      optionDescController.text = workHourOption.description;
    } else {
      optionNameController.text = '';
      optionDescController.text = '';
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xFFF5F3F4),
        border: Border.all(
          width: 1,
          color: Color(0xFFD3D3D3),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: optionNameController,
                        style: GoogleFonts.openSans(),
                        decoration: InputDecoration(
                          hintText: S.of(context).option_name,
                          hintStyle:
                              GoogleFonts.openSans(color: Color(0xFFCED4DA)),
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
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Container(
                      color: Colors.white,
                      child: TextFormField(
                        maxLines: 9,
                        controller: optionDescController,
                        style: GoogleFonts.openSans(),
                        decoration: InputDecoration(
                          hintText: S.of(context).option_description,
                          hintStyle:
                              GoogleFonts.openSans(color: Color(0xFFCED4DA)),
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
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Checkbox(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ),
                Text(
                  S.of(context).active,
                  style: GoogleFonts.openSans(
                    fontSize: 15,
                  ),
                ),
                Expanded(child: Container()),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    bottom: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        optionNameController.text = '';
                        optionDescController.text = '';
                        isAddPanelVisible = false;
                        isEditPanelVisible = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      color: Color(0xFF6C757D),
                      child: Text(
                        S.of(context).cancel,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: InkWell(
                    onTap: () {
                      isAddPanelVisible
                          ? onAddOption(userId)
                          : onEditOption(userId);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      color: Color(0xFF1D3557),
                      child: Text(
                        buttonTitle,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onDetailsTapped(String title, String contentString) {
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

  void _onDeleteTapped(
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
              ),
            ),
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
                          OptionRepository.deleteWorkHourOption(
                            optionId,
                          ).then(
                            (value) {
                              Navigator.of(context, rootNavigator: true).pop();
                              AppToast.info(
                                context,
                                S.of(context).option_deleted(optionName),
                              );
                            },
                          ).catchError((error) {
                            AppToast.error(
                                context,
                                '${S.of(context).delete_error_message}\n'
                                '${S.of(context).console_details}');
                            print(error);
                          });
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
