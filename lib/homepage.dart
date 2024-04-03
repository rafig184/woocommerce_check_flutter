import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController domainController = TextEditingController();
  TextEditingController keyController = TextEditingController();
  TextEditingController secretController = TextEditingController();
  int? statusCode;
  String? status;
  Uri? url;
  bool? isStatus;
  bool isLoading = false;

  Future<void> checkConnection() async {
    try {
      String domainText = domainController.text.trim();
      String keyText = keyController.text.trim();
      String secretText = secretController.text.trim();
      if (domainText.isEmpty) {
        _showMyDialog("אנא הכנס דומיין..");
        return;
      }
      if (keyText.isEmpty) {
        _showMyDialog("אנא הכנס מפתח..");
        return;
      }
      if (secretText.isEmpty) {
        _showMyDialog("אנא הכנס סיסמה..");
        return;
      }
      setState(() {
        isLoading = true;
        isStatus = false;
      });
      String apiUrl =
          '${domainController.text}/wp-json/wc/v3/data?consumer_key=${keyController.text}&consumer_secret=${secretController.text}';

      var response = await http.get(Uri.parse(apiUrl));
      setState(() {
        statusCode = response.statusCode;
        url = Uri.parse(apiUrl);
      });

      if (response.statusCode != 200) {
        throw Error;
      } else {
        setState(() {
          isStatus = true;
          status = 'חיבור תקין!! קוד סטטוס : ${statusCode}';
        });
      }
    } catch (error) {
      if (statusCode == null) {
        setState(() {
          isStatus = true;
          status = 'חיבור מוגבל, אנא בדוק תקינות בקישור';
        });
      } else {
        setState(() {
          isStatus = true;
          status = 'שגיאת התחברות!! קוד סטטוס : ${statusCode}';
        });
      }
      print(status);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void cleaAll() {
    domainController.clear();
    keyController.clear();
    secretController.clear();
    setState(() {
      isStatus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("NewOrder - WooCommerce Connection Check",
            style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 224, 224, 224),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.3,
          right: MediaQuery.of(context).size.width * 0.3,
          bottom: MediaQuery.of(context).size.height * 0.39,
          top: MediaQuery.of(context).size.height * 0.05,
        ),
        child: Column(
          children: [
            SizedBox(height: 80),
            SizedBox(
              width: 500,
              child: Directionality(
                textDirection: TextDirection.rtl, // Set text direction to RTL
                child: TextField(
                  controller: domainController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'הכנס דומיין :',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: Directionality(
                textDirection: TextDirection.rtl, // Set text direction to RTL
                child: TextField(
                  controller: keyController,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'הכנס מפתח :',
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 500,
              child: Directionality(
                textDirection: TextDirection.rtl, // Set text direction to RTL
                child: TextField(
                  controller: secretController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'הכנס סיסמה :',
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => cleaAll(),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.red[400]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              8.0), // Adjust the radius as needed
                        ),
                      )),
                  child: const Text(
                    "נקה",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                          ),
                        )),
                    onPressed: () => checkConnection(),
                    child: const Text(
                      "בדוק חיבור",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const SpinKitRing(
                    color: Color.fromARGB(255, 7, 156, 255),
                    size: 50.0,
                  )
                : Column(
                    children: [
                      SizedBox(height: 10),
                      Visibility(
                        visible: isStatus ??
                            false, // Show the Text widget only if isStatus is true
                        child: SizedBox(
                          child: Text(status ?? '',
                              style: TextStyle(fontSize: 20)),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Visibility(
              visible: isStatus ??
                  false, // Show the Text widget only if isStatus is true
              child: SizedBox(
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo[300]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust the radius as needed
                          ),
                        )),
                    onPressed: () => _launchUrl(url),
                    child: Text("קישור לבדיקה",
                        style: TextStyle(color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl, // Set text direction to RTL
          child: AlertDialog(
            title: const Text('שגיאה'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                      text), // Text direction will follow the Directionality widget
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('אישור'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    domainController.dispose();
    keyController.dispose();
    secretController.dispose();
  }
}
