import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/domain/core/model/provider_model.dart';
import 'package:offline_service_booking/src/domain/provider_service/provider_service.dart';

part 'provider_list_event.dart';
part 'provider_list_state.dart';

@injectable
class ProviderListBloc extends Bloc<ProviderListEvent, ProviderListState> {
  ProviderListBloc(this._serviceProviderRepo) : super(ProviderListState()) {
    on<FetchProvidersEvent>(_fetchProviders);
    on<AddProviderEvent>(_addProvider);
    on<DeleteProviderEvent>(_deleteProvider);
  }

  final ServiceProviderRepo _serviceProviderRepo;

  Future<void> _fetchProviders(
    FetchProvidersEvent event,
    Emitter<ProviderListState> emit,
  ) async {
    try {
      emit(state.copyWith(getProvidersStatus: StatusLoading()));

      List<ProviderModel> getProviderData = await _serviceProviderRepo
          .getProviders();
      print("getProviderData: $getProviderData");
      if (getProviderData.isNotEmpty) {
        emit(
          state.copyWith(
            providers: getProviderData,
            getProvidersStatus: StatusSuccess(),
          ),
        );
      } else {
        emit(
          state.copyWith(
            getProvidersStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      print("=================Error fetching providers: $e");
      emit(state.copyWith(getProvidersStatus: StatusFailure(e.toString())));
    }
  }

  Future<void> _addProvider(
    AddProviderEvent event,
    Emitter<ProviderListState> emit,
  ) async {
    try {
      emit(state.copyWith(addProviderStatus: StatusLoading()));

      int providerId = await _serviceProviderRepo.addProvider(event.provider);
      print("providerId: $providerId");
      if (providerId > 0) {
        emit(state.copyWith(addProviderStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            addProviderStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(addProviderStatus: StatusFailure(e.toString())));
    }
  }

  Future<void> _deleteProvider(
    DeleteProviderEvent event,
    Emitter<ProviderListState> emit,
  ) async {
    try {
      emit(state.copyWith(deleteProviderStatus: StatusLoading()));

      int deletedPId = await _serviceProviderRepo.deleteProvider(
        event.providerId,
      );
      print("deletedPId: $deletedPId");
      if (deletedPId > 0) {
        emit(state.copyWith(deleteProviderStatus: StatusSuccess()));
      } else {
        emit(
          state.copyWith(
            deleteProviderStatus: StatusFailure("Some error occurred"),
          ),
        );
      }
    } on Exception catch (e) {
      emit(state.copyWith(deleteProviderStatus: StatusFailure(e.toString())));
    }
  }
}
