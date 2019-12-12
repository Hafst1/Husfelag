import 'package:flutter_test/flutter_test.dart';

import '../lib/providers/current_user_provider.dart';
import '../lib/models/user.dart';

final user1 = UserData(
  id: 'user_id_1',
  email: 'email_1',
  name: 'name_1',
  apartmentId: 'apartment_id_1',
  residentAssociationId: 'res_id_1',
  isAdmin: true,
  userToken: 'user_token_1',
);

final user2 = UserData(
  id: 'user_id_2',
  email: 'email_2',
  name: 'name_2',
  apartmentId: '',
  residentAssociationId: '',
  isAdmin: false,
  userToken: '',
);

void main() {
  group('current user provider testing:', () {
    test('should get current user', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user1;
      final gotUser = currentUserProvider.getUser();
      expect(gotUser.id, user1.id);
      expect(gotUser.email, user1.email);
      expect(gotUser.name, user1.name);
      expect(gotUser.residentAssociationId, user1.residentAssociationId);
      expect(gotUser.apartmentId, user1.apartmentId);
      expect(gotUser.isAdmin, user1.isAdmin);
      expect(gotUser.userToken, user1.userToken);
    });

    test('current user should be in a resident association', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user1;
      expect(currentUserProvider.containsRAN(), true);
    });

    test('should not be in a resident association', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user2;
      expect(currentUserProvider.containsRAN(), false);
    });

    test('should be admin', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user1;
      expect(currentUserProvider.isAdmin(), true);
    });

    test('should not be admin', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user2;
      expect(currentUserProvider.isAdmin(), false);
    });

    test('getters should return correct value', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user1;
      expect(currentUserProvider.getId(), user1.id);
      expect(currentUserProvider.getEmail(), user1.email);
      expect(currentUserProvider.getName(), user1.name);
      expect(currentUserProvider.getResidentAssociationId(),
          user1.residentAssociationId);
      expect(currentUserProvider.getApartmentId(), user1.apartmentId);
    });

    test('setters should set correct value for current user', () {
      final currentUserProvider = CurrentUserProvider();
      currentUserProvider.currentUser = user2;
      currentUserProvider.setResidentAssociationId('res_id_2');
      currentUserProvider.setApartmentId('apartment_id_2');
      expect(currentUserProvider.currentUser.apartmentId, 'apartment_id_2');
      expect(currentUserProvider.currentUser.residentAssociationId, 'res_id_2');
    });
  });
}
