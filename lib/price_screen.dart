import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:bitcoin_ticker/coin_data.dart';
import 'package:bitcoin_ticker/data/datasource/networking.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedValue = currenciesList[0];
  List<DropdownMenuItem<String>> dropdownItems = [];
  List<Text> pickerItems = [];
  double priceBTC = 0;
  double priceETH = 0;

  @override
  void initState() {
    getPriceBitcoin(selectedValue);
    getPriceEtherum(selectedValue);
    super.initState();
  }

  void getPriceBitcoin(String currency) async {
    var url =
        'https://rest.coinapi.io/v1/exchangerate/${cryptoList[0]}/$currency';
    NetworkHelper networkHelper = NetworkHelper(url);

    try {
      var data = await networkHelper.getData();
      priceBTC = data['rate'];
    } catch (e) {
      print(e);
    }
  }

  void getPriceEtherum(String currency) async {
    var url =
        'https://rest.coinapi.io/v1/exchangerate/${cryptoList[1]}/$currency';
    NetworkHelper networkHelper = NetworkHelper(url);

    try {
      var data = await networkHelper.getData();
      priceETH = data['rate'];
    } catch (e) {
      print(e);
    }
  }

  DropdownButton<String> androidDropdown() {
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text('$currency'),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedValue,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          getPriceBitcoin(value);
          selectedValue = value;
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    for (String currency in currenciesList) {
      var newItem = Text('$currency');
      if (pickerItems.length < currenciesList.length) {
        pickerItems.add(newItem);
      }
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 35.0,
      looping: true,
      onSelectedItemChanged: (index) {
        setState(() {
          getPriceBitcoin(currenciesList[index]);
          selectedValue = currenciesList[index];
        });
      },
      children: pickerItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ${cryptoList[0]} = ${priceBTC.toInt()} $selectedValue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Card(
                  color: Colors.lightBlueAccent,
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                    child: Text(
                      '1 ${cryptoList[1]} = ${priceETH.toInt()} $selectedValue',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}
