import 'pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'pages/reminder.dart';
import 'logic/config.dart';

void main() {
  var config = Config(System.device);
  runApp(
    MaterialApp(
      home: Alfred(config),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class Alfred extends StatefulWidget {
  const Alfred(Config config, {super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Alfred> {
  // https://pub.dev/packages/shared_preferences/example

  int _selectedIndex = 1;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w600,
  );

  List<Color> colors = [
    Colors.teal,
    Colors.white,
    Colors.amber[600]!,
  ];

  PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: controller,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: <Widget>[
          MyPage1(
            bgc: colors[0],
            key: ValueKey(_selectedIndex == 0 ? "page1" : "page1_dismissed"),
            nbr: 'One',
          ),
          ReminderPage(
            bgc: colors[1],
            key: ValueKey(_selectedIndex == 1 ? "page2" : "page2_dismissed"),
            nbr: 'Reminders',
          ),
          SettingsPage(
            bgc: colors[2],
            key: ValueKey(_selectedIndex == 2 ? "page3" : "page3_dismissed"),
            nbr: 'Tree',
          ),
        ],
      ),
      bottomNavigationBar: navbar(),
    );
  }

  Widget navbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Container(
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: GNav(
            tabBorderRadius: 10,
            duration: const Duration(milliseconds: 400),
            backgroundColor: Colors.black,
            color: Colors.white38,
            tabBackgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
            gap: 8,
            tabs: [
              GButton(
                text: "History",
                icon: Icons.timeline,
                hoverColor: colors[0],
              ),
              GButton(
                text: "Home",
                icon: Icons.dashboard,
                hoverColor: colors[1],
              ),
              GButton(
                text: "Setting",
                icon: Icons.straighten,
                hoverColor: colors[2],
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              controller.animateToPage(
                index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInCubic,
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyPage1 extends StatelessWidget {
  final Color bgc;
  final String nbr;

  const MyPage1({super.key, required this.bgc, required this.nbr});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgc,
      child: Center(
        child: Text(nbr),
      ),
    );
  }
}
