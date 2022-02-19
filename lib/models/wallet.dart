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
}