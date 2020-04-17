import 'package:todos_mobile/actions/types.dart';
import 'package:todos_mobile/helpers/TodosProvider.dart';
import 'package:todos_mobile/models/Todo.dart';

import '../store.dart';

AppState todosReducer(AppState state, action) {
  if (action is GetTodosAction) return state.copyWith(todos: action.todos);

  if (action is DeleteTodoAction)
    return state.copyWith(
        todos: state.todos.where((todo) => todo.id != action.id).toList());

  if (action is CreateTodoAction)
    return state.copyWith(todos: [action.todo, ...state.todos]);

  if (action is UpdateTodoAction)
    return state.copyWith(
        todos: state.todos
            .map((todo) => todo.id == action.todo.id ? action.todo : todo)
            .toList());

  if (action is PatchTodoAction)
    return state.copyWith(
        todos: state.todos.map<Todo>((todo) {
      if (todo.id != action.id) return todo;

      todo.title = action.todo[columnTitle] ?? todo.title;
      todo.description = action.todo[columnDescription] ?? todo.description;
      todo.isDone = action.todo[columnIsDone] ?? todo.isDone;

      return todo;
    }).toList());
  return state;
}