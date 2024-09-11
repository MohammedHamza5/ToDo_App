part of 'auth_cubit.dart';

sealed class AuthState {}

final class AuthInitial extends AuthState {}
final class AppPasswordVisibilityChanged extends AuthState {}

final class LoginLoading extends AuthState {}
final class LoginSuccess extends AuthState {}
final class LoginFailed extends AuthState {
  final errorMassage;

  LoginFailed({required this.errorMassage});

}

final class RegisterLoading extends AuthState{}

final class RegisterSuccess extends AuthState{}

final class RegisterFailed extends AuthState{
  final String? errorMassage;

  RegisterFailed(  {this.errorMassage});
}
