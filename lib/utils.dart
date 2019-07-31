import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'widgets/radioButtons.dart';
import 'widgets/sliders.dart';
import 'package:bars_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

readJSON(String path) async {
  String json = await rootBundle.loadString(path);
  return jsonDecode(json);
}

getModels(List<String> labels, Map<String, dynamic> serverConfig) async {
  Map<String, dynamic> requestBody = {
    'db' : serverConfig['database']['db'],
    'collection' : serverConfig['database']['collection'],
    'labels' : labels
  };
  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http.post(serverConfig['address'] + '/retrain', headers: {"Content-Type": "application/json"}, body: jsonEncode(requestBody));
    models = jsonDecode(modelsResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    models = await readJSON(serverConfig['fallbacks']['models']);
  }
  return models;
}


/// Requests featureConfig from [serverAddress] with [databaseJSON] if available, else takes featureConfig from [fallbackFilename].
getFeatureConfig(Map<String, dynamic> serverConfig) async {
  Map<String, dynamic> requestBody = {
    'db' : serverConfig['database']['db'],
    'collection' : serverConfig['database']['collection'],
  };

  Map<String, dynamic> features;
  try {
    http.Response featureConfigResponse = await http.post(serverConfig['address'] + '/feature-config', headers: {"Content-Type": "application/json"}, body: jsonEncode(requestBody));
    features = jsonDecode(featureConfigResponse.body);
  }
  catch (e) { // something with the web request went wrong, use local file fallback
    features = await readJSON(serverConfig['fallbacks']['feature-config']);
  }
  return features;
}

/// Reads model, feature and label configs.
readData() async {
  Map<String, dynamic> serverConfig = await readJSON('assets/server.conf');
  Map<String, dynamic> localFallbacks = serverConfig["fallbacks"];
  String serverAddress = serverConfig["address"];

  // load features
  /*
  getFeatureConfig(serverAddress, jsonEncode(serverConfig["database"], localFallbacks["feature-config"])
  */
  Map<String, dynamic> features =
      await readJSON(localFallbacks["feature-config"]);

  // load labels
  Map<String, dynamic> labelsConfig = await readJSON('assets/labels.conf');
  Map<String, dynamic> labels = labelsConfig["label_titles"];
  String labelsJSON = jsonEncode({"labels": labelsConfig["labels"]});

  // load model coefficients and means
  Map<String, dynamic> models;
  try {
    http.Response modelsResponse = await http
        .post(serverAddress + '/models',
            headers: {"Content-Type": "application/json"}, body: labelsJSON)
        .timeout(const Duration(seconds: 1));
    models = jsonDecode(modelsResponse.body);
  } catch (e) {
    // something with the web request went wrong, use local file fallback
    models = await readJSON(localFallbacks["models"]);
  }
  return [models, features, labels, serverConfig];
}

/// For all features in [featureConfig]: Sets radio button or slider to mean.
generateDefaultInputValues(featureConfig) {
  Map<String, dynamic> defaultInputs = {};
  featureConfig.forEach((k, v) {
    int mean = v["mean"].round();

    //Button selection needs int, slider needs double.
    if (v["choices"] != null) {
      defaultInputs[k] = mean;
    } else {
      defaultInputs[k] = mean.toDouble();
    }
  });
  return defaultInputs;
}

/// Deactivates all sliders and radio buttons in [featureConfig].
deactivateInputFields(featureConfig) {
  Map<String, bool> activeInputFields = {};
  featureConfig.forEach((k, v) {
    activeInputFields[k] = false;
  });
  return activeInputFields;
}

/// Creates either a radio button or a slider for [feature].
/// [context] is the widget that the input widget is on(i.e., the widget that has to rebuild on state change).
buildInputWidget(MyHomePageState homePageState, State context,
    MapEntry<String, dynamic> feature) {
  if (feature.value["choices"] != null) {
    return getRadioButtonInputRow(homePageState, context, feature);
  } else if (feature.value["slider_min"] != null) {
    return getSliderInputRow(homePageState, context, feature);
  } else {
    throw new Exception("Input Widget not supported: " + feature.key);
  }
}

/// Returns the color for a [factor]. [factor] should be > 0.
Color computeColorByFactor(double factor) {
  final List<Color> colorGradient = [
    Colors.lightGreen,
    Colors.amber,
    Colors.orange,
    Colors.red
  ];

  factor = factor > 1 ? 1 : factor;
  return colorGradient[(factor * (colorGradient.length - 1)).round().toInt()];
}

/// Returns color for active and inactive input field.
getActivityColor (MyHomePageState homePageState, String featureKey){
  return homePageState.activeInputFields[featureKey]
      ? Colors.blue
      : Colors.grey;
}
