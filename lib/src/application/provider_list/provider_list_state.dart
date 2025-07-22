part of 'provider_list_bloc.dart';

class ProviderListState extends Equatable {
  const ProviderListState({
    this.providers = const [],
    this.getProvidersStatus = const StatusInitial(),
    this.addProviderStatus = const StatusInitial(),
    this.deleteProviderStatus = const StatusInitial(),
  });
  final Status getProvidersStatus;
  final Status addProviderStatus;
  final Status deleteProviderStatus;
  final List<ProviderModel> providers;

  @override
  List<Object> get props => [
    providers,
    getProvidersStatus,
    addProviderStatus,
    deleteProviderStatus,
  ];

  ProviderListState copyWith({
    List<ProviderModel>? providers,
    Status? getProvidersStatus,
    Status? addProviderStatus,
    Status? deleteProviderStatus,
  }) {
    return ProviderListState(
      providers: providers ?? this.providers,
      getProvidersStatus: getProvidersStatus ?? this.getProvidersStatus,
      addProviderStatus: addProviderStatus ?? this.addProviderStatus,
      deleteProviderStatus: deleteProviderStatus ?? this.deleteProviderStatus,
    );
  }
}
