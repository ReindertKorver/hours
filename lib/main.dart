import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:get_it/get_it.dart';
import 'package:hours/Models/user.dart';
import 'package:hours/Models/work_iteration.dart';
import 'package:hours/Pages/homepage.dart';
import 'package:hours/Pages/hourspage.dart';
import 'package:hours/Services/work_iteration_service.dart';
import 'package:hours/service_locator.dart';
import 'package:system_theme/system_theme.dart';

GetIt locator = GetIt.instance;
void main() {
  setupServiceLocator();
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    final initialSize = Size(1200, 600);
    win.minSize = Size(500, 500);
    win.size = initialSize;

    win.alignment = Alignment.center;
    win.title = "Uren overzicht";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Uren',
      theme: ThemeData(
        brightness: Brightness.dark,
        accentColor: SystemTheme.accentInstance.accent.toAccentColor(),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var index = 0;
  var pageList = [HomePage(), HoursPage()];
  @override
  Widget build(BuildContext context) {
    return NavigationView(
        appBar: NavigationAppBar(
          automaticallyImplyLeading: false,
          title: MoveWindow(
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 18,
                    child: Image.asset(
                      "assets/logo_small.png",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 1),
                    child: Text(
                      "Uren overzicht",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              ),
            ),
          ),
          actions: MoveWindow(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Spacer(), WindowButtons()],
            ),
          ),
        ),
        contentShape: RoundedRectangleBorder(side: BorderSide.none),
        pane: NavigationPane(
            header: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: const [
                  Icon(FluentSystemIcons.ic_fluent_person_regular),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 1),
                    child: Text("Reindert Korver"),
                  )
                ],
              ),
            ),
            selected: index,
            onChanged: (i) => {
                  setState(() => {index = i})
                },
            items: [
              PaneItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_home_regular),
                  title: Text("Home")),
              PaneItem(
                  icon: Icon(FluentSystemIcons.ic_fluent_clock_regular),
                  title: Text("Alle uren"))
            ]),
        content: pageList[index]);
  }
}

final buttonColors = WindowButtonColors(
    iconNormal: Color.fromARGB(255, 0, 0, 0),
    mouseOver: Color.fromARGB(19, 0, 0, 0),
    mouseDown: Color.fromARGB(108, 255, 255, 255),
    iconMouseOver: Color.fromARGB(255, 0, 0, 0),
    iconMouseDown: Color.fromARGB(255, 0, 0, 0));

final closeButtonColors = WindowButtonColors(
    iconNormal: Color.fromARGB(255, 0, 0, 0),
    mouseOver: Color.fromARGB(255, 151, 1, 1),
    mouseDown: Color.fromARGB(232, 212, 0, 0),
    iconMouseOver: Color.fromARGB(255, 255, 255, 255),
    iconMouseDown: Color.fromARGB(255, 255, 255, 255));
final buttonColorsDark = WindowButtonColors(
    iconNormal: Color.fromARGB(255, 219, 219, 219),
    mouseOver: Color.fromARGB(71, 230, 230, 230),
    mouseDown: Color.fromARGB(108, 255, 255, 255),
    iconMouseOver: Color.fromARGB(255, 200, 200, 200),
    iconMouseDown: Color.fromARGB(255, 255, 255, 255));

final closeButtonColorsDark = WindowButtonColors(
    iconNormal: Color.fromARGB(255, 255, 255, 255),
    mouseOver: Color.fromARGB(255, 151, 1, 1),
    mouseDown: Color.fromARGB(232, 212, 0, 0),
    iconMouseOver: Color.fromARGB(255, 255, 255, 255),
    iconMouseDown: Color.fromARGB(255, 255, 255, 255));

class WindowButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(
            colors: FluentTheme.of(context).brightness == Brightness.dark
                ? buttonColorsDark
                : buttonColors),
        MaximizeWindowButton(
            colors: FluentTheme.of(context).brightness == Brightness.dark
                ? buttonColorsDark
                : buttonColors),
        CloseWindowButton(
            colors: FluentTheme.of(context).brightness == Brightness.dark
                ? closeButtonColorsDark
                : closeButtonColors),
      ],
    );
  }
}
