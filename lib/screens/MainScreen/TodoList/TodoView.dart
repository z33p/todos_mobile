import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turtle_notes/actions/todos_actions.dart';
import 'package:turtle_notes/helpers/TodosProvider.dart';
import 'package:turtle_notes/helpers/notifications_provider.dart';
import 'package:turtle_notes/models/Todo.dart';
import 'package:turtle_notes/screens/TodoFormScreen/TodoFormScreen.dart';

import '../../../store.dart';
import 'DaysToRemindView.dart';
import 'TodoListTrailing.dart';

class TodoView extends StatefulWidget {
  final Todo todo;

  TodoView(this.todo);

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  bool isBeingRemoved = false;
  bool removed = false;
  bool debug = false;

  void setRemoved(bool value) {
    setState(() {
      removed = value;
    });
  }

  Widget dismissibleBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: Icon(Icons.delete, color: Colors.white),
    );
  }

  void deleteTodo() {
    setState(() {
      isBeingRemoved = false;
      removed = false;
    });
    store.dispatch(deleteTodoAction(widget.todo));
  }

  void showSnackBar(context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: DeleteTodoOnDeactivate(
          '"${widget.todo.title}" deletado.', setRemoved),
      action: SnackBarAction(
        label: "DESFAZER",
        onPressed: () => setState(() => isBeingRemoved = false),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (isBeingRemoved) {
      // If removed make a delete request
      if (removed) deleteTodo();
      // If not removed it should show because is beign removed
      return SizedBox.shrink();
    }

    return Dismissible(
      key: Key(widget.todo.id.toString()),
      onDismissed: (direction) {
        setState(() => isBeingRemoved = true);
        showSnackBar(context);
      },
      background: dismissibleBackground(),
      child: Card(
        elevation: 2.5,
        child: Column(
          children: <Widget>[
            ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoFormScreen(
                        title: widget.todo.title,
                        todo: widget.todo,
                        isReadingTodo: true,
                      ),
                    ),
                  );
                },
                isThreeLine: true,
                leading: Checkbox(
                  value: widget.todo.isDone,
                  onChanged: (isChecked) {
                    if (isChecked)
                      cancelEachNotification(widget.todo.notifications);
                    else
                      setNotifications(widget.todo, todoExists: true);

                    store.dispatch(patchTodoAction({
                      columnId: widget.todo.id,
                      columnIsDone: isChecked ? 1 : 0
                    }));
                  },
                ),
                title: Text(
                  widget.todo.title.length < 20
                      ? widget.todo.title
                      : widget.todo.title.substring(0, 20) + "...",
                  style: TextStyle(
                      fontSize: 16,
                      decoration: widget.todo.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
                subtitle: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.todo.description.length < 50
                            ? widget.todo.description
                            : widget.todo.description.substring(0, 50) + "...",
                        style: TextStyle(
                            decoration: widget.todo.isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                    ),
                    DaysToRemindView(widget.todo)
                  ],
                ),
                trailing: TodoListTrailling(widget.todo)),
            !debug
                ? SizedBox.shrink()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "Criado: " +
                            DateFormat("dd-MM-yyyy HH:mm")
                                .format(widget.todo.createdAt),
                        style: TextStyle(fontSize: 11.0),
                      ),
                      Text(
                          "Atualizado: " +
                              DateFormat("dd-MM-yyyy HH:mm")
                                  .format(widget.todo.updatedAt),
                          style: TextStyle(fontSize: 11.0)),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

class DeleteTodoOnDeactivate extends StatefulWidget {
  final String text;
  final void Function(bool value) setRemoved;

  DeleteTodoOnDeactivate(this.text, this.setRemoved);

  @override
  _DeleteTodoOnDeactivateState createState() => _DeleteTodoOnDeactivateState();
}

class _DeleteTodoOnDeactivateState extends State<DeleteTodoOnDeactivate> {
  @protected
  @mustCallSuper
  void deactivate() async {
    // Set removed as true before dissapear thus if it is being removed it will be deleted
    widget.setRemoved(true);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Text(widget.text);
  }
}
