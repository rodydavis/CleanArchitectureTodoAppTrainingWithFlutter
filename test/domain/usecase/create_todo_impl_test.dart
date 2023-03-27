import 'dart:async';

import 'package:clean_architecture_todo_app/data/repository/todos_impl.dart';
import 'package:clean_architecture_todo_app/domain/model/todo.dart';
import 'package:clean_architecture_todo_app/domain/usecase/create_todo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';

import '../../helpers/riverpod.dart';
import 'shared.dart';

void main() {
  late ProviderContainer container;
  late TodosRepositoryImpl todosRepository;
  setUp(() {
    final deps = buildMockedTodosRepository();
    container = deps.item1;
    todosRepository = deps.item2;
  });
  tearDown(() => container.dispose());
  test('CreateTodoUseCaseImpl should start loading and then create the todo and emit it', () async {
    final completer = Completer<Todo>();
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
    final useCase = container.readAndKeepAlive(testUseCaseProvider);
    final captured = verify(() => todosRepository.createTodo(
          title: captureAny(named: 'title'),
          description: captureAny(named: 'description'),
          isCompleted: captureAny(named: 'isCompleted'),
          dueDate: captureAny(named: 'dueDate'),
        )).captured;
    expect(captured, ['mock title', true, DateTime(1), 'mock desc']);
    expect(useCase.isLoading, isTrue);

    //test the value
    final mockTodo = Todo(
      id: 1,
      title: 'mock title',
      description: 'mock desc',
      isCompleted: true,
      dueDate: DateTime(1),
    );
    completer.complete(mockTodo);

    await container.pump();

    final loadedUseCase = container.read(testUseCaseProvider);
    expect(loadedUseCase.isLoading, isFalse);
    expect(loadedUseCase.value, mockTodo);
  });
  test('CreateTodoUseCaseImpl when the repository throws should emit the error', () async {
    final error = Exception('mocked exception');

    when(() => todosRepository.createTodo(
          title: any(named: 'title'),
          description: any(named: 'description'),
          isCompleted: any(named: 'isCompleted'),
          dueDate: any(named: 'dueDate'),
        )).thenAnswer(
      (_) async => throw error,
    );
    final testUseCaseProvider = createTodoUseCaseImplProvider(
      'mock title',
      'mock desc',
      true,
      DateTime(1),
    );

    container.readAndKeepAlive(testUseCaseProvider);
    await container.pump();
    final useCase = container.read(testUseCaseProvider);
    expect(useCase.isLoading, isFalse);
    expect(useCase.hasError, isTrue);
    expect(useCase.error, error);
  });
}
