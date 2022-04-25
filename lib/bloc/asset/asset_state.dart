part of 'asset_bloc.dart';

@immutable
abstract class AssetState extends Equatable{
  @override
  List<Object> get props => [];
}

class AssetInitial extends AssetState {}

class AssetsLoading extends AssetState {}

class AssetsEmpty extends AssetState {}

class AssetsLoaded extends AssetState{
  final List<Asset> assets;
  final double portfolioValue;
  AssetsLoaded({required this.assets, required this.portfolioValue});

  @override
  List<Object> get props => [assets, portfolioValue];

}

class AssetsError extends AssetState{

  final AssetError error;

  AssetsError({required this.error});

  @override
  List<Object> get props => [error];
}