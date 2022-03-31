import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AssetTileShimmer extends StatelessWidget {
  const AssetTileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final random = Random();
    return Shimmer.fromColors(
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade600, width: 0.2))),
          child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              isThreeLine: false,
              onTap: () {},
              autofocus: false,
              leading: const CircleAvatar(
                  backgroundImage:
                      NetworkImage("https://via.placeholder.com/150")),
              title: Row(children: [
                Container(
                  width: (width * 0.3 + random.nextInt((width * 0.2).floor())),
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                )
              ]),
              subtitle: Row(children: [
                Container(
                  width: (width * 0.1 + random.nextInt((width * 0.1).floor())),
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.grey,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                )
              ]),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: (width * 0.06 +
                          random.nextInt((width * 0.1).floor())),
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: (width * 0.06 +
                          random.nextInt((width * 0.1).floor())),
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey,
                      ),
                    ),
                  ]))),
      baseColor: Colors.grey.shade700,
      highlightColor: Colors.grey.shade400,
    );
  }
}
