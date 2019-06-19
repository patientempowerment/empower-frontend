import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'charts/simple_bar_chart.dart';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Empowerment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Patient Empowerment'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class Inputs {
  DoubleWrapper age = new DoubleWrapper(18.0);
  DoubleWrapper height = new DoubleWrapper(120.0);
  DoubleWrapper weight = new DoubleWrapper(30);
  DoubleWrapper diastolicBloodPressure = new DoubleWrapper(30.0);
  DoubleWrapper systolicBloodPressure = new DoubleWrapper(70.0);
  DoubleWrapper noOfCigarettesPerDay = new DoubleWrapper(0.0);
  DoubleWrapper noOfCigarettesPreviouslyPerDay = new DoubleWrapper(0.0);
  Sex sex;
  AlcoholFrequency alcoholFrequency;
  YesNoWrapper currentlySmoking = new YesNoWrapper(null);
  YesNoWrapper neverSmoked = new YesNoWrapper(null);
  YesNoWrapper coughOnMostDays = new YesNoWrapper(null);
  YesNoWrapper asthma = new YesNoWrapper(null);
  YesNoWrapper copd = new YesNoWrapper(null);
  YesNoWrapper diabetes = new YesNoWrapper(null);
  YesNoWrapper previouslySmoked = new YesNoWrapper(null);
  YesNoWrapper sputumOnMostDays = new YesNoWrapper(null);
  YesNoWrapper wheezeInChestInLastYear = new YesNoWrapper(null);
  YesNoWrapper tuberculosis = new YesNoWrapper(null);
}

String exampleResponse =
    "\{\"COPD\":0.3,\"asthma\":1.0,\"diabetes\":0.0,\"tuberculosis\":0.7\}";

getIllnessProbs(Inputs inputs) {
  Map<String, dynamic> jsonResponse = jsonDecode(exampleResponse);

  return [
    IllnessProb('COPD', jsonResponse['COPD']),
    IllnessProb('Asthma', jsonResponse['asthma']),
    IllnessProb('Diabetes', jsonResponse['diabetes']),
    IllnessProb('Tuberculosis', jsonResponse['tuberculosis']),
  ];
}

class MyHomePageState extends State<MyHomePage> {
  Inputs input = new Inputs();

  List<charts.Series<IllnessProb, String>> mapChartData(
      List<IllnessProb> data) {
    return [
      charts.Series<IllnessProb, String>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.indigo.shadeDefault,
        domainFn: (IllnessProb sales, _) => sales.illness,
        measureFn: (IllnessProb sales, _) => sales.probability,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(40.0),
        child: Row(
          children: [
            Expanded(
              child: ListView(
                children: [
                  getSexRadioButtons(this),
                  getAgeSlider(this),
                  getHeightSlider(this),
                  getWeightSlider(this),
                  getDiastolicBloodPressureSlider(this),
                  getSystolicBloodPressureSlider(this),
                  getAlcoholFrequencyRadioButtons(this),
                  getCurrentlySmokingRadioButtons(this),
                  getNeverSmokedRadioButtons(this),
                  getPreviouslySmokedRadioButtons(this),
                  getNoOfCigarettesPerDaySlider(this),
                  getNoOfCigarettesPreviouslyPerDaySlider(this),
                  getWheezeInChestInLastYearRadioButtons(this),
                  getCoughOnMostDaysRadioButtons(this),
                  getSputumOnMostDaysRadioButtons(this),
                  getCOPDRadioButtons(this),
                  getAsthmaRadioButtons(this),
                  getDiabetesRadioButtons(this),
                  getTuberculosisRadioButtons(this),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: SimpleBarChart(mapChartData(getIllnessProbs(input))),
            ),
          ],
        ),
      ),
    );
  }
}
