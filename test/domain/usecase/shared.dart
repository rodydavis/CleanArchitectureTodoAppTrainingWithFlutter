import 'package:clean_architecture_todo_app/data/repository/todos_impl.dart';
import 'package:clean_architecture_todo_app/domain/model/todo.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tuple/tuple.dart';

class MockTodosRepositoryImpl extends AutoDisposeStreamNotifier<List<Todo>> with Mock implements TodosRepositoryImpl {
  @override
  Stream<List<Todo>> build() => const Stream.empty();
}

Tuple2<ProviderContainer, TodosRepositoryImpl> buildMockedTodosRepository() {
  final todosRepository = MockTodosRepositoryImpl();
  final container = ProviderContainer(
    overrides: [
      todosRepositoryImplProvider.overrideWith(() => todosRepository),
    ],
  );

  return Tuple2(container, todosRepository);
}
