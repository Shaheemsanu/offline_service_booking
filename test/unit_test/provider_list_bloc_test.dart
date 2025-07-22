import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/application/provider_list/provider_list_bloc.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';
import 'package:offline_service_booking/src/domain/provider_service/provider_service.dart';

class MockServiceProviderRepo extends Mock implements ServiceProviderRepo {}

void main() {
  late ProviderListBloc bloc;
  late MockServiceProviderRepo mockRepo;

  final testProvider = ProviderModel(
    id: '1',
    name: 'Test Provider',
    category: 'Cleaning',
    location: 'City Center',
    contact: '1234567890',
  );

  setUp(() {
    mockRepo = MockServiceProviderRepo();
    bloc = ProviderListBloc(mockRepo);
  });

  group('FetchProvidersEvent', () {
    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusSuccess] with provider data',
      build: () {
        when(() => mockRepo.getProviders())
            .thenAnswer((_) async => [testProvider]);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchProvidersEvent()),
      expect: () => [
        ProviderListState(getProvidersStatus: StatusLoading()),
        ProviderListState(
          getProvidersStatus: StatusSuccess(),
          providers: [testProvider],
        ),
      ],
    );

    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusFailure] when repo returns empty',
      build: () {
        when(() => mockRepo.getProviders())
            .thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchProvidersEvent()),
      expect: () => [
        ProviderListState(getProvidersStatus: StatusLoading()),
        ProviderListState(
          getProvidersStatus: StatusFailure("Some error occurred"),
        ),
      ],
    );
  });

  group('AddProviderEvent', () {
    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusSuccess] when adding is successful',
      build: () {
        when(() => mockRepo.addProvider(testProvider))
            .thenAnswer((_) async => 1);
        return bloc;
      },
      act: (bloc) => bloc.add(AddProviderEvent(provider: testProvider)),
      expect: () => [
        ProviderListState(addProviderStatus: StatusLoading()),
        ProviderListState(addProviderStatus: StatusSuccess()),
      ],
    );

    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusFailure] when adding fails',
      build: () {
        when(() => mockRepo.addProvider(testProvider))
            .thenAnswer((_) async => 0);
        return bloc;
      },
      act: (bloc) => bloc.add(AddProviderEvent(provider: testProvider)),
      expect: () => [
        ProviderListState(addProviderStatus: StatusLoading()),
        ProviderListState(
            addProviderStatus: StatusFailure("Some error occurred")),
      ],
    );
  });

  group('DeleteProviderEvent', () {
    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusSuccess] when deletion is successful',
      build: () {
        when(() => mockRepo.deleteProvider('1')).thenAnswer((_) async => 1);
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteProviderEvent(providerId: '1')),
      expect: () => [
        ProviderListState(deleteProviderStatus: StatusLoading()),
        ProviderListState(deleteProviderStatus: StatusSuccess()),
      ],
    );

    blocTest<ProviderListBloc, ProviderListState>(
      'emits [StatusLoading, StatusFailure] when deletion fails',
      build: () {
        when(() => mockRepo.deleteProvider('1')).thenAnswer((_) async => 0);
        return bloc;
      },
      act: (bloc) => bloc.add(DeleteProviderEvent(providerId: '1')),
      expect: () => [
        ProviderListState(deleteProviderStatus: StatusLoading()),
        ProviderListState(
            deleteProviderStatus: StatusFailure("Some error occurred")),
      ],
    );
  });
}
