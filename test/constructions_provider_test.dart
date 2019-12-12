import 'package:flutter_test/flutter_test.dart';

import '../lib/providers/constructions_provider.dart';
import '../lib/models/construction.dart';

// construction which is 'old'
final construction1 = Construction(
  id: 'construction_id_1',
  title: 'title_1',
  dateFrom: DateTime.now().subtract(
    Duration(days: 10),
  ),
  dateTo: DateTime.now().subtract(
    Duration(days: 5),
  ),
  description: 'description_1',
  authorId: 'author_id_1',
);

// construction which is 'current'
final construction2 = Construction(
  id: 'construction_id_2',
  title: 'title_2',
  dateFrom: DateTime.now().subtract(
    Duration(days: 5),
  ),
  dateTo: DateTime.now().add(
    Duration(days: 5),
  ),
  description: 'description_2',
  authorId: 'author_id_2',
);

// construction which is 'ahead'
final construction3 = Construction(
  id: 'construction_id_3',
  title: 'title_3',
  dateFrom: DateTime.now().add(
    Duration(days: 5),
  ),
  dateTo: DateTime.now().add(
    Duration(days: 10),
  ),
  description: 'description_3',
  authorId: 'author_id_3',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('constructions testing:', () {
    test('should return construction by id', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.constructions.add(construction2);
      expect(
          constructionsProvider.findById('construction_id_2'), construction2);
    });

    test('should return old construction', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.constructions.add(construction2);
      constructionsProvider.constructions.add(construction3);
      // 2 is the index for filtering for old constructions
      expect(constructionsProvider.filteredItems('title', 2), [construction1]);
    });

    test('should return current construction', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.constructions.add(construction2);
      constructionsProvider.constructions.add(construction3);
      // 0 is the index for filtering for current constructions
      expect(constructionsProvider.filteredItems('title', 0), [construction2]);
    });

    test('should return ahead construction', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.constructions.add(construction2);
      constructionsProvider.constructions.add(construction3);
      // 1 is the index for filtering for ahead constructions
      expect(constructionsProvider.filteredItems('title', 1), [construction3]);
    });

    test('should return sorted list of constructions by date', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction3);
      constructionsProvider.constructions.add(construction2);
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.sortConstructions();
      expect(constructionsProvider.constructions, [
        construction1,
        construction2,
        construction3,
      ]);
    });

    test('should return all constructions', () {
      final constructionsProvider = ConstructionsProvider();
      constructionsProvider.constructions.add(construction1);
      constructionsProvider.constructions.add(construction2);
      constructionsProvider.constructions.add(construction3);
      expect(constructionsProvider.getAllConstructions(), [
        construction1,
        construction2,
        construction3,
      ]);
    });

    test('should return empty list', () {
      expect(ConstructionsProvider().constructions, []);
    });
  });
}
