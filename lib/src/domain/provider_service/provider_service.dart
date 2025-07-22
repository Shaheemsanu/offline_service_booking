// service_provider_repository.dart
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';

abstract class ServiceProviderRepo {
  Future<List<ProviderModel>> getProviders();
  Future<int> addProvider(ProviderModel provider);
  Future<int> deleteProvider(String id);
}
