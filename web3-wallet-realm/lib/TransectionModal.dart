class Transect {
  int? pageSize;
  int? page;
  Null? cursor;
  List<Result> result = [];

  Transect({this.pageSize, this.page, this.cursor,required this.result});

  Transect.fromJson(Map<String, dynamic> json) {
    pageSize = json['page_size'];
    page = json['page'];
    cursor = json['cursor'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }
}

class Result {
  String? hash;
  String? nonce;
  String? transactionIndex;
  String? fromAddress;
  Null? fromAddressLabel;
  String? toAddress;
  Null? toAddressLabel;
  String? value;
  String? gas;
  String? gasPrice;
  String? input;
  String? receiptCumulativeGasUsed;
  String? receiptGasUsed;
  Null? receiptContractAddress;
  Null? receiptRoot;
  String? receiptStatus;
  String? blockTimestamp;
  String? blockNumber;
  String? blockHash;
  List<int>? transferIndex;
  List<Null>? logs;
  Null? decodedCall;

  Result(
      {this.hash,
      this.nonce,
      this.transactionIndex,
      this.fromAddress,
      this.fromAddressLabel,
      this.toAddress,
      this.toAddressLabel,
      this.value,
      this.gas,
      this.gasPrice,
      this.input,
      this.receiptCumulativeGasUsed,
      this.receiptGasUsed,
      this.receiptContractAddress,
      this.receiptRoot,
      this.receiptStatus,
      this.blockTimestamp,
      this.blockNumber,
      this.blockHash,
      this.transferIndex,
      this.logs,
      this.decodedCall});

  Result.fromJson(Map<String, dynamic> json) {
    hash = json['hash'];
    nonce = json['nonce'];
    transactionIndex = json['transaction_index'];
    fromAddress = json['from_address'];
    fromAddressLabel = json['from_address_label'];
    toAddress = json['to_address'];
    toAddressLabel = json['to_address_label'];
    value = json['value'];
    gas = json['gas'];
    gasPrice = json['gas_price'];
    input = json['input'];
    receiptCumulativeGasUsed = json['receipt_cumulative_gas_used'];
    receiptGasUsed = json['receipt_gas_used'];
    receiptContractAddress = json['receipt_contract_address'];
    receiptRoot = json['receipt_root'];
    receiptStatus = json['receipt_status'];
    blockTimestamp = json['block_timestamp'];
    blockNumber = json['block_number'];
    blockHash = json['block_hash'];
    transferIndex = json['transfer_index'].cast<int>();

    decodedCall = json['decoded_call'];
  }
}
