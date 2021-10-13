import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:http/http.dart' as http;
import 'package:web3dart/web3dart.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'custom_button.dart';
import 'eth_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // EthereumUtils ethUtils = EthereumUtils();

  double _value = 0.0;
  var _myData;
  http.Client httpClient;
  Web3Client ethClient;
  final myAddress = dotenv.env['METAMASK_RINKEBY_WALLET_ADDRESS'];

  @override
  void initState() {
    super.initState();
    httpClient = http.Client();
    String infura =
        "https://rinkeby.infura.io/v3/" + dotenv.env['INFURA_PROJECT_ID'];
    ethClient = Web3Client(infura, httpClient);
    // ethUtils.initialSetup();
    getBalance().then((_) {
      setState(() {});
    });
  }

  Future<DeployedContract> loadContract() async {
    String abi = await rootBundle.loadString("assets/abi.json");
    String firstCoinContractAddress = dotenv.env['FIRST_COIN_CONTRACT_ADDRESS'];
    final contract = DeployedContract(ContractAbi.fromJson(abi, "FirstCoin"),
        EthereumAddress.fromHex(firstCoinContractAddress));

    return contract;
  }

  // Future<void> getBalance() async {
  Future<void> getBalance() async {
    List<dynamic> result = await query("getBalance", []);
    var myData = await result[0];
    _myData = await myData;
    // return myData;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    final ethFunction = contract.function(functionName);
    final result = await ethClient.call(
      contract: contract,
      function: ethFunction,
      params: args,
    );
    return result;
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

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credential =
        EthPrivateKey.fromHex(dotenv.env['METAMASK_PRIVATE_KEY']);
    DeployedContract contract = await loadContract();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Basic dApp",
          style: TextStyle(
            fontFamily: 'vtks_distress',
            fontSize: 25.0,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/eth_coin.png"),
          fit: BoxFit.cover,
          colorFilter:
              ColorFilter.mode(Colors.blue.withOpacity(0.1), BlendMode.dstATop),
        )),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.width * 0.3,
                    child: Card(
                      elevation: 20.0,
                      color: Colors.white10.withOpacity(0.6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Your balance:",
                            style: TextStyle(
                                color: Colors.black38, fontSize: 18.0),
                          ),
                          _myData == null
                              ? CircularProgressIndicator()
                              : Text(
                                  "$_myData \FirstCoin",
                                  style: TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.blue.shade600),
                                  textAlign: TextAlign.center,
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
                CustomButton(
                  title: "REFRESH",
                  color: Colors.greenAccent,
                  onTapped: () async {
                    getBalance();
                    setState(() {});
                  },
                ),
                SfSlider(
                  min: 0.0,
                  max: 10.0,
                  value: _value,
                  interval: 1,
                  showTicks: true,
                  showLabels: true,
                  enableTooltip: true,
                  stepSize: 1.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      _value = value;
                    });
                  },
                ),
                CustomButton(
                  title: "DEPOSIT",
                  color: Colors.blueAccent,
                  onTapped: () async {
                    var _depositReceipt = await depositCoin(_value);
                    print("Deposit response: $_depositReceipt");
                    if (_value == 0) {
                      insertValidValue(context);
                      return;
                    } else {
                      showReceipt(context, "deposit", _depositReceipt);
                    }
                  },
                ),
                CustomButton(
                  title: "WIDTHRAW",
                  color: Colors.pinkAccent,
                  onTapped: () async {
                    var _widthrawReceipt = await widthrawCoin(_value);
                    print("Widthraw response: $_widthrawReceipt");
                    if (_value == 0) {
                      insertValidValue(context);
                      return;
                    } else {
                      showReceipt(context, "withraw", _widthrawReceipt);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

insertValidValue(BuildContext context) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.8),
          title: Text(
            'Not allowed',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'vtks_distress',
              fontSize: 18.0,
            ),
          ),
          content: const Text('Please insert a \nvalue different from 0!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
              )),
          actions: [
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

showReceipt(BuildContext context, String text, String receipt) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white.withOpacity(0.8),
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              "Thank you for making a $text",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'vtks_distress',
                fontSize: 18.0,
              ),
            ),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Here is your receipt",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Raleway',
                      color: Colors.blueGrey.shade600),
                ),
                Text(receipt,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black87)),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}
