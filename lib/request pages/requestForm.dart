import 'package:flutter/material.dart';
import 'package:testfyp/bin/client_service_request.dart';
import 'package:testfyp/components/constants.dart';

import '../bin/common.dart';

//map API
//https://levelup.gitconnected.com/how-to-add-google-maps-in-a-flutter-app-and-get-the-current-location-of-the-user-dynamically-2172f0be53f6

class RequestForm extends StatefulWidget {
  RequestForm({Key? key}) : super(key: key);

  @override
  State<RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<RequestForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _locationController = TextEditingController();
  final _rateController = TextEditingController();
  final _mediaController = TextEditingController();

  List<String> media = ['Test media'];
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

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _categoryController.text = listCategories[2];
    // TODO: implement initState
    super.initState();
  }

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
            child: ListView(
              children: [
                // SizedBox(
                //   height: 20,
                // ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Title'),
                ),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  // onFieldSubmitted: (value) {
                  //   reqList[0]['Title'] = value;
                  // },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Description'),
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
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Categories'),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  child: Text('Location'),
                ),
                TextFormField(
                  controller: _latitudeController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Latitude',
                    //prefixIcon: Icon(Icons.map)
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _longitudeController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Longitude'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter Location'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Attachment'),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _mediaController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter attachment'),
                        // validator: (value) {
                        //   if (value == null || value.isEmpty) {
                        //     return 'Please enter some text';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {}, child: Icon(Icons.add)),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Rate'),
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
                            helperText: 'Make sure you have enough \$ to pay'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter rate..';
                          }
                          return null;
                        },
                      ),
                    ),
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
                      if (_formKey.currentState!.validate()) {
                        var rate = double.parse(
                            _rateController.text); //convert to double
                        media.add(_mediaController.text); //add to array
                        _submitJobForm(
                          _titleController.text,
                          _descriptionController.text,
                          _latitudeController.text,
                          _longitudeController.text,
                          _locationController.text,
                          rate,
                          media,
                          user,
                          //_user!.id.toString()
                        );

                        //'291b79a7-c67c-4783-b004-239cb334804d'
                        context.showSnackBar(message: 'Job Created');
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text('Create Request')),
              ],
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
      String requestor) async {
    // final _user = await supabase.auth.currentUser;
    // print(_user!.id);
    await ClientServiceRequest(Common().channel).createServiceRequest(title,
        description, latitude, longitude, locName, rate, media, requestor);
  }
}
