part of 'store_device_token_bloc.dart';

class StoreDeviceTokenState extends Equatable {
  const StoreDeviceTokenState();

  @override
  List<Object> get props => [];
}

class StoreDeviceTokenInitial extends StoreDeviceTokenState {}

class StoreDeviceTokenLoading extends StoreDeviceTokenState {}

class StoreDeviceTokenLoaded extends StoreDeviceTokenState {}

class StoreDeviceTokenFailed extends StoreDeviceTokenState {
  const StoreDeviceTokenFailed({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}
