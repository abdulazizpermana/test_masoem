import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _getStateList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.topCenter,
            margin: const EdgeInsets.only(bottom: 100, top: 100),
            child: const Text(
              'Al Qur`an',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _mySurah,
                        iconSize: 30,
                        icon: (null),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: const Text('Surah'),
                        onChanged: (String? newValue) {
                          setState(() {
                            debugPrint('movieTitle: $newValue');
                            _mySurah = newValue;
                            _getCitiesList();
                          });
                        },
                        items: surahList.map((listSurah) {
                          return DropdownMenuItem(
                            value: listSurah,
                            child: Text(listSurah),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        value: _myAyat,
                        iconSize: 30,
                        // icon: (null),
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                        hint: const Text('Select Surah'),
                        onChanged: (String? newValue) {
                          setState(() {
                            _myAyat = newValue;
                          });
                        },
                        items: ayatList?.map((item) {
                              return DropdownMenuItem(
                                child: Text(item['numberOfVerses']),
                                value: item['id'].toString(),
                              );
                            }).toList() ??
                            [],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Arab',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Terjemahan',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
          ),
        ],
      ),
    );
  }

//*Call API
  List<String> surahList = [];
  String? _mySurah;

  String baseUrlSurah = 'https://api.quran.gading.dev/surah';
  Future<String?> _getStateList() async {
    await http.get(
      Uri.parse(baseUrlSurah),
      headers: {"Accept": "application/json"},
    ).then((response) {
      List<dynamic> listDatarespon = json.decode(response.body)['data'];
      for (var element in listDatarespon) {
        surahList.add(element['listSurah']);
      }
      setState(() {});
    });
    return null;
  }

  List? ayatList;
  String? _myAyat;

  String ayatInfoUrl = 'https://api.quran.gading.dev/numberOfVerses';
  Future<String?> _getCitiesList() async {
    await http
        .post(
      Uri.parse(ayatInfoUrl),
    )
        .then((response) {
      List<dynamic> listDatarespon = json.decode(response.body)['data'];
      for (var element in listDatarespon) {
        surahList.add(element['numberOfVerses']);
      }
      setState(() {});
    });
    return null;
  }
}
