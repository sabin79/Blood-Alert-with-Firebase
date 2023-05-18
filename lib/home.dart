import 'package:boodbank/camp.dart';
import 'package:boodbank/donors.dart';
import 'package:boodbank/login.dart';
import 'package:boodbank/map.dart';
import 'package:boodbank/requestblood.dart';
import 'package:boodbank/waveindicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? currentUser;
  String? _name, _bloodgroup, _email;
  late Widget _child;

  Future<void> _fetchUserInfo() async {
    Map<String, dynamic> userInfo;
    User currentUser = FirebaseAuth.instance.currentUser!;

    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("User Details")
        .doc(currentUser.uid)
        .get();

    userInfo = snapshot.data as Map<String, dynamic>;

    setState(() {
      _name = userInfo['name'];
      _email = userInfo['Email'];
      _bloodgroup = userInfo['Blood-Group'];
      _child = _myWidget();
    });
  }

  Future<void> _loadCurrentUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUser = user;
      });
    }
  }

  @override
  void initState() {
    _child = const WaveIndicator();
    _loadCurrentUser();
    _fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return _child;
  }

  Widget _myWidget() {
    return Scaffold(
      backgroundColor: const Color.fromARGB(1000, 221, 46, 68),
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 60,
            fontFamily: "Raleway",
            color: Colors.white,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              accountName: Text(
                currentUser == null ? "" : _name!,
                style: const TextStyle(
                  fontSize: 22.0,
                ),
              ),
              accountEmail: Text(currentUser == null ? "" : _email!),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  currentUser == null ? "" : _bloodgroup!,
                  style: const TextStyle(
                    fontSize: 30.0,
                    color: Colors.black54,
                    fontFamily: 'Raleway',
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text("Home"),
              leading: const Icon(
                FontAwesomeIcons.home,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              title: const Text("Blood Donors"),
              leading: const Icon(
                FontAwesomeIcons.handshake,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const DonorPage()));
              },
            ),
            ListTile(
              title: const Text("Blood Request"),
              leading: const Icon(
                FontAwesomeIcons.burn,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const RequestBlood()));
              },
            ),
            ListTile(
              title: const Text("Campaigns"),
              leading: const Icon(
                FontAwesomeIcons.ribbon,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const CampPage()));
              },
            ),
            ListTile(
              title: const Text("Log-Out"),
              leading: const Icon(
                FontAwesomeIcons.signOutAlt,
                color: Color.fromARGB(1000, 221, 46, 68),
              ),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            Loginpage(login: FirebaseAuth.instance)));
              },
            )
          ],
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(35),
          topRight: Radius.circular(35),
        ),
        child: Container(
          height: 800,
          width: double.infinity,
          color: Colors.white,
          child: const MapView(),
        ),
      ),
    );
  }
}