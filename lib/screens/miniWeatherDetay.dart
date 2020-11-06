import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MiniWeatherDetay extends StatefulWidget {
  List<Color> colors;
  String day;
  String icon;
  String degree;
  String min;
  String status;
  String max;
  String night;
  String humidity;
  MiniWeatherDetay(
      {this.colors,
      this.day,
      this.icon,
      this.degree,
      this.min,
      this.status,
      this.max,
      this.night,
      this.humidity});
  @override
  _MiniWeatherDetayState createState() => _MiniWeatherDetayState();
}

class _MiniWeatherDetayState extends State<MiniWeatherDetay> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      body: _miniWeatherPageWidget(screenSize),
    );
  }

  Widget _miniWeatherPageWidget(Size screenSize) {
    return SingleChildScrollView(
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              Container(
                width: screenSize.width,
                height: screenSize.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: widget.colors)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      widget.day,
                      style: TextStyle(
                          fontSize: screenSize.width / 7,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      height: screenSize.height / 3,
                      width: screenSize.width / 2,
                      child: SvgPicture.network(
                        widget.icon,
                        semanticsLabel: 'Feed button',
                        placeholderBuilder: (context) => Icon(Icons.error),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(widget.degree.toString().substring(0,2) + "°C",
                          style: TextStyle(
                              fontSize: screenSize.width/8, color: Colors.blueGrey[800],fontWeight: FontWeight.w500)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(widget.min.toString().substring(0,2) + "°C",
                                    style: TextStyle(
                                        fontSize: screenSize.width/16, color: Colors.blueGrey[800],fontWeight: FontWeight.w500)),
                                        Icon(Icons.arrow_drop_down,color: Colors.red[800],size:screenSize.width/16 ,)
                              ],
                            ),
                            Column(
                              children: [
                                Text("Hava Durumu",
                                    style: TextStyle(
                                        fontSize: screenSize.width/24, color: Colors.blueGrey[800],fontWeight: FontWeight.w500)),
                                Text(widget.status.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: screenSize.width/16, color: Colors.indigo[800],fontWeight: FontWeight.w500)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(widget.max.toString().substring(0,2) + "°C",
                                    style: TextStyle(
                                        fontSize: screenSize.width/16, color: Colors.blueGrey[800],
                                        fontWeight: FontWeight.w500)),
                                         Icon(Icons.arrow_drop_up,color: Colors.green[800],size:screenSize.width/16 ,)
                              ],
                            ),
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: screenSize.height / 10,
                                width: screenSize.height / 10,
                                child: Image.asset("assets/ay.png"),
                              ),
                              SizedBox(
                                width: screenSize.width / 60,
                              ),
                              Text(widget.night.toString().substring(0,2) + "°C",
                                  style: TextStyle(
                                      fontSize: screenSize.width / 16,
                                      color: Colors.grey[800],fontWeight: FontWeight.w500)),
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
                                    "Nem:" + "%" + widget.humidity,
                                    style: TextStyle(
                                        fontSize: screenSize.width / 16,
                                        color: Colors.grey[800],fontWeight: FontWeight.w500),
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
              )
            ],
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
        ],
      ),
    );
  }
}
