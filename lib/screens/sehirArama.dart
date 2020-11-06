import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:havadurumu/model/sehirData.dart';
import 'package:havadurumu/screens/homeScreen.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class SearchDeneme extends StatefulWidget {

  @override
  _SearchDenemeState createState() => _SearchDenemeState();
}

class _SearchDenemeState extends State<SearchDeneme> {
  
  List<SehirData> _notes = List<SehirData>();
  List<SehirData> _notesForDisplay = List<SehirData>();

  Future<List<SehirData>> fetchNotes() async {
    var url = 'https://raw.githubusercontent.com/isml/KonuTakip/master/iller.json';
    var response = await http.get(url);
    
    var notes = List<SehirData>();
    
    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        notes.add(SehirData.fromJson(noteJson));
      }
    }
    return notes;
  }

  @override
  void initState() {
    fetchNotes().then((value) {
      setState(() {
        _notes.addAll(value);
        _notesForDisplay = _notes;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Şehir Seçme '),centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return index == 0 ? _searchBar() : _listItem(index-1);
        },
        itemCount: _notesForDisplay.length+1,
      )
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Ara...'
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            _notesForDisplay = _notes.where((note) {
              var noteTitle = note.name.toString().toLowerCase();
              return noteTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return InkWell(
      onTap: (){
        //print(_notesForDisplay[index].name.toString());
        //_ilAyarla(_notesForDisplay[index].name.toString());
        String secilmisIl=(_notesForDisplay[index].name).toString().toLowerCase();
        print(secilmisIl);
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(secilmisSehir:secilmisIl)));
      },
          child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0, bottom: 32.0, left: 16.0, right: 16.0),
          child: 
              
              Text(
                _notesForDisplay[index].name.toString(),
                style: TextStyle(
                  color: Colors.black
                
                ),
              ),
           
        ),
      ),
    );
  }

  Future<void> _ilAyarla(String secilenil) async {
    final prefs = await SharedPreferences.getInstance();
    //int lastStartupNumber = await _getIntFromSharedPref();
    
    await prefs.setString('secilenil', secilenil.toLowerCase());
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>HomeScreen(secilmisSehir:secilenil)));
  }

 
}