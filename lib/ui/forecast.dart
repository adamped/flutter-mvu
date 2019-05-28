import 'package:flutter/material.dart';
import '../io/darksky.dart' as darksky;

class ForecastPage extends StatefulWidget {
  ForecastPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ForecastPageState createState() => _ForecastPageState();
}

class ForecastModel
{
  const ForecastModel(this.temperature, this.loading);
  final double temperature;
  final bool loading;
}

class _ForecastPageState extends State<ForecastPage> {

  ForecastModel model = ForecastModel(0, false);

  void updateModel(Function update) => setState(() { model = update(); });

  void _updateTemperature(Future<double> getForecast(), Function update) async {

    update(() => ForecastModel(0, true));

    var forecast = await getForecast();

    update(() => ForecastModel(forecast, false));
  }

  @override
  Widget build(BuildContext context) {
    return ForecastPageUI.buildUI(context, 
                                  widget.title,
                                  () => _updateTemperature(darksky.getForecast, (func) => updateModel(func)),
                                  model);
  }
}

class ForecastPageUI
{
  static buildUI(BuildContext context,
                 String title,
                 Function update,
                 ForecastModel model)
  {
      return Scaffold(
            appBar: AppBar(
              title: Text(title),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: model.loading ? ( <Widget>[new CircularProgressIndicator()]) :
                  (<Widget>[
                    Text(
                      'The current temperature is:',
                    ),
                    Text(
                      '${model.temperature} °F',
                      style: Theme.of(context).textTheme.display1,
                    ),
                  ]),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: update,
              tooltip: 'Update',
              child: Icon(Icons.update),
            ),
          );
  }
}
