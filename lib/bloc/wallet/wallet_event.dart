part of 'wallet_bloc.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object> get props => [];
}

class WalletsRequested extends WalletEvent {
  const WalletsRequested();

  @override
  String toString() => 'WalletsRequested';
}
