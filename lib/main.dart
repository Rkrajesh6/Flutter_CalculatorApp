import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    title: "Simple Intrest Calculator App",
    home: SIForm(),
    theme: ThemeData(brightness: Brightness.dark, primaryColor: Colors.indigo),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {

  var _formKey = GlobalKey<FormState>();

  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimumPadding = 5.0;
  var _currentItemSelected = "";

  @override
  void initState() {
    super.initState();
    _currentItemSelected = _currencies[0];
  }

  TextEditingController principalControler = TextEditingController();
  TextEditingController rateControler = TextEditingController();
  TextEditingController termControler = TextEditingController();
  var displayResult = '';

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
//      resizeToAvoidBottomInset:false,
      appBar: AppBar(
        title: Text("Simple Intrest App"),
      ),
      //body: Container(
      body: Form(
        key: _formKey,
        //margin: EdgeInsets.all(_minimumPadding * 2),
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: principalControler,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (String value){
                        if(value.isEmpty) {
                          return "Please enter principal amount";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'pricipal',
                          hintText: 'Enter the principal e.g. 12000',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      style: textStyle,
                      controller: rateControler,
                      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                      validator: (String value){
                        if(value.isEmpty){
                          return "Please enter rate";
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Rate of Intrest',
                          hintText: 'In percent',
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                            color: Colors.yellowAccent,
                            fontSize: 15.0,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: termControler,
                          inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                          validator: (String value){
                            if(value.isEmpty){
                              return "Please enter the rate.";
                            }
                          },
                          decoration: InputDecoration(
                              labelText: 'Term',
                              labelStyle: textStyle,
                              hintText: 'Time in years',
                              errorStyle: TextStyle(
                                color: Colors.yellowAccent,
                                fontSize: 15.0,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentItemSelected,
                          onChanged: (String newValueSelected) {
                            _onDropDownItemSelected(newValueSelected);
                          },
                        ))
                      ],
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text(
                              "Calculate",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                if(_formKey.currentState.validate()){
                                  this.displayResult = _calculateTotalReturns();
                                }
                              });
                            },
                          ),
                        ),
                        Container(
                          width: _minimumPadding * 2,
                        ),
                        Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).accentColor,
                            child: Text(
                              "Reset",
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _onReset();
                              });
                            },
                          ),
                        )
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Text(
                    displayResult,
                    style: textStyle,
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage("images/money.png");
    Image image = Image(
      image: assetImage,
      width: 125.0,
      height: 125.0,
    );

    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }

  String _calculateTotalReturns() {
    double pricipal = double.parse(principalControler.text);
    double rate = double.parse(rateControler.text);
    double term = double.parse(termControler.text);

    double totalIntrest = pricipal + (pricipal * rate * term) / 100;
    String result =
        "After $term years, your investment will be worth $totalIntrest $_currentItemSelected";
    return result;
  }

  void _onReset() {
    principalControler.text = '';
    rateControler.text = '';
    termControler.text = '';
    displayResult = '';
    _currentItemSelected = _currencies[0];
  }
}
