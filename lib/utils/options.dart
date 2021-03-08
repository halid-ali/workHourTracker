import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Options {
  static Map<String, String> _options = Map<String, String>();

  static List<DropdownMenuItem<String>> dropdownMenus() {
    _initOptions();
    List<DropdownMenuItem<String>> menuItems = [];

    for (var option in _options.entries) {
      menuItems.add(
        DropdownMenuItem<String>(
          value: option.key,
          child: Tooltip(
            message: option.value,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(20.0),
            textStyle: GoogleFonts.openSans(fontSize: 15, color: Colors.white),
            decoration: BoxDecoration(color: Color(0xFF212529)),
            child: Row(
              children: [
                Text(
                  option.key,
                  style: GoogleFonts.openSans(fontSize: 21),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return menuItems;
  }

  static void _initOptions() {
    _options.putIfAbsent(
        'Projekt',
        () => 'Projektarbeit\n'
            'PCO\n'
            'Arbeitszeiterfassung\n'
            'Reisekostenabrechnung\n'
            'Kleinere Unterbrechungen (Kaffee, Getränke, Cafeteria aufräumen, ...)\n'
            'Bestandspflege TC-Seminarunterlagen');

    _options.putIfAbsent(
        'Allgemeine',
        () =>
            'Team Meetings (Park-Meeting, Team-Meeting, All Staff, Sommer Workshop, Winter Workshop)\n'
            'MPTube\n'
            'Bewerbungsgespräche');

    _options.putIfAbsent(
        'Fortbildung',
        () => 'Firmenkolloquium\n'
            'Tech Talk\n'
            'CMPE-Teilnahme\n'
            'Certified XYZ Teilnahmev'
            'Konferenz Teilnahme\n'
            'Selbststudium\n'
            'Aufbau zum Trainer Seminar und CMPE\n'
            'Bestandspflege CMPE (bis 1 Tag)\n'
            'CMPE Durchführung (Trainer)\n'
            'Mentor-Tätigkeit\n'
            'Teamworkshop- und Teamevent-Planung\n'
            'CoPs');
  }
}
