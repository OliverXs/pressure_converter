import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'shared/constants/matrix.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Conversão de Pressão',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Conversão'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final MatrixUnitys _matrixUnitys = MatrixUnitys();
  final TextEditingController _firstController = TextEditingController();
  final TextEditingController _secondController = TextEditingController();

  int firstUnityIndex = 0;
  int secondUnityIndex = 0;
  String firstUnity = "Bar";
  String secondUnity = "Bar";

  setFirstUnity(int index) {
    firstUnityIndex = index;
    firstUnity = providerUnity(index);
    setState(() {});
  }

  setSecondUnity(int index) {
    secondUnityIndex = index;
    secondUnity = providerUnity(index);
    setState(() {});
  }

  calc() {
    double k =
        _matrixUnitys.constantsOfPressure[firstUnityIndex][secondUnityIndex];
    double x = double.tryParse(_firstController.text)!;
    double result = x * k;
    _secondController.text = result.toString();
  }

  calc2() {
    double k =
        _matrixUnitys.constantsOfPressure[secondUnityIndex][firstUnityIndex];
    double x = double.tryParse(_secondController.text)!;
    double result = x * k;
    _firstController.text = result.toString();
  }

  switchUnity() {
    int unityIndex = firstUnityIndex;
    String unityText = firstUnity;
    firstUnity = secondUnity;
    secondUnity = unityText;
    firstUnityIndex = secondUnityIndex;
    secondUnityIndex = unityIndex;
    setState(() {});
  }

  @override
  void initState() {
    setFirstUnity(firstUnityIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.title)),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          height: size.height * .88,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * .02,
                  ),
                  child: TextFormField(
                      controller: _firstController,
                      onChanged: (val) {
                        calc();
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[-\d\.]")),
                      ],
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        fillColor: CupertinoColors.systemGrey4,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorStyle: null,
                        errorMaxLines: null,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200,
                                child: CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: firstUnityIndex),
                                    backgroundColor: CupertinoColors.white,
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      setFirstUnity(index);
                                      calc();
                                    },
                                    children: [
                                      displayPickerText("Bar"),
                                      displayPickerText("Pa"),
                                      displayPickerText("KPa"),
                                      displayPickerText("kgf/cm²"),
                                      displayPickerText("mmHg"),
                                      displayPickerText("PSI"),
                                      displayPickerText("inH2O"),
                                      displayPickerText("inHg"),
                                    ]),
                              );
                            });
                      },
                      child: Container(
                          height: size.height * .08,
                          width: size.width / 3,
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(firstUnity)),
                    ),
                    GestureDetector(
                      onTap: () {
                        switchUnity();
                        calc();
                      },
                      child: Container(
                          height: size.height * .08,
                          width: size.width / 3,
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Center(
                            child: Image.asset(
                              "assets/icons/convert-arrow.png",
                              height: size.height * .05,
                            ),
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200,
                                child: CupertinoPicker(
                                    scrollController:
                                        FixedExtentScrollController(
                                            initialItem: secondUnityIndex),
                                    backgroundColor: CupertinoColors.white,
                                    itemExtent: 40,
                                    onSelectedItemChanged: (index) {
                                      setSecondUnity(index);
                                      calc();
                                    },
                                    children: [
                                      displayPickerText("Bar"),
                                      displayPickerText("Pa"),
                                      displayPickerText("KPa"),
                                      displayPickerText("kgf/cm²"),
                                      displayPickerText("mmHg"),
                                      displayPickerText("PSI"),
                                      displayPickerText("inH2O"),
                                      displayPickerText("inHg"),
                                    ]),
                              );
                            });
                      },
                      child: Container(
                          height: size.height * .08,
                          width: size.width / 3,
                          color: Colors.blue,
                          alignment: Alignment.center,
                          child: Text(secondUnity)),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * .02,
                  ),
                  child: TextFormField(
                      controller: _secondController,
                      onChanged: (val) {
                        calc2();
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r"[-\d\.]")),
                      ],
                      style: const TextStyle(fontSize: 20),
                      decoration: const InputDecoration(
                        fillColor: CupertinoColors.systemGrey4,
                        filled: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        errorStyle: null,
                        errorMaxLines: null,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Center displayPickerText(String text) {
    return Center(
      child: Text(text),
    );
  }

  String providerUnity(int index) {
    switch (index) {
      case 0:
        return "Bar";
      case 1:
        return "Pa";
      case 2:
        return "KPa";
      case 3:
        return "kgf/cm²";
      case 4:
        return "mmHg";
      case 5:
        return "PSI";
      case 6:
        return "inH2O";
      case 7:
        return "inHg";
      default:
        return "";
    }
  }
}
