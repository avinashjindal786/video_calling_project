import 'package:realm/realm.dart';

part "wallet_realm_model.g.dart";

@RealmModel()
class _MyCredentials {
 @PrimaryKey()
  late ObjectId id;
  late String publicKeyHex;
  late String address;
}
