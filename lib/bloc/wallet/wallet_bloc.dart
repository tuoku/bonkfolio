import 'package:bloc/bloc.dart';
import 'package:bonkfolio/repositories/wallet_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../error/wallet_error.dart';
import '../../models/wallet.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletBloc({required this.walletRepository}) : super(WalletInitial()) {
    on<WalletsRequested>(_onWalletsRequested);
  }

  final WalletRepository walletRepository;

  void _onWalletsRequested(
      WalletsRequested event, Emitter<WalletState> emit) async {
    emit(WalletsLoading());
    try {
      final wallets = await walletRepository.getWallets();
      if (wallets.isNotEmpty) {
        emit(WalletsLoaded(wallets: wallets));
      } else {
        emit(WalletsEmpty());
      }
    } catch (e) {
      if (kDebugMode) print(e);
      emit(WalletsError(error: e is WalletError ? e : WalletError()));
    }
  }
}
