import 'package:flutter/material.dart';
import 'package:mycryptos/misc/global_keys.dart';
import 'package:mycryptos/models/wallet.dart';
import 'package:mycryptos/repositories/database_repo.dart';
import 'package:mycryptos/views/scan_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TrackedSourcesScreen extends StatefulWidget {
  TrackedSourcesScreen({Key? key}) : super(key: key);

  @override
  _TrackedSourcesScreenState createState() => _TrackedSourcesScreenState();
}

class _TrackedSourcesScreenState extends State<TrackedSourcesScreen> {
  final TextEditingController QRController = TextEditingController();

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  List<Wallet> wallets = [];
  int walletCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tracked wallets"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Align(
                alignment: Alignment.bottomLeft,
                child: Text("Add new wallet:")),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: QRController,
                  decoration: InputDecoration(
                      labelText: "Wallet address",
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      suffixIcon: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.qr_code_2),
                        onPressed: () async {
                          QRController.text = await Navigator.push(
                            context,
                              MaterialPageRoute(
                                  builder: (context) => ScanScreen()));
                        },
                      )),
                )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      DatabaseRepo().insertWallet(
                          Wallet(address: QRController.text, name: "")).then((v) => GlobalKeys.portfolioKey.currentState!.initState());
                      wallets.insert(walletCount, Wallet(address: QRController.text, name: ""));
                      walletCount++;
                      listKey.currentState!.insertItem(walletCount -1, duration: Duration(milliseconds: 500));
                      
                      
                    },
                    child: Text("Add"))
              ],
            ),
            Padding(padding:  EdgeInsets.symmetric(vertical: 16),child:Divider()),
            FutureBuilder<List<Wallet>>(
              future: DatabaseRepo().getWallets(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Wallet>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
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
                            itemBuilder: (BuildContext context, int index, animation) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Dismissible(
                                background: Container(
                                  color: Colors.red,
                                  child: Icon(Icons.delete),
                                ),
                                key: ValueKey(wallets[index].address),
                                onDismissed: (dismissDirection) {
                                  DatabaseRepo().deleteWallet(wallets[index].address);
                                  wallets.removeAt(index);
                                  walletCount--;
                                  listKey.currentState!.removeItem(index, (_, animation) => SizedBox());
                                  
                          
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
                                  title: Text(
                                      wallets[index].name.isNotEmpty
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
