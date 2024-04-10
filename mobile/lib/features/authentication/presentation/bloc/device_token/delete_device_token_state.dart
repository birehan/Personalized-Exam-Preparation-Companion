part of 'delete_device_token_bloc.dart';

class DeleteDeviceTokenState extends Equatable {
  const DeleteDeviceTokenState();

  @override
  List<Object> get props => [];
}

class DeleteDeviceTokenInitial extends DeleteDeviceTokenState {}

class DeleteDeviceTokenLoading extends DeleteDeviceTokenState {}

class DeleteDeviceTokenLoaded extends DeleteDeviceTokenState {}

class DeleteDeviceTokenFailed extends DeleteDeviceTokenState {
  const DeleteDeviceTokenFailed({
    required this.message,
  });

  final String message;

  @override
  List<Object> get props => [message];
}
