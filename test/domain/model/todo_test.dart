import 'package:clean_architecture_todo_app/domain/model/todo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Todo model', () {
    late Todo todo;
    setUp(() {
      todo = Todo(
        id: 1,
        title: 'test title',
        description: 'test desc',
        isCompleted: false,
        dueDate: DateTime(1),
      );
    });
    test('when a todo is instantiated it should save its properties', () {
      expect(todo.id, 1);
      expect(todo.title, 'test title');
      expect(todo.description, 'test desc');
      expect(todo.isCompleted, false);
      expect(todo.dueDate, DateTime(1));
    });
    test('todos should be comparable by value', () {
      final todo2 = Todo(
        id: 1,
        title: 'test title',
        description: 'test desc',
        isCompleted: false,
        dueDate: DateTime(1),
      );
      expect(todo == todo2, isTrue);
    });
    test('when a todo is copied with different values the result should have its fields updated', () {
      final todo1 = todo.copyWith(title: 'new title', isCompleted: true, dueDate: DateTime(2));
      expect(todo1.id, 1);
      expect(todo1.title, 'new title');
      expect(todo1.description, 'test desc');
      expect(todo1.isCompleted, true);
      expect(todo1.dueDate, DateTime(2));
    });
  });
  group('TodosExtension', () {
    final todos = List<Todo>.unmodifiable([
      Todo(
        id: 1,
        title: 'test title',
        description: 'test desc',
        isCompleted: false,
        dueDate: DateTime(1),
      ),
      Todo(
        id: 2,
        title: 'test title2',
        description: 'test desc2',
        isCompleted: true,
        dueDate: DateTime(2),
      ),
    ]);
    test('filterByCompleted should output only the completed todos', () {
      expect(todos.filterByCompleted(), [
        Todo(
          id: 2,
          title: 'test title2',
          description: 'test desc2',
          isCompleted: true,
          dueDate: DateTime(2),
        )
      ]);
    });
    test('filterByIncomplete should output only the incompleted todos', () {
      expect(todos.filterByIncomplete(), [
        Todo(
          id: 1,
          title: 'test title',
          description: 'test desc',
          isCompleted: false,
          dueDate: DateTime(1),
        )
      ]);
    });
  });
}
