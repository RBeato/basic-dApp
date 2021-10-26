import 'package:basic_dapp/models/eth_utils.dart';
import 'package:basic_dapp/models/exception.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ethUtilsNotifierProvider =
    StateNotifierProvider<EthereumUtilsProvider, AsyncValue<int>>((ref) {
  return EthereumUtilsProvider(ref.read);
});

class EthereumUtilsProvider extends StateNotifier<AsyncValue<int>> {
  EthereumUtilsProvider(this.read, [AsyncValue contractState])
      : super(contractState ?? const AsyncValue.loading()) {
    ethUtils.initialSetup();
    ethUtils.getBalance();
  }

  final Reader read;
  final EthereumUtils ethUtils = EthereumUtils();

  Future<void> getBalance() async {
    state = const AsyncValue.loading();
    try {
      final balance = await ethUtils.getBalance();
      state = AsyncValue.data(balance);
    } on ContractException catch (e) {
      state = AsyncValue.error(e);
    }
  }

  Future withdrawCoin(int amount) async {
    state = const AsyncValue.loading();
    try {
      if (amount < state.data.value) {
        int newBalance = state.data.value - amount;
        state = AsyncValue.data(newBalance);
        final transactionHash = await ethUtils.withdrawCoin(amount);
        return transactionHash;
      } else {}
    } catch (e) {
      state = AsyncError(e);
    }
  }

  Future depositCoin(int amount) async {
    try {
      int newBalance = state.data.value + amount;
      state = AsyncValue.data(newBalance);
      final transactionHash = await ethUtils.depositCoin(amount);
      return transactionHash;
    } catch (e) {
      state = AsyncError(e);
    }
  }
}
