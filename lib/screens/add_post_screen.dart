//import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart' as geoc;
//import 'package:geocoding/geocoding.dart' as geoc ;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/resources/firestore_methods.dart';
import 'package:saf_user/utils/utility.dart';

import '../enums/trash_size.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'bottom_navigation_bar_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController description = TextEditingController();
  bool tookPictures = false;
  late PickedFile _deviceImage;
  Uint8List? _savedImage;
  DateTime? date;
  TrashSize size = TrashSize.wheelBarrow;
  bool onSelectBin = false;
  bool onSelectBarrow = false;
  bool onSelectTruck = false;
  late File showImage;
  Location location = Location();
  bool isLoading = false;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;
  String googleApikey = "AIzaSyDLZ6mTp1L5UXo20Mz614ycF5_-oJU-z58";

  // String locality = 'locality';
  // String subLocality = 'subLocality';

  String address = 'Home';
  String postalCode = 'postalCode';
  int index = 0;

  @override
  void dispose() {
    super.dispose();
    description.dispose();
  }

  void initState() {
    //convertToAddress(latitude, longitude, googleApikey); //call convert to address
    super.initState();
  }

  // Future<void> getAddress() async {
  //   List<geoc.Placemark> placemarks = await geoc.placemarkFromCoordinates(
  //       double.parse(_locationData.latitude.toString()),
  //       double.parse(_locationData.longitude.toString()));

  //   locality = placemarks.reversed.last.locality!;
  //   subLocality = placemarks.reversed.last.subLocality!;
  // }

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
   
        String apiurl = "https://maps.googleapis.com/maps/api/geocode/json?address=$lat,$long&key=$apikey";
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
  }

  Future<void> _takePictures() async {
    getUserLocationData().then((_) => convertToAddress(
        _locationData.latitude!, _locationData.longitude!, googleApikey));
    Uint8List file = await pickImage(ImageSource.camera);
    setState(() {
      tookPictures = true;
      _savedImage = file;
      showImage = File.fromRawPath(file);
    });
  }

  void postReport(
    String uid,
    String username,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      String trashSize = 'wheelBarrow';
      if (onSelectBin) {
        trashSize = 'BinBags';
      } else if (onSelectTruck) {
        trashSize = 'Truck';
      }
      String res = await FirestoreMethods().uploadPost(
          description.text,
          _savedImage!,
          uid,
          username,
          _locationData.latitude.toString(),
          _locationData.longitude.toString(),
          trashSize,
          address,
          postalCode);

      if (res == 'success') {
        setState(() {
          isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'You Are an Environment Hero!');
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BottomNavigationBarScreen()));
      } else {
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Report:',
          style: TextStyle(color: Colors.blue),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            tookPictures == false
                ? GestureDetector(
                    onTap: _takePictures,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                      child: Container(
                        height: 300,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(30, 5, 0, 5),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset('assets/images/add.png',
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: 300,
                    width: 350,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        border: Border.all(width: 1, color: Colors.blue),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: MemoryImage(_savedImage!),
                        )),
                  ),
            SizedBox(
              height: 20,
            ),
            isLoading
                ? const LinearProgressIndicator()
                : const Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 18, 0),
                    child: Expanded(
                      child: Text(
                        'Uploading more photos can increase chances of saving the environment!',
                        style: TextStyle(fontWeight: FontWeight.w200),
                        softWrap: false,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 1, 149, 211),
                        onPressed: () => postReport(user.uid, user.userName),
                        tooltip: 'Upload',
                        child: const Icon(Icons.upload, color: Colors.white),
                      ),
                      FloatingActionButton(
                        elevation: 0,
                        backgroundColor: const Color.fromARGB(255, 1, 149, 211),
                        onPressed: _takePictures,
                        tooltip: 'Add Image',
                        child:
                            const Icon(Icons.camera_alt, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: const [
                      Text(
                        'Size Estimate',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              size = TrashSize.binBags;
                            });
                          },
                          child: size == TrashSize.binBags
                              ? const Text('Bin Bag',
                                  style: TextStyle(color: Colors.blue))
                              : const Text('Bin Bag',
                                  style: TextStyle(color: Colors.grey))),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              size = TrashSize.wheelBarrow;
                            });
                          },
                          child: size == TrashSize.wheelBarrow
                              ? const Text('wheel Barrow',
                                  style: TextStyle(color: Colors.blue))
                              : const Text('wheel Barrow',
                                  style: TextStyle(color: Colors.grey))),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            size = TrashSize.truck;
                          });
                        },
                        child: size == TrashSize.truck
                            ? const Text('Truck',
                                style: TextStyle(color: Colors.blue))
                            : const Text('Truck',
                                style: TextStyle(color: Colors.grey)),
                      )
                    ],
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      splashColor: const Color.fromRGBO(252, 156, 84, 1),
                    ),
                    child: TextField(
                      cursorColor: Color.fromARGB(255, 24, 24, 24),
                      style: TextStyle(color: Color.fromARGB(255, 24, 24, 24)),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      controller: description,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
