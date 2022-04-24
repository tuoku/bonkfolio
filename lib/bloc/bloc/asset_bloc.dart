import 'package:bloc/bloc.dart';
import 'package:bonkfolio/repositories/asset_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/asset.dart';
import '../../models/database.dart';

part 'asset_event.dart';
part 'asset_state.dart';

class AssetBloc extends Bloc<AssetEvent, AssetState> {
  AssetBloc({required this.assetRepository}) : super(AssetInitial()) {
    on<AssetsRequested>(_onAssetsRequested);
  }

  final AssetRepository assetRepository;

  void _onAssetsRequested(
      AssetsRequested event, Emitter<AssetState> emit) async {
        final wallets = event.wallets;
        emit(AssetsLoading());
        try {
          final assets = await assetRepository.getAssets(wallets);
          emit(AssetsLoaded(assets: assets));
        } catch (error) {
          emit(AssetsError(error: error.toString()));
        }
      }
}
