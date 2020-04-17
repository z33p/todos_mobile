import 'package:flutter/material.dart';
import 'package:todos_mobile/actions/todos_actions.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../../store.dart';
import 'FormScreenActionButton.dart';
import 'TodoForm.dart';

class TodoFormScreen extends StatefulWidget {
  final String title;
  final Todo todo;
  final bool isUpdatingTodo;

  TodoFormScreen(
      {this.title = "Criar Todo", this.todo, this.isUpdatingTodo = false});

  @override
  _TodoFormScreenState createState() => _TodoFormScreenState(todo: todo);
}

class _TodoFormScreenState extends State<TodoFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Todo todo;

  TextEditingController titleController;
  TextEditingController descriptionController;
  bool isDoneController;

  _TodoFormScreenState({this.todo}) {
    titleController = TextEditingController(text: this.todo?.title ?? "");
    descriptionController =
        TextEditingController(text: this.todo?.description ?? "");
    isDoneController = this.todo?.isDone ?? false;
  }

  @protected
  @mustCallSuper
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void setIsDone(bool value) {
    setState(() {
      isDoneController = value;
    });
  }

  Future<bool> createOrEditTodo() async {
    Todo todo = Todo(
        title: titleController.text,
        description: descriptionController.text,
        isDone: isDoneController);

    if (widget.isUpdatingTodo) {
      todo.id = this.todo.id;
      bool successful = await updateTodoRequest(todo);
      if (successful) store.dispatch(updateTodoAction(todo));

      return successful;
    }

    Todo created = await createTodoRequest(todo);
    if (created != null) store.dispatch(createTodoAction(created));

    // if created != null returns a successful request
    return created != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      floatingActionButton: FormScreenActionButton(_formKey, createOrEditTodo,
          widget.isUpdatingTodo, () => Navigator.pop(context)),
      body: SingleChildScrollView(
        child: TodoForm(_formKey, titleController, descriptionController,
            isDoneController, setIsDone),
      ),
    );
  }
}