import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_service_booking/src/application/core/status.dart';
import 'package:offline_service_booking/src/application/provider_list/provider_list_bloc.dart';
import 'package:offline_service_booking/src/presentation/view/booking_list_screen/booking_list_screen.dart';
import 'package:offline_service_booking/src/presentation/view/widget/bottom_sheet.dart';
import 'package:offline_service_booking/src/presentation/view/widget/delete_button.dart';

class ProviderListScreen extends StatefulWidget {
  const ProviderListScreen({super.key});

  @override
  State<ProviderListScreen> createState() => _ProviderListScreenState();
}

class _ProviderListScreenState extends State<ProviderListScreen> {
  @override
  void initState() {
    context.read<ProviderListBloc>().add(FetchProvidersEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Service Providers')),
      body: BlocBuilder<ProviderListBloc, ProviderListState>(
        buildWhen: (previous, current) =>
            previous.getProvidersStatus != current.getProvidersStatus ||
            previous.providers != current.providers,
        builder: (context, state) {
          print("state.providers.isEmpty: ${state.providers.isEmpty}");
          return state.getProvidersStatus is StatusLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: state.providers.length,
                  itemBuilder: (context, index) {
                    final provider = state.providers[index];
                    return state.providers.isEmpty
                        ? Text(
                            "No Providers Found",
                            style: TextStyle(color: Colors.amber),
                          )
                        : ListTile(
                            title: Text(provider.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category: ${provider.category}'),
                                Text('Location: ${provider.location}'),
                                Text('Contact: ${provider.contact}'),
                              ],
                            ),
                            trailing:
                                BlocListener<
                                  ProviderListBloc,
                                  ProviderListState
                                >(
                                  listenWhen: (previous, current) =>
                                      previous.deleteProviderStatus !=
                                      current.deleteProviderStatus,
                                  listener: (context, state) {
                                    if (state.deleteProviderStatus ==
                                        StatusSuccess()) {
                                      context.read<ProviderListBloc>().add(
                                        FetchProvidersEvent(),
                                      );
                                    }
                                  },
                                  child: DeleteButton(
                                    onPressed: () {
                                      context.read<ProviderListBloc>().add(
                                        DeleteProviderEvent(
                                          providerId: provider.id,
                                        ),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      BookingListScreen(provider: provider),
                                ),
                              );
                            },
                          );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.read<ProviderListBloc>().add(
          //   AddProviderEvent(
          //     provider: ProviderModel(
          //       category: "demo",
          //       contact: '34334',
          //       id: "5",
          //       location: "demo",
          //       name: "Demo Provider",
          //     ),
          //   ),
          // );

          _showAddProviderBottomSheet();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddProviderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => BlocListener<ProviderListBloc, ProviderListState>(
        listenWhen: (previous, current) =>
            previous.addProviderStatus != current.addProviderStatus,
        listener: (context, state) {
          print("state.status: ${state.addProviderStatus}");
          if (state.addProviderStatus == StatusSuccess()) {
            context.read<ProviderListBloc>().add(FetchProvidersEvent());
          }
        },
        child: AddProviderBottomSheet(
          pId: 1, // providers.length + 1,
          onProviderAdded: (newProvider) {
            print("newProvider: $newProvider");
            context.read<ProviderListBloc>().add(
              AddProviderEvent(provider: newProvider),
            );
            // providers.add(newProvider);
          },
        ),
      ),
    );
  }
}
