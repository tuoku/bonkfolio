import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bonkfolio/models/asset.dart';
import 'package:bonkfolio/models/asset_meta.dart';
import 'package:bonkfolio/models/crypto.dart';
import 'package:bonkfolio/repositories/coingecko_repo.dart';
import 'package:bonkfolio/views/crypto_details_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AssetTile extends StatelessWidget {
  AssetTile({Key? key, required this.asset, required this.pvalue})
      : super(key: key);

  final Asset asset;
  final double pvalue;
  final nf = NumberFormat.compact();

  @override
  Widget build(BuildContext context) {
    final avg = asset.avgBuyPrice;
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade600, width: 0.2))),
        child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            isThreeLine: false,
            onTap: () {
              if (asset.isSupported) {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => AssetDetailsScreen(
                      asset: asset,
                      pValue: pvalue,
                    ),
                  ),
                );
              } else {
                Fluttertoast.cancel();
                Fluttertoast.showToast(
                    msg: "Unsupported token",
                    backgroundColor: Colors.red,
                    toastLength: Toast.LENGTH_SHORT);
              }
            },
            autofocus: false,
            leading: CircleAvatar(
              backgroundImage: NetworkImage(CoinGeckoRepo()
                  .metas
                  .firstWhere(
                      (element) =>
                          element.id.toLowerCase() ==
                          (asset as Crypto).contractAddress.toLowerCase(),
                      orElse: () => AssetMeta(
                          id: "",
                          thumbnail: "https://via.placeholder.com/150",
                          cgId: ""))
                  .thumbnail!),
            ),
            title: Text(
              '${asset.name} ',
              maxLines: 1,
            ),
            subtitle: Text(nf.format(asset.amount) +
                (asset.isSupported
                    ? ' (\$${(asset.amount * asset.price).toStringAsFixed(2)})'
                    : "")),
            trailing: asset.isSupported
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                        Text(
                          ((((asset.price - avg) / avg) * 100) >= 0
                                  ? '+'
                                  : "") +
                              (((asset.price - avg) / avg) * 100)
                                  .toStringAsFixed(2) +
                              "%",
                          style: TextStyle(
                              color: ((asset.price - avg) /
                                          ((asset.price + avg) / 2) *
                                          100) >=
                                      0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                        Text(asset.price.toStringAsPrecision(4)),
                      ])
                : const SizedBox()));
  }
}
