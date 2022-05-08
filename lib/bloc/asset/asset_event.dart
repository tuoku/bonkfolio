part of 'asset_bloc.dart';

@immutable
abstract class AssetEvent extends Equatable {
  const AssetEvent();
}

class AssetsRequested extends AssetEvent {
  const AssetsRequested({required this.wallets});

  final List<Wallet> wallets;

  @override
  List<Object> get props => [wallets];

  @override
  String toString() => 'AssetsRequested { wallets: $wallets }';
}

class AssetRefreshRequested extends AssetEvent {
  const AssetRefreshRequested();
  @override
  List<Object> get props => [];
  @override
  String toString() => 'AssetRefreshRequested';
}
