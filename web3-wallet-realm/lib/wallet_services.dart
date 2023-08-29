// ignore_for_file: avoid_print
import './const.dart';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wallet_flutter/TransectionModal.dart';
import 'package:wallet_flutter/wallet_realm_model.dart';
import 'package:web3dart/crypto.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart' as web3;
import 'package:realm/realm.dart';

import 'package:web3dart/web3dart.dart';

class WalletServices extends ChangeNotifier {
  String rpcUrl = INFURA_KEY;
  var priateKeyHex = '';
  double balance = 0.00;

  late final Realm localRealm;
  Transect? list;

  MyCredentials? myCredentials;

  Future<void> getABI(User user) async {
    var rng = Random.secure();
    web3.EthPrivateKey random = web3.EthPrivateKey.createRandom(rng);

    var address = random.address;
    var priateKey = random.privateKey;

    priateKeyHex = bytesToHex(priateKey).split('').reversed.join('');
    print(priateKeyHex.length);
    if (priateKeyHex.length > 64) {
      priateKeyHex = priateKeyHex.substring(0, priateKeyHex.length - 2);
      print(priateKeyHex.length);
    }
    priateKeyHex = priateKeyHex.split('').reversed.join('');
    var address1 = address.hex;

    print(address1 + " --- " + bytesToHex(priateKey));
    print(priateKeyHex);

    create(priateKeyHex, address1, user);
    notifyListeners();
  }

  void create(String priateKey, String address, User user) {
    if (myCredentials == null) {
      localRealm.write(() {
        localRealm.add(MyCredentials(
            ObjectId.fromHexString(user.id), priateKeyHex, address));
      });
      myCredentials =
          localRealm.find<MyCredentials>(ObjectId.fromHexString(user.id));
      getBalance(myCredentials!);
    }

    notifyListeners();
  }

  void intialize(User user) {
    final configLocal = Configuration.local([MyCredentials.schema],
        fifoFilesFallbackPath: "./wallet");
    localRealm = Realm(configLocal);

    myCredentials =
        localRealm.find<MyCredentials>(ObjectId.fromHexString(user.id));
    print(myCredentials!.address);
    if (myCredentials != null) {
      getBalance(myCredentials!);
    }
    notifyListeners();
  }

  Future<double> getBalance(MyCredentials myCredentials) async {
    final client = web3.Web3Client(rpcUrl, Client());
    final credentials = web3.EthPrivateKey.fromHex(myCredentials.publicKeyHex);
    final address = credentials.address;
    final val = await client.getBalance(address);
    balance = val.getInWei / BigInt.from(1000000000000000000);
    notifyListeners();
    return balance;
  }

  void sendTransection(
      String toAdress, String value, MyCredentials data) async {
    final client = web3.Web3Client(rpcUrl, Client());

    final credentials = web3.EthPrivateKey.fromHex(data.publicKeyHex);
    final address = credentials.address;
    final BigInt amo = BigInt.from(double.parse(value) * 1000000000000000000);
    print(address.hexEip55);
    print(amo);
    print(credentials.privateKey);
    print(await client.getGasPrice());
    print(await client.getBalance(address));
    var transaction = web3.Transaction(
        to: web3.EthereumAddress.fromHex(toAdress),
        value: web3.EtherAmount.fromBigInt(web3.EtherUnit.wei, amo));
    final supply = await client.signTransaction(credentials, transaction,
        chainId: 11155111);
    final result = await client.sendRawTransaction(supply);
    print(result);
    print(await client.getTransactionCount(address));
    getTransections();

    await client.dispose();
  }

  void getTransections() async {
    final apiKey = MORALIS_KEY;
    final url =
        'https://deep-index.moralis.io/api/v2/${myCredentials!.address}/verbose?chain=sepolia';

    try {
      // Send the HTTP GET request with the required headers
      final response = await get(
        Uri.parse(url),
        headers: {
          'accept': 'application/json',
          'X-API-Key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        print('Response: ${response.body}');
        list = Transect.fromJson(json.decode(response.body));
        notifyListeners();
        print(list!.result!.length);
      } else {
        print('Request failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending request: $e');
    }
  }
}
