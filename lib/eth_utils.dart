import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EthereumUtils {
  http.Client httpClient;
  Web3Client ethClient;
  final contractAddress = "0x916213DD26d7d5123a330A569F326679a8B2F5F4";

  void initialSetup() {
    httpClient = http.Client();
    String infura =
        "https://rinkeby.infura.io/v3/" + dotenv.env['INFURA_PROJECT_ID'];
    ethClient = Web3Client(infura, httpClient);
    //https://rinkeby.infura.io/v3/c4971f6923244ed5bcd382a0f7e93b97
  }

  Future<DeployedContract> getDeployedContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FirstCoin"),
        EthereumAddress.fromHex(contractAddress));

    return contract;
  }

  Future<void> getBalance() async {
    List<dynamic> result = await query("getBalance", []);
    var myData = result[0];
    return myData;
  }

  Future<String> widthrawCoin(double amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("withdrawBalance", [bigAmount]);
    return response;
  }

  Future<String> depositCoin(double amount) async {
    var bigAmount = BigInt.from(amount);
    var response = await submit("depositBalance", [bigAmount]);
    return response;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return result;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credential =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']);
    DeployedContract contract = await getDeployedContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.sendTransaction(
        credential,
        Transaction.callContract(
            contract: contract,
            function: ethFunction,
            parameters: args,
            maxGas: 100000),
        chainId: 4);
    return result;
  }
}
