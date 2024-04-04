import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce_flutter/colors.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  String status = "";
  Uri url = Uri.parse("");
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

      String apiUrl =
          '${domainController.text}/wp-json/wc/v3/data?consumer_key=${keyController.text}&consumer_secret=${secretController.text}';

      setState(() {
        isLoading = true;
        isStatus = false;
        url = Uri.parse(apiUrl);
      });

      print(apiUrl);
      var response = await http.get(Uri.parse(apiUrl));

      setState(() {
        statusCode = response.statusCode;
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
      status = "";
      isStatus = false;
      statusCode = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 120,
        backgroundColor: primaryColor,
        title: Column(
          children: [
            SizedBox(height: 10),
            Image.asset(
              "assets/images/logo.png",
              width: 250,
            ),
            SizedBox(height: 10),
            const Text("NewOrder - WooCommerce Connection Check",
                style: TextStyle(color: Colors.white, fontFamily: 'OpenSans')),
          ],
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: ResponsiveBreakpoints.of(context).isDesktop
                    ? 550
                    : MediaQuery.of(context).size.width),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 224, 224, 224),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.only(left: 20, right: 20),
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05,
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                SizedBox(
                  width: 500,
                  child: Directionality(
                    textDirection:
                        TextDirection.rtl, // Set text direction to RTL
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      controller: domainController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'הכנס דומיין :',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 500,
                  child: Directionality(
                    textDirection:
                        TextDirection.rtl, // Set text direction to RTL
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      controller: keyController,
                      obscureText: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(),
                        labelText: 'הכנס מפתח :',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 500,
                  child: Directionality(
                    textDirection:
                        TextDirection.rtl, // Set text direction to RTL
                    child: TextField(
                      textDirection: TextDirection.ltr,
                      controller: secretController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        // border: OutlineInputBorder(),
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
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                            backgroundColor:
                                MaterialStateProperty.all(primaryColor),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    8.0), // Adjust the radius as needed
                              ),
                            )),
                        onPressed: () {
                          setState(() {
                            statusCode = null;
                          });
                          checkConnection();
                        },
                        child: const Text(
                          "בדוק חיבור",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                const SizedBox(height: 20),
                isLoading
                    ? const SpinKitRing(
                        color: primaryColor,
                        size: 50.0,
                      )
                    : Column(
                        children: [
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
                  visible: isStatus ?? false,
                  child: Container(
                    margin:
                        EdgeInsets.only(bottom: 20), // Add margin bottom here
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue[400]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      onPressed: () => _launchUrl(url),
                      child: Text(
                        "קישור לבדיקה",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 100),
                child: const Text(
                  '2024 Ⓒ כל הזכויות שמורות לניו אורדר בע"מ',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _showMyDialog(String text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: const Text('שגיאה!'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(text),
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
