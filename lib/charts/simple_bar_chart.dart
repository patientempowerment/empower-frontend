import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:bars_frontend/utils.dart';
import 'package:tuple/tuple.dart';

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<Tuple2<String, dynamic>, String>> labelValues;
  final bool animate;

  SimpleBarChart(this.labelValues, {this.animate = true});

  @override Widget build(BuildContext context) {
    return charts.BarChart(
      labelValues,
      animate: animate,
    );
  }
}

List<Tuple2<String, dynamic>> mapToTupleList(Map<String, dynamic> map){
  List<Tuple2<String, dynamic>> list = [];
  map.forEach((k,v) => list.add(Tuple2<String, dynamic>(k, v)));
  return list;
}

mapChartData(Map<String, dynamic> labelValues){
    final List<dynamic> colorGradient = [
      charts.Color.fromHex(code: "#8BC24A"),
      charts.Color.fromHex(code: "#FEC007"),
      charts.Color.fromHex(code: "#FE9800"),
      charts.Color.fromHex(code: "#FE5722"),
      charts.Color.fromHex(code: "#F34336"),
    ];
  var data = mapToTupleList(labelValues);
  return [ //TODO: make a utils func that creates charts.series from maps
    charts.Series<Tuple2<String, dynamic>, String>(
      id: 'barChart',
      colorFn: (Tuple2<String, dynamic> tuple, __) => colorGradient[
      ((colorGradient.length - 1) * tuple.item2).round().toInt()],
      domainFn: (Tuple2<String, dynamic> tuple, _) => tuple.item1,
      measureFn: (Tuple2<String, dynamic> tuple, _) => tuple.item2,
      data: data,
    )
  ];
}
