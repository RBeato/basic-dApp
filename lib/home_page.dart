import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'custom_button.dart';
import 'eth_utils.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EthereumUtils ethUtils = EthereumUtils();

  double _value = 0.0;
  var _myData;

  final myAddress = dotenv.env['METAMASK_RINKEBY_WALLET_ADDRESS'];

  @override
  void initState() {
    super.initState();
    ethUtils.initialSetup();
    ethUtils.getBalance().then((data) {
      _myData = data;
      setState(() {});
    });
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
                    ethUtils.getBalance().then((data) => _myData = data);
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
                    var _depositReceipt = await ethUtils.depositCoin(_value);
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
                  title: "WITHDRAW",
                  color: Colors.pinkAccent,
                  onTapped: () async {
                    var _widthrawReceipt = await ethUtils.withdrawCoin(_value);
                    print("Withdraw response: $_widthrawReceipt");
                    if (_value == 0) {
                      insertValidValue(context);
                      return;
                    } else {
                      showReceipt(context, "withdraw", _widthrawReceipt);
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
              "Thank you for submiting a $text",
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
                  "Use the transaction hash bellow to check if it was successful",
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
