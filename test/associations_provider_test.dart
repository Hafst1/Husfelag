import 'package:flutter_test/flutter_test.dart';
import '../lib/providers/association_provider.dart';
import '../lib/models/resident_association.dart';
import '../lib/models/apartment.dart';
import '../lib/models/user.dart';

final user1 = UserData(
  id: 'user_id_1',
  email: 'baldvin@simnet.is',
  name: 'Baldvin Sindri Sturluson',
  apartmentId: 'apartment_id_2',
  residentAssociationId: 'res_id_2',
  isAdmin: false,
);

final user2 = UserData(
  id: 'user_id_2',
  email: 'tomas@simnet.is',
  name: 'Tómas Guðlaugur Hauksson',
  apartmentId: 'apartment_id_2',
  residentAssociationId: 'res_id_2',
  isAdmin: true,
);

final user3 = UserData(
  id: 'user_id_3',
  email: 'frikki@simnet.is',
  name: 'Friðrik Atli Jónsson',
  apartmentId: 'apartment_id_1',
  residentAssociationId: 'res_id_1',
  isAdmin: true,
);

final residentAssociation1 = ResidentAssociation(
  id: 'resident_association_id_1',
  accessCode: 'access_code_1',
  address: 'address_1',
  description: 'description_1',
);

final residentAssociation2 = ResidentAssociation(
  id: 'resident_association_id_2',
  accessCode: 'access_code_2',
  address: 'address_2',
  description: 'description_2',
);

final apartment1 = Apartment(
  id: 'apartment_id_1',
  apartmentNumber: 'apartment_number_1',
  accessCode: 'access_code_1',
  residents: ['resident_1'],
);

final apartment2 = Apartment(
  id: 'apartment_id_2',
  apartmentNumber: 'apartment_number_2',
  accessCode: 'access_code_2',
  residents: ['resident_2'],
);

void main() {
  group('resident testing:', () {
    test('should return empty list of residents', () {
      expect(AssociationsProvider().getResidentsOfAssociation(), []);
    });

    test('should return list of residents of length 2', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residents.add(user1);
      associationsProvider.residents.add(user2);
      expect(associationsProvider.getResidentsOfAssociation().length, 2);
    });

    test('should return user with matching id', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residents.add(user1);
      expect(associationsProvider.getResident('user_id_1'), user1);
    });

    test('should return empty user object', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residents.add(user2);
      expect(associationsProvider.getResident('randomId').id, '');
    });

    test('should evaluate "more than one admin" to true', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residents.add(user1);
      associationsProvider.residents.add(user2);
      associationsProvider.residents.add(user3);
      expect(associationsProvider.moreThanOneAdmin(), true);
    });

    test('should evaluate "more than one admin" to false', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residents.add(user1);
      associationsProvider.residents.add(user3);
      expect(associationsProvider.moreThanOneAdmin(), false);
    });
  });

  group('association testing:', () {
    test('should return empty list of associations', () {
      expect(AssociationsProvider().residentAssociations, []);
    });

    test('should return association of user with matching id', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residentAssociations.add(residentAssociation1);
      expect(
        associationsProvider.getAssociationOfUser('resident_association_id_1'),
        residentAssociation1,
      );
    });

    test('should return empty association', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residentAssociations.add(residentAssociation1);
      expect(
          associationsProvider
              .getAssociationOfUser('resident_association_id_4')
              .id,
          '');
    });

    test('association address should be available', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residentAssociations.add(residentAssociation1);
      expect(associationsProvider.associationAddressIsAvailable('address_4'),
          true);
    });

    test('association address should be unavailable', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residentAssociations.add(residentAssociation1);
      expect(associationsProvider.associationAddressIsAvailable('address_1'),
          false);
    });

    test('should return 2 items matching search query', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.residentAssociations.add(residentAssociation1);
      associationsProvider.residentAssociations.add(residentAssociation2);
      expect(associationsProvider.filteredItems('2'), [residentAssociation2]);
    });
  });

  group('apartment testing:', () {
    test('should return list of apartments', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      expect(associationsProvider.getApartments(), [apartment1]);
    });
    test('should return an apartment with matching id', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      associationsProvider.apartments.add(apartment2);
      expect(
          associationsProvider.getApartmentById('apartment_id_2'), apartment2);
    });

    test('should return apartment with matching apartment number', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      associationsProvider.apartments.add(apartment2);
      expect(associationsProvider.getApartmentByNumber('apartment_number_1'),
          apartment1);
    });

    test('should get apartment number of apartment with matching id', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      associationsProvider.apartments.add(apartment2);
      expect(associationsProvider.getApartmentNumber('apartment_id_2'),
          apartment2.apartmentNumber);
    });

    test('apartment number should be available', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      expect(associationsProvider.apartmentIsAvailable('apartment_number_2'),
          true);
    });

    test('apartment number should be unavailable', () {
      final associationsProvider = AssociationsProvider();
      associationsProvider.apartments.add(apartment1);
      expect(associationsProvider.apartmentIsAvailable('apartment_number_1'),
          false);
    });
  });
}
