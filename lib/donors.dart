import 'package:boodbank/waveindicator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class DonorPage extends StatefulWidget {
  const DonorPage({super.key});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  List<Map<String, dynamic>> donors = [];
  List<String> bloodGroup = [];
  late Widget _child;

  @override
  void initState() {
    _child = const WaveIndicator();
    getDonors();
    super.initState();
  }

  Future<void> getDonors() async {
    await FirebaseFirestore.instance
        .collection('User Details')
        .get()
        .then((QuerySnapshot<Map<String, dynamic>> querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        for (int i = 0; i < querySnapshot.docs.length; ++i) {
          donors.add(querySnapshot.docs[i].data());
        }
        print(donors);
      }
    });
    setState(() {
      _child = Mywidget();
    });
  }

  showdialogfunction(String bloodGroup) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Column(
              children: [
                Text(
                  bloodGroup,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          );
        });
  }

  Widget Mywidget() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Donors",
          style: TextStyle(
              fontSize: 50, fontFamily: "Raleway", color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            FontAwesomeIcons.reply,
            color: Colors.white,
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: Container(
          height: 800.0,
          width: double.infinity,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView.builder(
                itemCount: donors.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(donors[index]["name"] ?? ""),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              showdialogfunction(
                                  donors[index]["Blood Group "] ?? "");
                            },
                            icon: const Icon(
                              Icons.message,
                              color: Color.fromARGB(1000, 221, 46, 68),
                            ),
                          ),
                        )
                      ],
                    ),
                    leading: CircleAvatar(
                      backgroundColor: const Color.fromARGB(100, 221, 46, 68),
                      child: Text(
                        donors[index]["Blood Group"] ?? "",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        launch('tel:  9861393634');
                      },
                      icon: const Icon(Icons.phone),
                      color: const Color.fromARGB(1000, 221, 46, 68),
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }
}
