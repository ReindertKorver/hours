import 'package:fluent_ui/fluent_ui.dart';
import 'package:hours/Models/work_iteration.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';

class HoursInput extends StatefulWidget {
  const HoursInput(
      {Key? key,
      required this.iteration,
      required this.onDelete,
      required this.firstEditController,
      required this.lastEditController,
      required this.onUpdate})
      : super(key: key);
  final WorkIteration iteration;
  final Function(WorkIteration) onDelete;
  final Function(WorkIteration) onUpdate;
  final TextEditingController firstEditController;
  final TextEditingController lastEditController;
  @override
  _HoursInputState createState() => _HoursInputState();
}

class _HoursInputState extends State<HoursInput> {
  String lastLastStr = "";
  String firstLastStr = "";
  bool lastValid = true;
  bool firstValid = true;
  bool markedEndOfDay = false;
  @override
  void initState() {
    widget.firstEditController.addListener(() {
      firstValid = widget.iteration
          .validate(widget.firstEditController.text, 0, widget.onUpdate);
      setState(() {});
    });
    widget.lastEditController.addListener(() {
      lastValid = widget.iteration
          .validate(widget.lastEditController.text, 1, widget.onUpdate);
      setState(() {});
    });
    super.initState();
  }

  Color? firstColor;
  Color? lastColor;
  final flyoutController = FlyoutController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 140,
            child: TextBox(
              maxLength: 5,
              controller: widget.firstEditController,
              textAlign: TextAlign.center,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: firstValid
                              ? FluentTheme.of(context).accentColor
                              : Colors.red))),
            ),
          ),
          Text(" - "),
          SizedBox(
            width: 140,
            child: TextBox(
              suffix: widget.lastEditController.text.contains("23:59")
                  ? Tooltip(
                      message: markedEndOfDay
                          ? "Gemarkeerd als dag einde"
                          : "Markeer als dag einde",
                      child: IconButton(
                        iconButtonMode: IconButtonMode.tiny,
                        // style: ButtonStyle(backgroundColor: markedEndOfDay?),
                        icon: Icon(
                          FluentIcons.arrow_tall_up_right,
                          color: markedEndOfDay
                              ? FluentTheme.of(context).accentColor
                              : null,
                        ),
                        onPressed: () {
                          markedEndOfDay = !markedEndOfDay;
                          if (markedEndOfDay) {
                            widget.iteration.last = DateTime(
                                widget.iteration.last.year,
                                widget.iteration.last.month,
                                widget.iteration.last.day,
                                widget.iteration.last.hour,
                                59,
                                59);
                          } else {
                            widget.iteration.last = DateTime(
                                widget.iteration.last.year,
                                widget.iteration.last.month,
                                widget.iteration.last.day,
                                widget.iteration.last.hour,
                                59,
                                0);
                          }
                          widget.onUpdate(widget.iteration);
                        },
                      ),
                    )
                  : null,
              maxLength: 5,
              controller: widget.lastEditController,
              textAlign: TextAlign.center,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: lastValid
                              ? FluentTheme.of(context).accentColor
                              : Colors.red))),
            ),
          ),
          Flyout(
            verticalOffset: 20,
            contentWidth: 100,
            content: FlyoutContent(
              child: GestureDetector(
                onTap: () => {widget.onDelete(widget.iteration)},
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Icon(FluentIcons.recycle_bin),
                    ),
                    Text("Delete")
                  ],
                ),
              ),
            ),
            controller: flyoutController,
            child: GestureDetector(
              onTap: () => {flyoutController.open = true},
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(FluentIcons.more_vertical),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    flyoutController.dispose();
    super.dispose();
  }
}
