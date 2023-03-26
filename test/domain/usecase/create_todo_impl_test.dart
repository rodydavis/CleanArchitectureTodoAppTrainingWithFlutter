import 'dart:async';

import 'package:clean_architecture_todo_app/data/repository/todos_impl.dart';
import 'package:clean_architecture_todo_app/domain/model/todo.dart';
import 'package:clean_architecture_todo_app/domain/usecase/create_todo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

class MockTodosRepositoryImpl extends AutoDisposeStreamNotifier<List<Todo>> with Mock implements TodosRepositoryImpl {}

void main() {
  late ProviderContainer container;
  late TodosRepositoryImpl todosRepository;
  setUp(() {
    todosRepository = MockTodosRepositoryImpl();
    container = ProviderContainer(
      overrides: [
        todosRepositoryImplProvider.overrideWith(() => todosRepository),
      ],
    );
  });
  tearDown(() => container.dispose());
  test('CreateTodoUseCaseImpl should start loading and then create the todo and emit it', () async {
    final mockTodo = Todo(
      id: 1,
      title: 'mock title',
      description: 'mock desc',
      isCompleted: true,
      dueDate: DateTime(1),
    );
    final completer = Completer<Todo>();
    when(todosRepository.build).thenAnswer((_) => const Stream.empty());
    when(() => todosRepository.createTodo(
          title: any(named: 'title'),
          description: any(named: 'description'),
          isCompleted: any(named: 'isCompleted'),
          dueDate: any(named: 'dueDate'),
        )).thenAnswer(
      (_) => completer.future,
    );
    final testUseCaseProvider = createTodoUseCaseImplProvider(
      'mock title',
      'mock desc',
      true,
      DateTime(1),
    );
    final useCase = container.read(testUseCaseProvider);
    container.listen(testUseCaseProvider, (_, __) {}); //avoids the automatic disposal of the provider
    final captured = verify(() => todosRepository.createTodo(
          title: captureAny(named: 'title'),
          description: captureAny(named: 'description'),
          isCompleted: captureAny(named: 'isCompleted'),
          dueDate: captureAny(named: 'dueDate'),
        )).captured;
    expect(captured, ['mock title', true, DateTime(1), 'mock desc']);
    expect(useCase.isLoading, isTrue);

    completer.complete(mockTodo);

    await container.pump();

    final loadedUseCase = container.read(testUseCaseProvider);
    expect(loadedUseCase.isLoading, isFalse);
    expect(loadedUseCase.value, mockTodo);
  });
}
