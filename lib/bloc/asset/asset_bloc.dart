import 'package:bloc/bloc.dart';
import 'package:bonkfolio/repositories/asset_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

import '../../error/asset_error.dart';
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
    } catch (e) {
      if (kDebugMode) print(e);
      emit(AssetsError(error: e is AssetError ? e : AssetError()));
    }
  }
}
