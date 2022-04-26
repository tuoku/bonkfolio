import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/asset.dart';

part 'asset_detail_event.dart';
part 'asset_detail_state.dart';

class AssetDetailBloc extends Bloc<AssetDetailEvent, AssetDetailState> {
  AssetDetailBloc() : super(AssetdetailInitial()) {
    on<AssetSelected>((event, emit) {
      emit(AssetActive(asset: event.asset));
    });
  }
}
