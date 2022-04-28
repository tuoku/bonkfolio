import 'database.dart';

class Wallet {
  final String address;
  final String name;

  Wallet({required this.address, required this.name});

  Map<String, String> toMap() {
    return {
      'address': address,
      'name': name,
    };
  }

  factory Wallet.fromDb(dbWallet w) => Wallet(address: w.address, name: w.name);
}
