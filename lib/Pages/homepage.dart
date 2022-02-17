import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:flutter/services.dart';
import 'package:hours/Models/user.dart';
import 'package:hours/Models/work_iteration.dart';
import 'package:hours/Services/work_iteration_service.dart';
import 'package:hours/Widgets/hours_input.dart';
import 'package:hours/Widgets/hours_widget.dart';
import 'package:hours/main.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime dateTimeFirst = DateTime.now();
  DateTime dateTimeLast = DateTime.now().add(Duration(hours: 2));
  TextEditingController firstEditController =
      TextEditingController(text: DateFormat("HH:mm").format(DateTime.now()));
  TextEditingController lastEditController = TextEditingController(
      text: DateFormat("HH:mm").format(DateTime.now().add(Duration(hours: 2))));
  String firstText = "";
  String lastText = "";
  var format = DateFormat("HH:mm");
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: Text(
          "Home",
          style: TextStyle(fontSize: 28),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
        child: HoursWidget(),
      )
    ]);
  }
}
