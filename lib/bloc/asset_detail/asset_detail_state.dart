part of 'asset_detail_bloc.dart';

abstract class AssetDetailState extends Equatable {
  const AssetDetailState();

  @override
  List<Object> get props => [];
}

class AssetdetailInitial extends AssetDetailState {}

class AssetNotSelected extends AssetDetailState {}

class AssetActive extends AssetDetailState {
  const AssetActive({required this.asset});
  final Asset asset;

  @override
  List<Object> get props => [asset];
}
