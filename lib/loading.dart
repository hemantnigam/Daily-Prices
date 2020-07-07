import 'package:daily_prices/commodity_prices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  
  void getAPIData() async{
    CommodityPrices apiData = CommodityPrices();
    await apiData.getData();

    Navigator.pushReplacementNamed(context, "/home", arguments: apiData.result);
  }

  @override
  void initState() {
    super.initState();
    getAPIData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: SpinKitRotatingCircle(
        color: Colors.white,
        size: 80.0,
      ),
    );
  }
}
