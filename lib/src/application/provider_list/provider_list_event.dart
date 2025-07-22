part of 'provider_list_bloc.dart';

abstract class ProviderListEvent extends Equatable {
  const ProviderListEvent();

  @override
  List<Object> get props => [];
}

class FetchProvidersEvent extends ProviderListEvent {
  const FetchProvidersEvent();

  @override
  List<Object> get props => [];
}

class AddProviderEvent extends ProviderListEvent {
  final ProviderModel provider;

  const AddProviderEvent({required this.provider});

  @override
  List<Object> get props => [provider];
}

class DeleteProviderEvent extends ProviderListEvent {
  final String providerId;

  const DeleteProviderEvent({required this.providerId});

  @override
  List<Object> get props => [providerId];
}
