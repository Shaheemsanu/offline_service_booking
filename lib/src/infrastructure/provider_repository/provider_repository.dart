// service_provider_repository.dart
import 'package:injectable/injectable.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';
import 'package:offline_service_booking/src/domain/provider_service/provider_service.dart';
import 'package:offline_service_booking/src/infrastructure/core/database_service.dart';

@LazySingleton(as: ServiceProviderRepo)
class ServiceProviderRepository extends ServiceProviderRepo {
  ServiceProviderRepository(this._db);
  final DatabaseServices _db;

  @override
  Future<List<ProviderModel>> getProviders() async {
    return await _db.getData(tableName: 'providers').then((maps) {
      List<ProviderModel> providerList = [];
      for (var map in maps) {
        providerList.add(
          ProviderModel.fromMap(
            map.map((key, value) => MapEntry(key, value.toString())),
          ),
        );
      }
      return providerList;
    });
  }

  @override
  Future<int> addProvider(ProviderModel provider) async {
    // providers.add(provider);
    // return 1;
    return _db.insertData(
      tableName: 'providers',
      data: provider.toMapWithoutId(),
    );
  }

  @override
  Future<int> deleteProvider(String id) async {
    // providers.removeWhere((p) => p.id == id);
    // print("Deleted booking: $id");
    // return 1;
    return _db.deleteData(
      tableName: 'providers',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
