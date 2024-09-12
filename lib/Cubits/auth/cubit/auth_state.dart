part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class SignUpState extends AuthState {}

final class SignUpLoadingState extends SignUpState {}

final class SignUpSuccessState extends SignUpState {}

final class SignUpFailedState extends SignUpState {}

final class LoginState extends AuthState {}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {}

final class LoginFailedState extends LoginState {}
