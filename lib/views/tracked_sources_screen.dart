import 'package:flutter/material.dart';
import 'package:bonkfolio/misc/globals.dart';
// import 'package:bonkfolio/models/wallet.dart';
import 'package:bonkfolio/views/scan_screen.dart';

import '../models/wallet.dart';

class TrackedSourcesScreen extends StatefulWidget {
  const TrackedSourcesScreen({Key? key}) : super(key: key);

  @override
  _TrackedSourcesScreenState createState() => _TrackedSourcesScreenState();
}

class _TrackedSourcesScreenState extends State<TrackedSourcesScreen> {
  final TextEditingController qrController = TextEditingController();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<Wallet> wallets = [];
  int walletCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tracked wallets"),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Align(
                alignment: Alignment.bottomLeft,
                child: Text("Add new wallet:")),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: qrController,
                  decoration: InputDecoration(
                      labelText: "Wallet address",
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.qr_code_2),
                        onPressed: () async {
                          qrController.text = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScanScreen()));
                        },
                      )),
                )),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      /*
                      DatabaseRepo()
                          .insertWallet(
                              Wallet(id: 0, address: qrController.text, name: ""))
                          .then((v) => GlobalKeys.portfolioKey.currentState!
                              .initState());
                      wallets.insert(walletCount,
                          Wallet(id: 0,address: qrController.text, name: ""));
                      walletCount++;
                      listKey.currentState?.insertItem(walletCount - 1,
                          duration: const Duration(milliseconds: 500));
                          */
                    },
                    child: const Text("Add"))
              ],
            ),
            const Padding(
                padding: EdgeInsets.symmetric(vertical: 16), child: Divider()),
            FutureBuilder<List<Wallet>>(
              future: Future.delayed(Duration(seconds: 2)),//DatabaseRepo().getWallets(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Wallet>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Error');
                  } else if (snapshot.hasData) {
                    wallets.addAll(snapshot.data!);
                    walletCount = wallets.length;
                    return Expanded(
                        child: AnimatedList(
                            key: listKey,
                            initialItemCount: wallets.length,
                            itemBuilder:
                                (BuildContext context, int index, animation) {
                              return ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Dismissible(
                                    background: Container(
                                      color: Colors.red,
                                      child: const Icon(Icons.delete),
                                    ),
                                    key: ValueKey(wallets[index].address),
                                    onDismissed: (dismissDirection) {
                                      /*
                                      DatabaseRepo()
                                          .deleteWallet(wallets[index].address);
                                      wallets.removeAt(index);
                                      walletCount--;
                                      listKey.currentState!.removeItem(index,
                                          (_, animation) => const SizedBox());
                                    */
                                    },
                                    confirmDismiss: (dismissDirection) async {
                                      return await showDialog(
                                        barrierDismissible: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Confirm"),
                                            content: const Text(
                                                "Are you sure you wish to delete this wallet?"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  child: const Text("DELETE")),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context)
                                                        .pop(false),
                                                child: const Text("CANCEL"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      onLongPress: () {},
                                      title: Text(wallets[index].name.isNotEmpty
                                          ? wallets[index].name
                                          : "Unnamed wallet"),
                                      subtitle: Text(wallets[index].address),
                                    ),
                                  ));
                            }));
                  } else {
                    return const Text('Empty data');
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
