import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_prices/commodity_prices.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:daily_prices/commodity.dart';
import 'package:flutter/material.dart';

class DailyPricesApp extends StatefulWidget {
  @override
  _DailyPricesAppState createState() => _DailyPricesAppState();
}

class _DailyPricesAppState extends State<DailyPricesApp> {
  Map prices = {};
  Future<void> _handleRefresh() async {
    CommodityPrices apiData = CommodityPrices();
    await apiData.getData();

    setState(() {
      prices = apiData.result;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    prices = prices.keys.length != 0
        ? prices
        : ModalRoute.of(context).settings.arguments;

    Map fuelPrice = prices['fuelPrice'];
    Map weatherData = prices['weatherData'];
    Map data = prices['decodedData'];

    List<Commodity> commodityList = [];
    commodityList.add(Commodity(
        name: "Petrol",
        change: '${fuelPrice['city']}*',
        price: fuelPrice['Petrol'].toString()));
    commodityList.add(Commodity(
        name: "Diesel",
        change: '${fuelPrice['city']}*',
        price: fuelPrice['Diesel'].toString()));
    for (var i in data.keys) {
      var evalName = i;
      var evalPrice = "";
      var evalChange = "";
      if (i != "marketstatus" && i != "DXY Index") {
        switch (i) {
          case "sensex":
            evalPrice = data[i]['CloseIndexValue'];
            evalChange = data[i]['NetChange'];
            break;
          case "nifty":
            evalPrice = data[i]['CloseIndexValue'];
            evalChange = data[i]['NetChange'];
            break;
          case "gold":
            evalPrice = data[i]['ClosePrice'];
            evalChange = data[i]['NetChange'];
            break;
          case "silver":
            evalPrice = data[i]['ClosePrice'];
            evalChange = data[i]['NetChange'];
            break;
          case "USD/INR":
            evalPrice = data[i]['bidprice'];
            evalChange = data[i]['netChange'];
            break;
          case "EUR_INR":
            evalName = data[i]['name'].toString().replaceAll("_", "/");
            evalPrice = data[i]['bidprice'];
            evalChange = data[i]['netChange'];
            break;
          default:
            evalPrice = "";
        }
        Commodity commodity =
            Commodity(name: evalName, change: evalChange, price: evalPrice);
        commodityList.add(commodity);
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(),
      ),
      body: SafeArea(
          child: Stack(
        children: <Widget>[
          Container(
            height: height * 0.45,
            width: width,
            color: Theme.of(context).accentColor,
          ),
          Positioned(
            top: height * 0.33,
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0)),
                    color: Colors.white),
                height: height * 0.2,
                width: width),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(10.0, 40.0, 10.0, 10.0),
                child: SizedBox(
                  height: 35,
                  child: AutoSizeText(
                    "Daily Prices",
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.white,
                        fontFamily: 'FiraCode'),
                  ),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.edit_location,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          SizedBox(width: 5.0,),
                          Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: SizedBox(
                                    height: 25,
                                    child: AutoSizeText(
                                      '${weatherData['region']}',
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.white,
                                          fontFamily: 'FiraCode'),
                                    ),
                                  ),
                                ),
                                Container(
                                  child: SizedBox(
                                    height: 15,
                                    child: AutoSizeText(
                                      '(${weatherData['country']})',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          color: Colors.white,
                                          fontFamily: 'FiraCode'),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 40.0,
                                  maxWidth: 40.0,
                                  minHeight: 40.0,
                                  maxHeight: 40.0,
                                ),
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(
                                    'https:${weatherData['weather_icons']}'),
                                fit: BoxFit.fill,
                              )),
                            ),
                            Container(
                              child: SizedBox(
                                height: 20,
                                child: AutoSizeText(
                                  '${weatherData['temperature']}${new String.fromCharCodes(new Runes('\u00B0'))}C',
                                  style: TextStyle(
                                      fontFamily: 'FiraCode',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: SizedBox(
                  height: 15,
                  child: AutoSizeText(
                    "Categories",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.white,
                        fontFamily: 'FiraCode'),
                  ),
                ),
              ),
              Expanded(
                child: LiquidPullToRefresh(
                  // key if you want to add
                  onRefresh: _handleRefresh,
                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 2,
                      childAspectRatio: height * 0.75 / width,
                      children: commodityList.map((item) {
                        return Padding(
                          padding: EdgeInsets.all(10.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              color: Colors.grey[200],

                              ///each widget color
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            child: Opacity(
                                          opacity: 1,
                                          child: item.change.contains('*')
                                              ? Text(
                                                  '(${item.change.substring(0, item.change.length - 1)})',
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontFamily: 'FiraCode',
                                                  ),
                                                )
                                              : SizedBox(
                                                  height: 15,
                                                  child: AutoSizeText(
                                                    item.change,
                                                    style: TextStyle(
                                                      color: item.change
                                                              .toString()
                                                              .contains('-')
                                                          ? Colors.red
                                                          : Colors.green,
                                                      fontSize: 20.0,
                                                      fontFamily: 'FiraCode',
                                                    ),
                                                  ),
                                                ),
                                        )),
                                        Container(
                                            child: SizedBox(
                                          height: 20,
                                          child: AutoSizeText(
                                            item.price,
                                            style: TextStyle(
                                                fontSize: 15.0,
                                                fontFamily: 'FiraCode'),
                                          ),
                                        ))
                                      ],
                                    ),
                                    SizedBox(
                                      height: 35,
                                      child: AutoSizeText(
                                        item.name.toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 40.0,
                                            fontFamily: 'FiraCode'),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList()),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
