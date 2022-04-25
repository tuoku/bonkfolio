part of 'wallet_bloc.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object> get props => [];
}

class WalletInitial extends WalletState {}

class WalletsLoading extends WalletState {}

class WalletsEmpty extends WalletState {}

class WalletsLoaded extends WalletState {
  final List<Wallet> wallets;
  const WalletsLoaded({required this.wallets});
  @override
  List<Object> get props => [wallets];
}

class WalletsError extends WalletState {
  final WalletError error;
  const WalletsError({required this.error});
  @override
  List<Object> get props => [error];
}
