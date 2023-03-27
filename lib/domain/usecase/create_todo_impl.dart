import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/todos_impl.dart';
import '../model/todo.dart';
import '../repository/todos.dart';
import 'create_todo.dart';

part 'create_todo_impl.g.dart';

@riverpod
class CreateTodoUseCaseImpl extends _$CreateTodoUseCaseImpl implements CreateTodoUseCase {
  @override
  Future<Todo> build(
    String title,
    String? description,
    bool isCompleted,
    DateTime dueDate,
  ) {
    final TodosRepository repository = ref.read(todosRepositoryImplProvider.notifier);
    return repository.createTodo(
      title: title,
      description: description,
      isCompleted: isCompleted,
      dueDate: dueDate,
    );
  }
}
