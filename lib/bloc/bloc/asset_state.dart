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
  AssetsLoaded({required this.assets});

  @override
  List<Object> get props => [assets];

}

class AssetsError extends AssetState{

  String error;

  AssetsError({required this.error});

  @override
  List<Object> get props => [error];
}