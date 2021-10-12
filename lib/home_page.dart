import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  int _myAmount = 0;
  var _myData;

  @override
  void initState() {
    super.initState();
    ethUtils.initialSetup();
    _myData = ethUtils.getBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Basic dApp"),
      ),
      body: Center(
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
                          style: TextStyle(color: Colors.black38),
                        ),
                        Text(
                          "$_myData \FirstCoin",
                          style: TextStyle(fontSize: 25.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomButton(
                title: "REFRESH",
                color: Colors.greenAccent,
                onTapped: () {
                  ethUtils.getBalance();
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
                minorTicksPerInterval: 1,
                onChanged: (dynamic value) {
                  setState(() {
                    _value = value;
                    _myAmount = value.round();
                  });
                },
              ),
              CustomButton(
                title: "DEPOSIT",
                color: Colors.blueAccent,
                onTapped: () {
                  ethUtils.depositCoin(_value);
                },
              ),
              CustomButton(
                title: "WIDTHRAW",
                color: Colors.pinkAccent,
                onTapped: () {
                  ethUtils.widthrawCoin(_value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
