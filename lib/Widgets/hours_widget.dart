import 'package:flutter/services.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import 'package:hours/Models/work_iteration.dart';
import 'package:hours/ViewModels/work_iteration_viewmodel.dart';
import 'package:hours/Widgets/hours_input.dart';
import 'package:hours/utils.dart';
import 'package:stacked/stacked.dart';

class HoursWidget extends StatefulWidget {
  HoursWidget({Key? key}) : super(key: key);

  @override
  State<HoursWidget> createState() => _HoursWidgetState();
}

class _HoursWidgetState extends State<HoursWidget> {
  final flyoutController = FlyoutController();

  final tController = TextEditingController(text: "2");
  final values = ['Kwartier', 'Half uur', 'Uur', '2 Uur'];
  int comboBoxValue = 3;
  bool invalid = true;
  @override
  void initState() {
    tController.addListener(() {
      var val = tController.text;
      if (val.isEmpty) {
        invalid = true;
      } else {
        var res = double.tryParse(val) ?? 2;
        if (res == 0.0 || res > 10) {
          invalid = true;
        } else {
          invalid = false;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WorkIterationViewModel>.reactive(
      onDispose: (model) => model.disposeEditors(),
      viewModelBuilder: () {
        final viewmodel = WorkIterationViewModel();
        viewmodel.loadData();
        return viewmodel;
      },
      builder: (context, model, child) => Container(
        width: 348,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            // color: Color.fromARGB(20, 255, 255, 255)),
            color: FluentTheme.of(context).focusTheme.secondaryBorder?.color),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 8.0, left: 16.0, bottom: 16.0, right: 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Uren vandaag",
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 22),
              ),
              for (var iter in model.iterations)
                HoursInput(
                    firstEditController: model.firstEditControllers[iter.id]!,
                    lastEditController: model.lastEditControllers[iter.id]!,
                    iteration: iter,
                    onUpdate: model.update,
                    onDelete: (e) {
                      model.remove(iter);
                    }),
              Padding(
                padding:
                    const EdgeInsets.only(bottom: 0.0, top: 14.0, right: 2.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Color.fromARGB(15, 255, 255, 255)),
                      child: Tooltip(
                        message: "Click to copy",
                        child: GestureDetector(
                          onTap: () => {
                            Clipboard.setData(
                                ClipboardData(text: model.calcHours()))
                          },
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  FluentSystemIcons
                                      .ic_fluent_calculator_regular,
                                  size: 22,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(model.calcHours() + " uur"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: SizedBox(
                        width: 100,
                        child: Combobox<String>(
                          placeholder: Text('Selected list item'),
                          isExpanded: true,
                          items: values
                              .map((e) => ComboboxItem<String>(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          value: values[comboBoxValue],
                          onChanged: (value) {
                            // print(value);
                            if (value != null && values.contains(value)) {
                              setState(
                                  () => comboBoxValue = values.indexOf(value));
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Flyout(
                        contentWidth: 200,
                        controller: flyoutController,
                        content: FlyoutContent(
                          child: GestureDetector(
                            onTap: () {
                              var a = model.iterations;
                              var selected = DateTime.now();
                              if (a.isNotEmpty) {
                                a.sort((a, b) => a.first.compareTo(b.first));
                                selected = a.first.first;
                              }
                              var hours = 0;
                              var minutes = 0;
                              if (values[comboBoxValue] == values[3]) {
                                hours = 2;
                                minutes = 0;
                              } else if (values[comboBoxValue] == values[2]) {
                                hours = 1;
                                minutes = 0;
                              } else if (values[comboBoxValue] == values[1]) {
                                hours = 0;
                                minutes = 30;
                              } else if (values[comboBoxValue] == values[0]) {
                                hours = 0;
                                minutes = 15;
                              }
                              DateTime selectedFirst = selected.add(
                                  Duration(hours: -hours, minutes: -minutes));
                              var toCheck =
                                  NewTimeOfDay.fromDateTime(selectedFirst);
                              if (toCheck.isValidTimeRange(
                                  NewTimeOfDay(hour: 0, minute: 0),
                                  NewTimeOfDay.fromDateTime(DateTime.now()))) {
                                model.add(selectedFirst, selected);
                              } else {}
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Icon(FluentIcons.padding_top),
                                ),
                                Text("Toevoegen aan begin")
                              ],
                            ),
                          ),
                        ),
                        child: IconButton(
                            style: ButtonStyle(backgroundColor:
                                ButtonState.resolveWith<Color>(((states) {
                              if (states.isHovering) {
                                return Color.fromARGB(33, 255, 255, 255);
                              } else if (states.isPressing) {
                                return Color.fromARGB(50, 255, 255, 255);
                              } else if (states.isNone) {
                                return Color.fromARGB(15, 255, 255, 255);
                              }
                              return Color.fromARGB(15, 255, 255, 255);
                            }))),
                            icon: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                FluentSystemIcons.ic_fluent_add_regular,
                                size: 18,
                              ),
                            ),
                            onPressed: () {
                              var a = model.iterations;
                              var selected = DateTime.now();
                              if (a.isNotEmpty) {
                                a.sort((a, b) => a.last.compareTo(b.last));
                                selected = a.last.last;
                              }
                              var hours = 0;
                              var minutes = 0;
                              if (values[comboBoxValue] == values[3]) {
                                hours = 2;
                                minutes = 0;
                              } else if (values[comboBoxValue] == values[2]) {
                                hours = 1;
                                minutes = 0;
                              } else if (values[comboBoxValue] == values[1]) {
                                hours = 0;
                                minutes = 30;
                              } else if (values[comboBoxValue] == values[0]) {
                                hours = 0;
                                minutes = 15;
                              }
                              DateTime selectedLast = selected.add(
                                  Duration(hours: hours, minutes: minutes));
                              var toCheck =
                                  NewTimeOfDay.fromDateTime(selectedLast);
                              if (toCheck.isValidTimeRange(
                                  NewTimeOfDay.fromDateTime(DateTime.now()),
                                  NewTimeOfDay(hour: 23, minute: 59))) {
                                model.add(selected, selectedLast);
                              } else {
                                if (selected.hour == 23 &&
                                    selected.minute == 59 &&
                                    selected.second == 59) {
                                  flyoutController.open = true;
                                } else {
                                  model.add(
                                      selected,
                                      DateTime(selected.year, selected.month,
                                              selected.day)
                                          .add(Duration(
                                              hours: 23,
                                              minutes: 59,
                                              seconds: 59)));
                                }
                              }
                            }),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
