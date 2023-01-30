import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<LoginPage> {
  FocusNode focusNode = FocusNode();
  String hintText = "+36";
  final _telnumberController = TextEditingController();
  final _preferenceService = PreferenceService();

  @override
  void initState() {
    super.initState();
    _populateField();
    focusNode.addListener(() {
      if (focusNode.hasFocus && _telnumberController.text.isEmpty) {
        hintText = '';
      }
      setState(() {});
    });
  }

  void _populateField() async {
    final tel_number = await _preferenceService.getTelephoneNumber();
    setState(() {
      _telnumberController.text = tel_number;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Okos mérleg"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Add meg a mérleg telefonszámát!',
            ),
            TextField(
              controller: _telnumberController,
              focusNode: focusNode,
              keyboardType: TextInputType.number,
              maxLength: 12,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: hintText,
                )
              ),
            ElevatedButton(
                onPressed: () {
                  _preferenceService.saveTelephoneNumber(_telnumberController.text);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyHomePage(title: 'Okos mérleg')),
                  );
                },
                child: const Text("Ok"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class PreferenceService {
  Future saveTelephoneNumber(String text) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setString("telnumber", text);
    print("Saved telephone number");
  }

  Future getTelephoneNumber() async {
    final preferences = await SharedPreferences.getInstance();

    final telnumber = preferences.getString('telnumber');
    return telnumber;
  }
}
