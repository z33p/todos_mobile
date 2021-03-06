import 'package:flutter/material.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/NotificationFields/TimePeriodsField.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoForm/TodoForm.dart';

class DaysToRemindField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, bottom: 28),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: WeekDays.values
              .map(
                (WeekDays day) => ValueListenableBuilder<bool>(
                    valueListenable: todoForm.daysToRemindController[day.index],
                    builder: (BuildContext context, bool dayToRemind, _) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.width / 10,
                        width: MediaQuery.of(context).size.width / 10,
                        child: FlatButton(
                          padding: EdgeInsets.all(0.0),
                          shape: CircleBorder(),
                          onPressed: () {
                            if (todoForm.isReadingTodoController.value)
                              todoForm.isReadingTodo = false;

                            todoForm.setDaysToRemind(
                              index: day.index,
                              value: !dayToRemind,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.0),
                            decoration: ShapeDecoration(
                              color: todoForm
                                      .daysToRemindController[day.index].value
                                  ? Colors.teal
                                  : Colors.white,
                              shape: CircleBorder(),
                              shadows: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius:
                                      4.0, // has the effect of softening the shadow
                                  spreadRadius:
                                      0.5, // has the effect of extending the shadow
                                  offset: Offset(1.0, 1.0),
                                )
                              ],
                            ),
                            child: Text(
                              day.label,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: todoForm
                                        .daysToRemindController[day.index].value
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
              .toList()),
    );
  }
}
