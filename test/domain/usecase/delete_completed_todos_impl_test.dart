import 'dart:async';

import 'package:clean_architecture_todo_app/data/repository/todos_impl.dart';
import 'package:clean_architecture_todo_app/domain/usecase/delete_completed_todos_impl.dart';
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
  test('DeleteCompletedTodosUseCaseImpl should start loading and then delete the todo', () async {
    final completer = Completer<void>();
    when(todosRepository.deleteAllCompleted).thenAnswer((_) => completer.future);

    final useCase = container.readAndKeepAlive(deleteCompletedTodosUseCaseImplProvider);

    verify(todosRepository.deleteAllCompleted).called(1);
    expect(useCase.isLoading, isTrue);

    //test the value
    completer.complete();

    await container.pump();

    final loadedUseCase = container.read(deleteCompletedTodosUseCaseImplProvider);
    expect(loadedUseCase.isLoading, isFalse);
    expect(loadedUseCase.hasValue, isTrue);
  });
  test('DeleteCompletedTodosUseCaseImpl when the repository throws should emit the error', () async {
    final error = Exception('mocked exception');
    when(todosRepository.deleteAllCompleted).thenAnswer(
      (_) async => throw error,
    );

    container.readAndKeepAlive(deleteCompletedTodosUseCaseImplProvider);
    await container.pump();
    final useCase = container.read(deleteCompletedTodosUseCaseImplProvider);
    expect(useCase.isLoading, isFalse);
    expect(useCase.error, error);
  });
}
