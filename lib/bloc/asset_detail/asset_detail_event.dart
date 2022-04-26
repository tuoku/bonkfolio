part of 'asset_detail_bloc.dart';

abstract class AssetDetailEvent extends Equatable {
  const AssetDetailEvent();

  @override
  List<Object> get props => [];
}

class AssetSelected extends AssetDetailEvent {
  AssetSelected({required this.asset});
  final Asset asset;
}

class AssetUnselected extends AssetDetailEvent {}
