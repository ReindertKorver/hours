import 'package:fluent_ui/fluent_ui.dart';

class HoursPage extends StatelessWidget {
  const HoursPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Uren"),
      ),
    ]);
  }
}
