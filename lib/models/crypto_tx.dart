class CryptoTX {
  DateTime time;
  double amount;
  String name;
  String id;
  String action;
  String contractAddress;
  int decimals;
  String clientAddress;
  String platform;

  CryptoTX(
      {required this.action,
      required this.amount,
      required this.id,
      required this.name,
      required this.time,
      required this.contractAddress,
      required this.decimals,
      required this.clientAddress,
      required this.platform});
}
