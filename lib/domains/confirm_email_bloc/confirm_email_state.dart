part of 'confirm_email_bloc.dart';

abstract class ConfirmEmailState extends Equatable {
  const ConfirmEmailState();
  
  @override
  List<Object> get props => [];
}

class EmailNotConfirmed extends ConfirmEmailState {}

class EmailConfirmed extends ConfirmEmailState {}
