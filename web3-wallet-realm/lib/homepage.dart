
import './ListWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:realm/realm.dart';
import 'package:wallet_flutter/TransectionModal.dart';
import 'package:wallet_flutter/authentication_provider.dart';
import 'package:wallet_flutter/wallet_realm_model.dart';
import './wallet_services.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<LoginRealm>().anonamusRegister().then((value) => context
        .read<WalletServices>()
        .intialize(context.read<LoginRealm>().user!));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyCredentials? data = context.watch<WalletServices>().myCredentials;
    double balc = context.watch<WalletServices>().balance;
    context.read<WalletServices>().getTransections();
    Transect? listTransection = context.watch<WalletServices>().list;
    TextEditingController amountCtr = TextEditingController();
    TextEditingController accountCtr = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          leading: SizedBox(
            width: 1,
          ),
          title: Center(
            child: Text(
              'Deep Wallet',
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.white,
                      offset: Offset(0, 0),
                    ),
                  ]),
            ),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(onPressed: logout, icon: const Icon(Icons.logout))
          ]),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 90,
            ),
            data == null
                ? TextButton(
                    onPressed: addWallet,
                    child: const Text('Add Wallet'),
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.black87,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10)))),
                  )
                : Column(
                    children: [
                      Text(
                        balc == 0.00 ? "0.00" : balc.toString().substring(0, 8),
                        style: const TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      const Text('Eth', style: TextStyle(fontSize: 25)),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () {
                                context
                                    .read<WalletServices>()
                                    .getTransections();
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                    height: 500,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Center(
                                            child: PrettyQr(
                                              typeNumber: 3,
                                              size: 200,
                                              data: data.address,
                                              errorCorrectLevel:
                                                  QrErrorCorrectLevel.M,
                                              roundEdges: true,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Center(
                                            child: Text(data.address,
                                                style: TextStyle(
                                                    color: Colors.grey.shade800,
                                                    fontSize: 13)),
                                          ),
                                          Center(
                                            child: Container(
                                                height: 100,
                                                width: 400,
                                                alignment: Alignment.center,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    await Clipboard.setData(
                                                        ClipboardData(
                                                            text:
                                                                data.address));
                                                    // copied successfully
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Copy to clipboard',
                                                          style: TextStyle(
                                                              color: Colors.grey
                                                                  .shade700,
                                                              fontSize: 15)),
                                                      Icon(Icons.copy_rounded,
                                                          color: Colors
                                                              .grey.shade700,
                                                          size: 15),
                                                    ],
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ), // color is applied to main screen when modal bottom screen is displayed
                                  barrierColor: Colors.black38,
                                  //background color for modal bottom screen
                                  backgroundColor: Colors.white,
                                  //elevates modal bottom screen
                                  elevation: 10,
                                  // gives rounded corner to modal bottom screen
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                );
                              },
                              child: const Text('Receive Eth')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black87,
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10)))),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  // color is applied to main screen when modal bottom screen is displayed
                                  barrierColor: Colors.black38,
                                  //background color for modal bottom screen
                                  backgroundColor: Colors.white,
                                  //elevates modal bottom screen
                                  elevation: 10,
                                  // gives rounded corner to modal bottom screen
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  builder: (BuildContext context) {
                                    // UDE : SizedBox instead of Container for whitespaces
                                    return SizedBox(
                                      height: 500,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Align(
                                                alignment: Alignment.topCenter,
                                                child: Text("Send Transection",
                                                    style: TextStyle(
                                                        fontSize: 25))),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 500, minHeight: 50),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .grey.shade400
                                                          .withOpacity(0.5),
                                                      style: BorderStyle.none,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignInside,
                                                      width: 0,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .grey.shade400
                                                          .withOpacity(0.5),
                                                      style: BorderStyle.none,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignInside,
                                                      width: 0,
                                                    ),
                                                  ),
                                                  floatingLabelStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade700),
                                                  fillColor: Colors
                                                      .grey.shade400
                                                      .withOpacity(0.5),
                                                  filled: true,
                                                  labelText: "Amount",
                                                ),
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: amountCtr,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50,
                                            ),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 500, minHeight: 50),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: TextField(
                                                decoration: InputDecoration(
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .grey.shade400
                                                          .withOpacity(0.5),
                                                      style: BorderStyle.none,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignInside,
                                                      width: 0,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    borderSide: BorderSide(
                                                      color: Colors
                                                          .grey.shade400
                                                          .withOpacity(0.5),
                                                      style: BorderStyle.none,
                                                      strokeAlign: BorderSide
                                                          .strokeAlignInside,
                                                      width: 0,
                                                    ),
                                                  ),
                                                  floatingLabelStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade700),
                                                  fillColor: Colors
                                                      .grey.shade400
                                                      .withOpacity(0.5),
                                                  filled: true,
                                                  labelText: "To Address",
                                                ),
                                                controller: accountCtr,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (accountCtr.text != '' &&
                                                    amountCtr.text != '') {
                                                  context
                                                      .read<WalletServices>()
                                                      .sendTransection(
                                                          accountCtr.text,
                                                          amountCtr.text,
                                                          data);
                                                }
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("send Amount",
                                                  style:
                                                      TextStyle(fontSize: 15)),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.black87,
                                                  elevation: 5,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text('Send Eth')),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (listTransection == null) ...[
                              CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black))
                            ] else if (listTransection.result.isEmpty) ...[
                              Text('No transections to show')
                            ] else
                              ...listTransection.result.map((element) {
                                return GestureDetector(
                                  onTap: () async {
                                    await Clipboard.setData(
                                        ClipboardData(text: element.hash!));
                                    // copied successfully
                                  },
                                  child: ListWidgett(
                                      data: element, address: data.address),
                                );
                              }).toList()
                          ],
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void logout() {
    context.read<LoginRealm>().logout();
  }

  void addWallet() {
    context.read<WalletServices>().getABI(context.read<LoginRealm>().user!);
  }
}
