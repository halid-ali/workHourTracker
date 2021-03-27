import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:work_hour_tracker/data/model/settings_model.dart';
import 'package:work_hour_tracker/data/repo/settings_repo.dart';
import 'package:work_hour_tracker/generated/l10n.dart';
import 'package:work_hour_tracker/main.dart';
import 'package:work_hour_tracker/screens/settings/settings_screen.dart';
import 'package:work_hour_tracker/utils/platform_info.dart';
import 'package:work_hour_tracker/utils/session_manager.dart';
import 'package:work_hour_tracker/widgets/app_loading.dart';
import 'package:work_hour_tracker/widgets/fade_transition.dart';

class LanguagesScreen extends StatefulWidget {
  LanguagesScreen({Key key}) : super(key: key);

  @override
  _LanguagesScreenState createState() => _LanguagesScreenState();
}

class _LanguagesScreenState extends State<LanguagesScreen> {
  Icon get _selected => Icon(Icons.check_box_sharp, color: Color(0xFF008000));
  Icon get _unselected => Icon(null);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: SessionManager.read(SessionKey.settingsId),
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return AppLoading(S.of(context).session_data_load);
            }

            if (snapshot.hasError) {
              return Text(S.of(context).session_data_load_error);
            }

            final settingsId = snapshot.data;

            return FutureBuilder(
              future: SettingsRepository.getSettings(settingsId),
              builder: (context, AsyncSnapshot<SettingsModel> snapshot) {
                if (!snapshot.hasData) {
                  return AppLoading(S.of(context).settings_data_load);
                }

                if (snapshot.hasError) {
                  return Text(S.of(context).settings_data_load_error);
                }

                final settings = snapshot.data;

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
                                  S.of(context).language,
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
                                _buildLanguageOption('de', 'Deutsch', settings),
                                _buildLanguageOption('en', 'English', settings),
                                _buildLanguageOption('tr', 'Türkçe', settings),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    String flag,
    String langText,
    SettingsModel settings,
  ) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFADB5BD),
          width: 1,
        ),
      ),
      child: TextButton(
        onPressed: () {
          setState(() {
            WorkHourTracker.of(context).setLocale(Locale(flag));
            SettingsRepository.updateSettings(SettingsModel(
              id: settings.id,
              userId: settings.userId,
              language: flag,
            ));
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Image(image: AssetImage('$flag.png')),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    langText,
                    style: GoogleFonts.openSans(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFFCED4DA),
                    width: 1,
                  ),
                ),
                child: settings.language == flag ? _selected : _unselected,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
