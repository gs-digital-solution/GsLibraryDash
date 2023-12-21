
import 'package:equatable/equatable.dart';
import 'package:gslibrarydashboard/features/auth/auth/model/adminUser.dart';

class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthenticationState {
  final AdminUser? user;

  Authenticated({
    this.user,
  });
  @override
  List<Object?> get props => [user];
}

class UnAuthenticated extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure({required this.message});

  @override
  List<Object> get props => [message];
}
