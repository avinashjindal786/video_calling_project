import 'package:flutter/material.dart';
import 'package:wallet_flutter/TransectionModal.dart';

class ListWidgett extends StatelessWidget {
  final Result data;
  final String address;
  const ListWidgett({super.key, required this.data, required this.address});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 5,
                offset: Offset(1, 1),
                color: Colors.grey.shade500)
          ]),
      child: Row(
        children: [
          data.fromAddress == address
              ? Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.red.shade400,
                  size: 30,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.grey.shade500,
                      offset: Offset(1, 1),
                    )
                  ],
                )
              : Icon(
                  Icons.arrow_downward,
                  color: Colors.green.shade400,
                  size: 30,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.grey.shade500,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
          Spacer(),
          Text(
            data.hash!.substring(0, 15) + '...',
            style: TextStyle(color: Colors.grey.shade700, fontSize: 18),
          ),
          Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              (double.parse(data.value!) / 1000000000000000000).toString(),
              style: TextStyle(color: Colors.black87, fontSize: 22),
            ),
          )
        ],
      ),
    );
  }
}
