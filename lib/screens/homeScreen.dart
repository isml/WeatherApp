import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter_svg/svg.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoder/geocoder.dart';

import 'package:havadurumu/api_constants.dart';
import 'package:havadurumu/model/sehirData.dart';
import 'package:havadurumu/model/weatherData.dart';
import 'package:havadurumu/screens/miniWeatherDetay.dart';
import 'package:geolocator/geolocator.dart';
import 'package:havadurumu/screens/sehirArama.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  String secilmisSehir;
  HomeScreen({this.secilmisSehir});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String konumIl;
  String konum;
  String sehir;
  String latitude = "";
  String longitude = "";

  List<Color> cloudlyColors = [Colors.blueGrey, Colors.grey[200]];
  List<Color> sunnyColors = [Colors.cyan[300], Colors.lightGreen[200]];
  List<Color> rainyColors = [Colors.indigo, Colors.grey[400]];
  List<Color> snowyColors = [Colors.grey, Colors.white];

  List<WeatherData> weatherDataList = List<WeatherData>();
  List<Map<dynamic, dynamic>> weatherDataMapList =
      List<Map<dynamic, dynamic>>();

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: FutureBuilder<Object>(
            future: _getdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return spinkit();
              } else {
                if (snapshot.hasError) return Center(child: Text('hata'));
                return _homeWidget(screenSize);
              }
            }));
  }

  Future<String> _getdata() async {
    String kontrol = widget.secilmisSehir.toString();

    if (widget.secilmisSehir == null) {
      print("secim yok" + widget.secilmisSehir.toString());
      //Secilmis sehir yok
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      final coordinates =
          new Coordinates(position.latitude, position.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      sehir = addresses.first.adminArea.toString();
      konum = addresses.first.subLocality.toString().toLowerCase();
      //print(addresses.first.subLocality);
      konumIl = addresses.first.subAdminArea;
      //print(konum);
    } else {
      print("secim var  ve : " + widget.secilmisSehir);
      //ilk olarak konum bilgisi
      konum = widget.secilmisSehir.toString().toLowerCase();
    }

//api ile etkileşime geçilen kısım burdan sonra
    weatherDataMapList.clear();

    final response = await http.get(ApiConstants.API_LINK + konum.toLowerCase(),
        headers: {
          "content-type": "application/json",
          "authorization": ApiConstants.TOKEN_VALUE
        });
    //print(response.body);
    var list = json.decode(response.body);
    weatherDataList.add(WeatherData.fromJson(json.decode(response.body)));
    //var listresult = list["result"];
    var listresult = list["result"];
    for (var i = 0; i < listresult.length; i++) {
      weatherDataMapList.add(listresult[i]);
    }
    //print(weatherDataMapList[6]);
  }

  Widget _homeWidget(Size screenSize) {
    return Column(
      children: [
        Container(
          width: screenSize.width,
          height: screenSize.height / 1.3,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: weatherDataMapList[0]["description"] == "açık"
                      ? sunnyColors
                      : weatherDataMapList[0]["description"] == "karlı"
                          ? snowyColors
                          : weatherDataMapList[0]["description"] == "yağmurlu"
                              ? rainyColors
                              : cloudlyColors)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0),
                      child: Text(
                        weatherDataMapList[0]["day"],
                        style: TextStyle(
                            fontSize: screenSize.width / 7,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(konumIl == null
                            ? konum.toString().toUpperCase()
                            : "${konumIl.toUpperCase()}" "/" +
                                konum.toString().toUpperCase()),
                        IconButton(
                            icon: Icon(Icons.edit_location),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchDeneme()));
                            }),
                      ],
                    ),
                  ],
                ),
                Container(
                  height: screenSize.height / 3,
                  width: screenSize.width / 2,
                  child: SvgPicture.network(
                    weatherDataMapList[0]["icon"],
                    semanticsLabel: 'Feed button',
                    placeholderBuilder: (context) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      weatherDataMapList[0]["degree"]
                              .toString()
                              .substring(0, 2) +
                          "°C",
                      style: TextStyle(
                          fontSize: screenSize.width / 8,
                          color: Colors.blueGrey[800],
                          fontWeight: FontWeight.w500)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                                weatherDataMapList[0]["min"]
                                        .toString()
                                        .substring(0, 2) +
                                    "°C",
                                style: TextStyle(
                                    fontSize: screenSize.width / 16,
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.red[800],
                              size: screenSize.width / 16,
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Text("Hava Durumu",
                                style: TextStyle(
                                    fontSize: screenSize.width / 24,
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.w500)),
                            Text(
                                weatherDataMapList[0]["description"]
                                    .toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: screenSize.width / 16,
                                    color: Colors.indigo[800],
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                weatherDataMapList[0]["max"]
                                        .toString()
                                        .substring(0, 2) +
                                    "°C",
                                style: TextStyle(
                                    fontSize: screenSize.width / 16,
                                    color: Colors.blueGrey[800],
                                    fontWeight: FontWeight.w500)),
                            Icon(
                              Icons.arrow_drop_up,
                              color: Colors.green[800],
                              size: screenSize.width / 16,
                            )
                          ],
                        ),
                      ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      Container(
                        height: screenSize.height / 10,
                        width: screenSize.height / 10,
                        child: Image.asset("assets/ay.png"),
                      ),
                      SizedBox(
                        width: screenSize.width / 60,
                      ),
                      Text(
                          weatherDataMapList[0]["night"]
                                  .toString()
                                  .substring(0, 2) +
                              "°C",
                          style: TextStyle(
                              fontSize: screenSize.width / 16,
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w500)),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: screenSize.width / 14,
                                width: screenSize.width / 14,
                                child: SvgPicture.network(
                                  "https://www.flaticon.com/svg/static/icons/svg/3105/3105807.svg",
                                  placeholderBuilder: (context) =>
                                      Icon(Icons.error),
                                ),
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                "Nem:" +
                                    "%" +
                                    weatherDataMapList[0]["humidity"],
                                style: TextStyle(
                                    fontSize: screenSize.width / 16,
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(children: [
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 1),
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 2),
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 3),
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 4),
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 5),
            _containerDivider(screenSize),
            _miniWeatherCard(screenSize, 6),
            _containerDivider(screenSize),
          ]),
        )
      ],
    );
  }

  _containerDivider(Size screenSize) {
    return Container(
      height: screenSize.height - screenSize.height / 1.3,
      width: 2,
      color: Colors.indigo,
    );
  }

  _miniWeatherCard(Size screenSize, int gun) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MiniWeatherDetay(
                      day: weatherDataMapList[gun]["day"],
                      icon: weatherDataMapList[gun]["icon"].toString(),
                      degree: weatherDataMapList[gun]["degree"],
                      min: weatherDataMapList[gun]["min"],
                      status: weatherDataMapList[gun]["description"],
                      max: weatherDataMapList[gun]["max"],
                      night: weatherDataMapList[gun]["night"],
                      humidity: weatherDataMapList[gun]["humidity"],
                      colors: weatherDataMapList[gun]["description"] == "açık"
                          ? sunnyColors
                          : weatherDataMapList[gun]["description"] == "karlı"
                              ? snowyColors
                              : weatherDataMapList[gun]["description"] ==
                                      "ysğmurlu"
                                  ? rainyColors
                                  : cloudlyColors,
                    )));
      },
      child: Container(
        width: screenSize.width / 4,
        height: screenSize.height - screenSize.height / 1.3,
        decoration: BoxDecoration(
            //border: Border.all(),
            borderRadius: BorderRadius.circular(1),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: weatherDataMapList[gun]["description"] == "açık"
                    ? sunnyColors
                    : weatherDataMapList[gun]["description"] == "karlı"
                        ? snowyColors
                        : weatherDataMapList[gun]["description"] == "ysğmurlu"
                            ? rainyColors
                            : cloudlyColors)),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(child: Text(weatherDataMapList[gun]["day"])),
          Flexible(
            child: Container(
              child: SvgPicture.network(
                weatherDataMapList[gun]["icon"].toString(),
                placeholderBuilder: (context) => Icon(Icons.error),
              ),
            ),
          ),
          Flexible(
            child: Text(
                weatherDataMapList[gun]["degree"].toString().substring(0, 2) +
                    "°C",
                style: TextStyle(color: Colors.blueGrey[800])),
          ),
        ]),
      ),
    );
  }

  Widget spinkit() {
    return Center(
        child: SpinKitWave(
      duration: const Duration(milliseconds: 900),
      size: 65,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Colors.white),
        );
      },
    ));
  }

  Future<String> _getIntFromSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
    final secilisehir = prefs.getString('secilenil');
    if (secilisehir == null) {
      return "0";
    }

    return secilisehir;
  }
}
