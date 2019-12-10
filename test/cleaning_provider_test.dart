import 'package:flutter_test/flutter_test.dart';

import '../lib/providers/cleaning_provider.dart';
import '../lib/models/cleaning.dart';
import '../lib/models/cleaning_task.dart';

// old cleaning item
final cleaningItem1 = Cleaning(
  id: 'cleaning_id_1',
  apartmentNumber: 'apartment_number_1',
  dateFrom: DateTime.now().subtract(
    Duration(days: 10),
  ),
  dateTo: DateTime.now().subtract(
    Duration(days: 5),
  ),
  authorId: 'author_id_1',
);

// current cleaning item
final cleaningItem2 = Cleaning(
  id: 'cleaning_id_2',
  apartmentNumber: 'apartment_number_2',
  dateFrom: DateTime.now().subtract(
    Duration(days: 5),
  ),
  dateTo: DateTime.now().add(
    Duration(days: 5),
  ),
  authorId: 'author_id_2',
);

// current cleaning item
final cleaningItem3 = Cleaning(
  id: 'cleaning_id_3',
  apartmentNumber: 'apartment_number_3',
  dateFrom: DateTime.now().add(
    Duration(days: 5),
  ),
  dateTo: DateTime.now().add(
    Duration(days: 10),
  ),
  authorId: 'author_id_3',
);

final cleaningTask1 = CleaningTask(
  id: 'cleaning_task_id_1',
  title: 'title_1',
  taskDone: false,
  description: 'description_1',
);

final cleaningTask2 = CleaningTask(
  id: 'cleaning_task_id_2',
  title: 'title_2',
  taskDone: false,
  description: 'description_2',
);

void main() {
  group('cleaning items testing:', () {
    test('should return cleaning item by id', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      expect(cleaningProvider.findById('cleaning_id_1'), cleaningItem1);
    });

    test('should return old cleaning item', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      cleaningProvider.cleaningItems.add(cleaningItem3);
      // 2 is the index for filtering for old cleaning items.
      expect(cleaningProvider.filteredItems('apartment', 2), [cleaningItem1]);
    });

    test('should return current cleaning item', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      cleaningProvider.cleaningItems.add(cleaningItem3);
      // 0 is the index for filtering for current cleaning items.
      expect(cleaningProvider.filteredItems('apartment', 0), [cleaningItem2]);
    });

    test('should return ahead cleaning item', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      cleaningProvider.cleaningItems.add(cleaningItem3);
      // 1 is the index for filtering cleaning items which are ahed.
      expect(cleaningProvider.filteredItems('apartment', 1), [cleaningItem3]);
    });

    test('should be users turn to clean', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      expect(cleaningProvider.isUsersTurnToClean('apartment_number_2'), true);
    });

    test('should not be users turn to clean', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      expect(cleaningProvider.isUsersTurnToClean('apartment_number_1'), false);
    });

    test('should return list of all cleaning items', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      expect(cleaningProvider.getAllCleaningItems(),
          [cleaningItem1, cleaningItem2]);
    });

    test('should return sorted cleaning items list', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningItems.add(cleaningItem3);
      cleaningProvider.cleaningItems.add(cleaningItem2);
      cleaningProvider.cleaningItems.add(cleaningItem1);
      cleaningProvider.sortCleaningItems();
      expect(cleaningProvider.cleaningItems,
          [cleaningItem1, cleaningItem2, cleaningItem3]);
    });
  });

  group('cleaning tasks testing', () {
    test('should return cleaning task by id', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningTasks.add(cleaningTask1);
      cleaningProvider.cleaningTasks.add(cleaningTask2);
      expect(cleaningProvider.findCleaningTaskById('cleaning_task_id_1'),
          cleaningTask1);
    });

    test('should return list of all cleaning tasks', () {
      final cleaningProvider = CleaningProvider();
      cleaningProvider.cleaningTasks.add(cleaningTask1);
      cleaningProvider.cleaningTasks.add(cleaningTask2);
      expect(
        cleaningProvider.getAllTasks(),
        [cleaningTask1, cleaningTask2],
      );
    });

    test('should return empty list', () {
      expect(CleaningProvider().cleaningTasks, []);
    });
  });
}
