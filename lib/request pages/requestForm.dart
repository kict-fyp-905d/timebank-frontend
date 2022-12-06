import 'package:csc_picker/csc_picker.dart';
import 'package:csc_picker/model/select_status_model.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:testfyp/bin/client_service_request.dart';
import 'package:testfyp/components/constants.dart';
import 'package:testfyp/custom%20widgets/customHeadline.dart';
import 'package:testfyp/custom%20widgets/theme.dart';
import 'package:testfyp/extension_string.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import '../bin/common.dart';

//map API
//https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6

class RequestForm extends StatefulWidget {
  RequestForm({Key? key}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  //store user input
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _mediaController = TextEditingController();
  final _dateControllerDisplay = TextEditingController();
  final _dateController = TextEditingController();
  final _timeLimitController = TextEditingController();

  final DateTime _dateTime = DateTime.now();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<String> mediaList = [];
  List<String> listCategories = <String>[
    'Arts, Crafts & Music',
    'Business Services',
    'Community Activities',
    'Companionship',
    'Education',
    'Help at Home',
    'Recreation',
    'Transportation',
    'Wellness',
  ];

  late String address;
  late String location1;
  late DateTime? newDate;
  late TimeOfDay? newTime;

  late String countryValue = '';
  late String stateValue = '';
  late String cityValue = '';

  late bool isLocationFetched;

  @override
  void initState() {
    isLocationFetched = false;
    _categoryController.text = listCategories[2];
    // TODO: implement initState
    super.initState();
  }

  //get geo location
  //Flutter method to get current user latitude & longitude location
  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //Method to get full address from latitude & longitude co-ordinates (lat long to address)
  Future<void> GetAddressFromLatLong(Position position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      address =
          '${place.street}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}';
      // print('State: ${place.administrativeArea}');
      // print("City: ${place.locality}");
      // // print(place.country);
      // print(place);

      setState(() {
        //print(countryValue);
        countryValue = place.country.toString();
        cityValue = place.locality.toString();
        stateValue = place.administrativeArea.toString();
        isLocationFetched = true;
        // _latitudeController.text = position.latitude.toString();
        // _longitudeController.text = position.longitude.toString();
        _locationController.text = address;
        //print(isLocationFetched);
      });
      context.showSnackBar(message: 'Location details added!!');
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }

    //print(Address);
  }

  // Future<void> GetLatLongfromAddress(String location) async {
  //   try {
  //     List<Location> locations = await locationFromAddress(location);
  //     setState(() {
  //       // _latitudeController.text = locations[0].latitude.toString();
  //       // _longitudeController.text = locations[0].longitude.toString();
  //       //_locationController.text = Address;
  //     });
  //     context.showSnackBar(message: 'Location details added!!');
  //   } catch (e) {
  //     context.showErrorSnackBar(message: e.toString());
  //   }

  //   //sprint(locations[0].latitude);
  //   //print(placemarks);
  //   // Placemark place = locations[0];
  //   // Address =
  //   //     '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   //print(Address);
  // }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _locationController.dispose();
    _rateController.dispose();
    _mediaController.dispose();

    super.dispose();
  }

  _addmedia(String media) {
    setState(() {
      mediaList.insert(0, media);
    });
  }

  _deleteMedia(String media) {
    setState(() {
      mediaList.removeWhere((element) => element == media);
    });
  }

  _isMediaEmpty(dynamic media) {
    if (media.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Request Form'),
          // backgroundColor: Color.fromARGB(255, 127, 17, 224),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Title'),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Enter Title'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          _titleController.text == '') {
                        return 'Please enter title...';
                      }
                      return null;
                    },
                    // onFieldSubmitted: (value) {
                    //   reqList[0]['Title'] = value;
                    // },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Description'),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter description of the job',
                      //prefixIcon: Icon(Icons.map)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter description...';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Date & Time'),
                  ),
                  Row(
                    children: [
                      // Expanded(
                      //   child: TextFormField(
                      //     enabled: false,
                      //     controller: _dateControllerDisplay,
                      //     decoration: InputDecoration(
                      //         border: OutlineInputBorder(),
                      //         hintText: 'Pick a date'),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter date...';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Icon(
                        Icons.calendar_month,
                        color: themeData1().primaryColor,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                newDate = await showDatePicker(
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: themeData1()
                                              .primaryColor, // header background color
                                          onPrimary:
                                              Colors.white, // header text color
                                          onSurface:
                                              Colors.black, // body text color
                                        ),
                                        // textButtonTheme: TextButtonThemeData(
                                        //   style: TextButton.styleFrom(
                                        //     foregroundColor:
                                        //         Colors.red, // button text color
                                        //   ),
                                        // ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialDate: _dateTime,
                                  firstDate: DateTime(_dateTime.year,
                                      _dateTime.month, _dateTime.day),
                                  lastDate: _dateTime.add(Duration(days: 365)),
                                );

                                setState(() {
                                  _dateControllerDisplay.text =
                                      '${newDate?.day}-${newDate?.month}-${newDate?.year}';
                                  //newDate.
                                  // _dateControllerDisplay.text =
                                  //     newDate.toString();
                                  _dateController.text = newDate.toString();
                                  //print(_dateController.text);
                                  //;
                                });
                                // _addmedia(_mediaController.text);
                                // _mediaController.clear();
                              },
                              child: Text('Pick a Date')),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      // Expanded(
                      //   child: TextFormField(
                      //     enabled: false,
                      //     controller: _dateControllerDisplay,
                      //     decoration: InputDecoration(
                      //         border: OutlineInputBorder(),
                      //         hintText: 'Pick a date'),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter date...';
                      //       }
                      //       return null;
                      //     },
                      //   ),
                      // ),
                      Icon(
                        Icons.alarm,
                        color: themeData1().primaryColor,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                newTime = await showTimePicker(
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: themeData1()
                                              .primaryColor, // header background color
                                          onPrimary:
                                              Colors.white, // header text color
                                          onSurface:
                                              Colors.black, // body text color
                                        ),
                                        // textButtonTheme: TextButtonThemeData(
                                        //   style: TextButton.styleFrom(
                                        //     foregroundColor:
                                        //         Colors.red, // button text color
                                        //   ),
                                        // ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                  context: context,
                                  initialTime: TimeOfDay.now(),

                                  // initialDate: _dateTime,
                                  // firstDate: DateTime(_dateTime.year,
                                  //     _dateTime.month, _dateTime.day),
                                  // lastDate: _dateTime.add(Duration(days: 365)), initialTime: null,
                                );

                                setState(() {
                                  try {
                                    _dateControllerDisplay.text =
                                        'Date: ${newDate?.day}-${newDate?.month}-${newDate?.year} | Time: ${newTime?.hour}:${newTime?.minute}';
                                    _dateController.text = newDate!
                                        .add(Duration(
                                            hours: newTime!.hour,
                                            minutes: newTime!.minute))
                                        .toString();
                                  } catch (e) {
                                    context.showErrorSnackBar(
                                        message: 'Pick a date first...');
                                  }

                                  // '${newDate?.year}-${newDate?.month}-${newDate?.day} ${newTime?.hour}:${newTime?.minute}:00.000';
                                  //print(_dateController.text);
                                  //;
                                });
                                // _addmedia(_mediaController.text);
                                // _mediaController.clear();
                              },
                              child: Text('Pick a Time')),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    enabled: false,
                    controller: _dateControllerDisplay,
                    decoration: InputDecoration(
                        errorStyle: TextStyle(
                          color: Colors.red, // or any other color
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Date & Time'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please pick a date & time...';
                      }
                      // else if (newDate!.hour == 0 || newDate!.minute == 0) {
                      //   return 'Pick a time';
                      // }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Category'),
                  ),
                  Container(
                    alignment: Alignment.center,
                    //padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        )),
                    child: DropdownButton<String>(
                      underline: Container(
                        height: 0,
                      ),
                      iconEnabledColor: Theme.of(context).primaryColor,
                      value: _categoryController.text,
                      items: listCategories.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                e,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _categoryController.text = value.toString();
                          //print(_genderController.text);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Location'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        'Enter address of the job or get current location'),
                  ),
                  TextFormField(
                    controller: _locationController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        // helperText:
                        //     'Latitude and longitude of the location will be\nautomatically added',
                        hintText: 'Enter location address'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter location...';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),
                  CSCPicker(
                    // showCities: true,

                    defaultCountry: DefaultCountry.Malaysia,
                    disableCountry: true,
                    // currentState: 'Negeri Sembilan',
                    // currentCountry: 'Malaysia',
                    layout: Layout.vertical,
                    dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        )),
                    cityDropdownLabel: 'Pick a City',
                    stateDropdownLabel: 'Pick a State',

                    // dropdownItemStyle: TextStyle,
                    // stateSearchPlaceholder: ,
                    // dropdownHeadingStyle: ,

                    onCountryChanged: (value) {
                      setState(() {
                        countryValue = value;
                        //_locationController.text = ''
                      });
                    },
                    onStateChanged: (value) {
                      setState(() {
                        stateValue = value.toString();
                        _latitudeController.text = stateValue;
                      });
                    },
                    onCityChanged: (value) {
                      setState(() {
                        cityValue = value.toString();
                        _longitudeController.text = cityValue;
                      });
                    },
                  ),
                  Row(
                    children: [
                      // Expanded(
                      //   child: ElevatedButton(
                      //       onPressed: () async {
                      //         GetLatLongfromAddress(_locationController.text);
                      //       },
                      //       child: Text('Enter Address')),
                      // ),
                      // SizedBox(width: 5),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () async {
                              Position position =
                                  await _getGeoLocationPosition();
                              GetAddressFromLatLong(position);
                            },
                            child: Text('Get current location')),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CustomHeadline(heading: 'Country & State & City'),
                  // ),
                  // TextFormField(
                  //   controller: _locationController,
                  //   enabled: false,
                  //   decoration: InputDecoration(
                  //       errorStyle: TextStyle(
                  //         color: Colors.red, // or any other color
                  //       ),
                  //       border: OutlineInputBorder(),
                  //       labelText: 'Address'),
                  //   // validator: (value) {
                  //   //   if (value == null || value.isEmpty) {
                  //   //     return 'Please enter location...';
                  //   //   }
                  //   //   return null;
                  //   // },
                  // ),
                  // SizedBox(height: 15),

                  // // SelectState(
                  // //   //dropdownColor: themeData1().primaryColor,
                  // //   // style: ,
                  // //   onCountryChanged: (value) {
                  // //     setState(() {
                  // //       countryValue = value;
                  // //     });
                  // //   },
                  // //   onStateChanged: (value) {
                  // //     setState(() {
                  // //       stateValue = value;
                  // //     });
                  // //   },
                  // //   onCityChanged: (value) {
                  // //     setState(() {
                  // //       cityValue = value;
                  // //     });
                  // //   },
                  // // ),
                  // // SizedBox(height: 8),
                  // TextFormField(
                  //   controller: _latitudeController,
                  //   enabled: false,
                  //   decoration: InputDecoration(
                  //     errorStyle: TextStyle(
                  //       color: Colors.red, // or any other color
                  //     ),
                  //     border: OutlineInputBorder(),
                  //     labelText: 'State',
                  //     //prefixIcon: Icon(Icons.map)
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Tap "Enter Address" to obtain latitude';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 15),
                  // TextFormField(
                  //   controller: _longitudeController,
                  //   enabled: false,
                  //   decoration: InputDecoration(
                  //       errorStyle: TextStyle(
                  //         color: Colors.red, // or any other color
                  //       ),
                  //       border: OutlineInputBorder(),
                  //       labelText: 'City'),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Tap "Enter Address" to obtain longitude';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  // SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Attachment'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _mediaController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter attachment'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                            onPressed: () {
                              if (_mediaController.text.length == 0) {
                                context.showErrorSnackBar(
                                    message:
                                        'You have not entered any attachment..');
                              } else {
                                _addmedia(_mediaController.text);
                                _mediaController.clear();
                              }
                            },
                            child: Icon(Icons.add)),
                      )
                    ],
                  ),
                  _isMediaEmpty(mediaList)
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('You have not entered any attachment'),
                        )
                      : SizedBox(
                          height: 60,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: mediaList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Text(mediaList[index]
                                          .toString()
                                          .titleCase()),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            _deleteMedia(
                                                mediaList[index].toString());
                                          },
                                          icon: Icon(
                                            Icons.remove_circle_outline,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                ),
                              );
                            },
                          )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Time Limit'),
                  ),
                  TextFormField(
                    controller: _timeLimitController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        helperText: 'Time required to finish the request',
                        hintText: 'Enter time limit (hours)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter time limit';
                      }
                      return null;
                    },
                    // onFieldSubmitted: (value) {
                    //   reqList[0]['Title'] = value;
                    // },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomHeadline(heading: 'Rate'),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _rateController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter Rate',
                              helperText:
                                  'Make sure you have enough \$ to pay'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter rate..';
                            }
                            return null;
                          },
                        ),
                      ),
                      // Expanded(
                      //   child: TextFormField(
                      //     controller: _titleController,
                      //     keyboardType: TextInputType.number,
                      //     decoration: InputDecoration(
                      //         border: OutlineInputBorder(),
                      //         hintText: 'Enter time limit (hours)'),
                      //     validator: (value) {
                      //       if (value == null || value.isEmpty) {
                      //         return 'Please enter time limit';
                      //       }
                      //       return null;
                      //     },
                      //     // onFieldSubmitted: (value) {
                      //     //   reqList[0]['Title'] = value;
                      //     // },
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('\$ time/hour'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () async {
                        final user = supabase.auth.currentUser!.id;
                        //final _userCurrent = getCurrentUser(user);
                        //print(_userCurrent);
                        // print(stateValue == 'null');
                        if (_latitudeController.text == 'null') {
                          context.showErrorSnackBar(message: 'Pick a state..');
                        } else if (_longitudeController.text == 'null') {
                          context.showErrorSnackBar(message: 'Pick a city..');
                        } else if (_formKey.currentState!.validate()) {
                          var rate = double.parse(
                              _rateController.text); //convert to double
                          var time = double.parse(_timeLimitController.text);

                          _submitJobForm(
                              _titleController.text,
                              _descriptionController.text,
                              _latitudeController.text,
                              _longitudeController.text,
                              _locationController.text,
                              rate,
                              mediaList,
                              user,
                              _categoryController.text,
                              time,
                              _dateController.text);
                        }
                      },
                      child: const Text('Create Request')),
                ],
              ),

              // SizedBox(
              //   height: 20,
              // ),
            ),
          ),
        ));
  }

  Future<void> _submitJobForm(
      String title,
      String description,
      String latitude,
      String longitude,
      String locName,
      double rate,
      List<String> media,
      String requestor,
      String category,
      double timeLimit,
      String date) async {
    try {
      await ClientServiceRequest(Common().channel).createServiceRequest(
          title,
          description,
          latitude,
          longitude,
          locName,
          rate,
          media,
          requestor,
          category,
          timeLimit,
          date);
      //print(test);
      //dprint(test.toProto3Json());
      context.showSnackBar(message: 'Job Created');
      Navigator.of(context).pop();
    } on GrpcError catch (e) {
      context.showErrorSnackBar(message: '${e.message}');
      print(e.toString());
    } catch (e) {
      context.showErrorSnackBar(message: e.toString());
    }
  }
}
