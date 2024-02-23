import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_solution_challenge/screens/home_screens/building_risk/damage_predictor.dart';
import 'building_info.dart'; // Import your model

class BuildingInfoForm extends StatefulWidget {
  @override
  _BuildingInfoFormState createState() => _BuildingInfoFormState();
}

class _BuildingInfoFormState extends State<BuildingInfoForm> {
  final _formKey = GlobalKey<FormState>();
  PredictionService predictionService = PredictionService();
  BuildingInfo _buildingInfo = BuildingInfo(
    countFloors: 0,
    ageBuilding: 0,
    plinthAreaSqFt: 0.0,
    heightFt: 0.0,
    landSurfaceCondition: '',
    foundationType: '',
    groundFloorType: '',
    otherFloorType: '',
    position: '',
    planConfiguration: '',
    damageGrade: -1,
  );


  // Controllers
  final TextEditingController _countFloors = TextEditingController();
  final TextEditingController _ageBuilding = TextEditingController();
  final TextEditingController _plinthAreaSqFt = TextEditingController();
  final TextEditingController _heightFt = TextEditingController();

  String? _landSurfaceCondition;
  String? _foundationType;
  String? _groundFloorType;
  String? _otherFloorType;
  String? _position;
  String? _planConfiguration;

  final List<String> _landSurfaceConditions = ['Flat', 'Moderate slope', 'Steep slope'];
  final List<String> _foundationTypes = ['Mud mortar-Stone/Brick', 'Bamboo/Timber', 'RC', 'Other'];
  final List<String> _floorTypes = ['Not applicable', 'Mud', 'Wood', 'Other'];
  final List<String> _positions = ['Not attached', 'Attached-1 side', 'Attached-2 sides', 'Attached-3 sides'];
  final List<String> _planConfigurations = ['Rectangular', 'Square', 'L-shape', 'T-shape', 'Other'];


  @override
  void dispose() {
    _countFloors.dispose();
    _ageBuilding.dispose();
    _plinthAreaSqFt.dispose();
    _heightFt.dispose();
    // Dispose other controllers
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[300],
        title:
        Text(
            "Building Info",
            style: GoogleFonts.albertSans(
              color: Colors.grey[900],
              fontSize: 29,
              fontWeight: FontWeight.bold,
              height: 1.355,
            )
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context)=> SimpleDialog(
                      title: Text("Building Risk Controller"),
                      contentPadding: const EdgeInsets.all(20.0),
                      backgroundColor: Colors.blueGrey,
                      children: [
                        Text("Controls the risk of the building with given information."),
                        TextButton(
                          onPressed:() {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Close",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      ],

                    )
                );
              },
              child: const Icon(
                Icons.info_outline,
                color: Colors.black87,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _countFloors,
                  decoration: InputDecoration(labelText: 'Floor count'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter floor count';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _ageBuilding,
                  decoration: InputDecoration(labelText: 'Building Age'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Building Age';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _plinthAreaSqFt,
                  decoration: InputDecoration(labelText: 'plinth area'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter plinth area';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _heightFt,
                  decoration: InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter height';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _landSurfaceCondition,
                  hint: Text("Land Surface Condition"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _landSurfaceCondition = newValue;
                    });
                  },
                  items: _landSurfaceConditions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _foundationType,
                  hint: Text("Foundation Type:"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _foundationType = newValue;
                    });
                  },
                  items: _foundationTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _groundFloorType,
                  hint: Text("Ground Floor Type"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _groundFloorType = newValue;
                    });
                  },
                  items: _floorTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _otherFloorType,
                  hint: Text("other floor type"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _otherFloorType = newValue;
                    });
                  },
                  items: _floorTypes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _position,
                  hint: Text("Position"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _position = newValue;
                    });
                  },
                  items: _positions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _planConfiguration,
                  hint: Text("Plan of house"),
                  onChanged: (String? newValue) {
                    setState(() {
                      _planConfiguration = newValue;
                    });
                  },
                  items: _planConfigurations.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  validator: (value) => value == null ? 'İlçe seçimi zorunludur' : null,
                ),
                // Add other TextFormFields
              ],
            ),
          ),
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            // Updating the _buildingInfo instance
            setState(() {
              _buildingInfo.countFloors = int.tryParse(_countFloors.text) ?? 0;
              _buildingInfo.ageBuilding = int.tryParse(_ageBuilding.text) ?? 0;
              _buildingInfo.plinthAreaSqFt = double.tryParse(_plinthAreaSqFt.text) ?? 0.0;
              _buildingInfo.heightFt = double.tryParse(_heightFt.text) ?? 0.0;

              // Update other fields similarly
              _buildingInfo.landSurfaceCondition = _landSurfaceCondition ?? '';
              _buildingInfo.foundationType = _foundationType ?? '';
              _buildingInfo.groundFloorType = _groundFloorType ?? '';
              _buildingInfo.otherFloorType = _otherFloorType ?? '';
              _buildingInfo.position = _position ?? '';
              _buildingInfo.planConfiguration = _planConfiguration ?? '';
            });

            // Here you can process the data, such as sending it to a server or using it in your ML model
            print("Building Information updated: ${_buildingInfo.toJson()}");
            // Model yükleme ve tahmin yapma
            await predictionService.loadModel();
            final prediction = await predictionService.predict(_buildingInfo);

            // Tahmin sonucunu göster
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Prediction Result'),
                  content: Text('The predicted damage grade is: $prediction'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              }
            );
            // Opsiyonel: Başarılı güncelleme sonrası kullanıcıya bildirim
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Building information saved successfully!')),
            );
          }
        },
        tooltip: 'Save',
        child: Icon(Icons.save),
        backgroundColor: Colors.black,
      ),
    );
  }
}
