import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/resources/firestore_methods.dart';
import 'package:saf_user/utils/utility.dart';
import 'package:location/location.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:flutter/services.dart';

import 'bottom_navigation_bar_screen.dart';

class RequestPickUpScreen extends StatefulWidget {
  final List trashType;
  final String trashSize;
  final String lati;
  final String longi;
  final String address;
  final String postalCode;

  RequestPickUpScreen(
      {super.key,
      required this.trashType,
      required this.trashSize,
      required this.lati,
      required this.longi, 
      required this.address, 
      required this.postalCode});

  @override
  State<RequestPickUpScreen> createState() => _RequestPickUpScreenState();
}

class _RequestPickUpScreenState extends State<RequestPickUpScreen> {
  Location location = Location();
  bool _isLoading = false;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  Future<void> getUserLocationData() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    _locationData = await location.getLocation();
    print(_locationData.toString());
  }

  void pickUprequest(String uid, String userName) async {
    try {
      print('mera ghar');
      setState(() {
        _isLoading = true;
      });
      String res = await FirestoreMethods().requestPickUp(
          widget.trashType,
          uid,
          userName,
          widget.lati,
          widget.longi,
          widget.trashSize,
          widget.address,
          widget.postalCode);

      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Request Sent');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationBarScreen()));
      } else {
        showSnackBar(context, res);
      }
    } catch (err) {
      showSnackBar(context, err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Instructions'),
      ),
      body: _isLoading
          ? const LinearProgressIndicator(
              color: Colors.blue,
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(17.0),
                  child: Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Please get ${widget.trashType.length} bags',
                          style: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        const Text('Your Selected Trash Types were:'),
                        Text(widget.trashType.toString()),
                        const Text(
                            'Please sort them according to the following rules:'),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider()
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          const Text(
                            'Organic/Biodegradable',
                          ),
                          const SizedBox(
                            width: 70,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    Color.fromARGB(255, 131, 255, 195),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Green Bag'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          const Text(
                            'Metal/glass Wsate',
                          ),
                          const SizedBox(
                            width: 101,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    Color.fromARGB(255, 110, 110, 110),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Black Bag'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          const Text(
                            'Electronic Waste',
                          ),
                          const SizedBox(
                            width: 115,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    Color.fromARGB(255, 132, 177, 255),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text('Blue Bag'),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          const Text(
                            'Plastic/Paper Waste',
                          ),
                          const SizedBox(
                            width: 89,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // ignore: prefer_const_literals_to_create_immutables
                            children: [
                              const CircleAvatar(
                                radius: 7,
                                backgroundColor:
                                    Color.fromARGB(255, 255, 229, 134),
                              ),
                              const Text('White Bag'),
                            ],
                          ),
                        ],
                      ),
                      Divider()
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text('Send Request'),
                      SizedBox(
                        width: 20,
                      ),
                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 1, 149, 211),
                        onPressed: () => pickUprequest(user.uid, user.userName),
                        tooltip: 'mera ghar',
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
