import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:saf_user/screens/request_pickup_screen.dart';

class PickUpScreen extends StatefulWidget {
  PickUpScreen({super.key});

  @override
  State<PickUpScreen> createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  Location location = Location();
  bool onSelectBin = false;

  bool onSelectBarrow = true;

  bool onSelectTruck = false;

  bool onSelectOrganic = false;

  bool onSelectPlastic = false;

  bool onSelectMetal = false;

  bool onSelectElectronic = false;

  bool _navigate = false;

  bool _isLoading = false;

  String trashSize = 'WheelBarrow';

  List<String> TrashType = [];

  String googleApikey = "AIzaSyDLZ6mTp1L5UXo20Mz614ycF5_-oJU-z58";

  String address = 'Home';
  String postalCode = 'postalCode';
  int index = 0;

  int getAddress(String address) {
    for (int i = 0; i < address.length; i++) {
      if (address[i] == ',') {
        index = i;
        break;
      }
    }
    return index;
  }

  convertToAddress(double lat, double long, String apikey) async {
    Dio dio = Dio(); //initilize dio package

    String apiurl =
        "https://maps.googleapis.com/maps/api/geocode/json?address=$lat,$long&key=$apikey";
    Response response = await dio.get(apiurl); //send get request to API URL

    if (response.statusCode == 200) {
      //if connection is successful
      Map data = response.data; //get response data
      if (data["status"] == "OK") {
        //if status is "OK" returned from REST API
        if (data["results"].length > 0) {
          //if there is atleast one address
          Map firstresult = data["results"][0]; //select the first address

          address = firstresult["formatted_address"]; //get the address

          int idx = data["results"][0]['address_components'].length;
          print(data["results"][0]['address_components'][idx - 1]);

          getAddress(address);

          address = address.substring(index + 1, address.length);

          postalCode =
              data["results"][0]['address_components'][idx - 1]['long_name'];

          //you can use the JSON data to get address in your own format

          setState(() {
            //update UI
          });
        }
      } else {
        print(data["error_message"]);
      }
    } else {
      print("error while fetching geoconding data");
    }
  }

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
    setState(() {
      _navigate = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Pick Up',
              style: TextStyle(color: Colors.blue),
            )),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isLoading
                ? Container(
                    width: double.infinity,
                    child: const Center(
                      child: LinearProgressIndicator(
                        color: Colors.blue,
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Text('Trash SIze',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              trashSize = 'Truck';
                              setState(() {
                                onSelectTruck = true;
                                onSelectBin = false;
                                onSelectBarrow = false;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 200,
                                  height: 150,
                                  child: onSelectTruck
                                      ? Card(
                                          color: Colors.blueAccent[100],
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Truck.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Truck.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text('Fits in a truck'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  trashSize = 'BinBag';
                                  setState(() {
                                    onSelectTruck = false;
                                    onSelectBin = true;
                                    onSelectBarrow = false;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 80,
                                      child: onSelectBin
                                          ? Card(
                                              color: Colors.blueAccent[100],
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/Bag.png',
                                                  //fit: BoxFit.fitHeight
                                                ),
                                              ),
                                            )
                                          : Card(
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/Bag.png',
                                                  //fit: BoxFit.fitHeight
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Fits in Bin Bag',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  trashSize = 'wheelBarrow';
                                  setState(() {
                                    onSelectTruck = false;
                                    onSelectBin = false;
                                    onSelectBarrow = true;
                                  });
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      width: 130,
                                      height: 80,
                                      child: onSelectBarrow
                                          ? Card(
                                              color: Colors.blueAccent[100],
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/wheelBarrow.png',
                                                  //fit: BoxFit.fitHeight
                                                ),
                                              ),
                                            )
                                          : Card(
                                              //elevation: 0,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.asset(
                                                  'assets/images/wheelBarrow.png',
                                                  //fit: BoxFit.fitHeight
                                                ),
                                              ),
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      'Fits in wheelBarrow',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(17.0),
                        child: Text('Trash Type',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onSelectOrganic = !onSelectOrganic;
                                if (onSelectOrganic) {
                                  TrashType.add('Organic');
                                } else {
                                  TrashType.removeWhere(
                                      (element) => element == 'Organic');
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 170,
                                  height: 120,
                                  child: onSelectOrganic
                                      ? Card(
                                          color: Colors.blueAccent[100],
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Organic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Organic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Organic',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onSelectPlastic = !onSelectPlastic;
                                if (onSelectPlastic) {
                                  TrashType.add('Paper/Plastic');
                                } else {
                                  TrashType.removeWhere(
                                      (element) => element == 'Paper/Plastic');
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 170,
                                  height: 120,
                                  child: onSelectPlastic
                                      ? Card(
                                          color: Colors.blueAccent[100],
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Plastic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/Plastic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Paper/Plastic',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onSelectMetal = !onSelectMetal;
                                if (onSelectMetal) {
                                  TrashType.add('Metal/Glass');
                                } else {
                                  TrashType.removeWhere(
                                      (element) => element == 'Metal/Glass');
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 170,
                                  height: 120,
                                  child: onSelectMetal
                                      ? Card(
                                          color: Colors.blueAccent[100],
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/metal.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/metal.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'metal/Glass',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                onSelectElectronic = !onSelectElectronic;
                                if (onSelectElectronic) {
                                  TrashType.add('Electronic');
                                } else {
                                  TrashType.removeWhere(
                                      (element) => element == 'Electronic');
                                }
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  width: 170,
                                  height: 120,
                                  child: onSelectElectronic
                                      ? Card(
                                          color: Colors.blueAccent[100],
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/electronic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        )
                                      : Card(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.asset(
                                              'assets/images/electronic.png',
                                              //fit: BoxFit.fitHeight
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                const Text(
                                  'Electronic',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLoading = true;
                                  getUserLocationData().then((_) =>
                                      convertToAddress(
                                          _locationData.latitude!,
                                          _locationData.longitude!,
                                          googleApikey));
                                  _isLoading = false;
                                });
                              },
                              child: Row(
                                children: const [
                                  Text('Confirm',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blue)),
                                  SizedBox(
                                    width: 20,
                                  ),
                                ],
                              )),
                          TextButton(
                              onPressed: () {
                                getUserLocationData();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RequestPickUpScreen(
                                              trashSize: trashSize,
                                              trashType: TrashType,
                                              lati: _locationData.latitude
                                                  .toString(),
                                              longi: _locationData.longitude
                                                  .toString(),
                                                  postalCode:postalCode, 
                                                  address: address,
                                            )));
                              },
                              child: _navigate
                                  ? const Text('Next',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.blue))
                                  : const SizedBox(
                                      height: 0,
                                      width: 0,
                                    ))
                        ],
                      )
                    ],
                  )));
  }
}
