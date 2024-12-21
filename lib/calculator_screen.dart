
import 'package:flutter/material.dart';

import 'button_values.dart';


class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1='';// . 0-9
  String operand='';// + - / *
  String number2='';// . 0-9

  @override
  Widget build(BuildContext context) {
    final screenSize=MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
      child: Column(children: [
        //output
        Expanded(
          child: SingleChildScrollView(
            reverse: true,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.all(16),
              child: Text(
                "$number1$operand$number2" .isEmpty?"0"
                    :"$number1$operand$number2",
                style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
              ),
               textAlign: TextAlign.end,
              ),
            ),
          ),
        ),
        //buttons
       Wrap(
         children: Btn.buttonValues
             .map(
                 (value) => SizedBox(
                   width: value==Btn.n0?screenSize.width/2: (screenSize.width/4),
                   height: screenSize.width/5,
                     child: buildButton(value)),
         )
             .toList(),
       )
      ],
    ),
      ),
    );
  }
  Widget buildButton(value){
    return  Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white38),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(value,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
              fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
 //###################
void onBtnTap(String value){
    if(value==Btn.del){
      delete();
      return ;
    }
if(value==Btn.clr){
  clearAll();
  return;
}
if(value==Btn.per){
  convertToPercentage();
      return;
}
if(value==Btn.calculate){
  calculate();
  return;
}

    appendValue(value);
}
//###################
  //calculates the result
  void calculate(){
    if(number1.isEmpty) return;
    if(operand.isEmpty) return;
    if(number2.isEmpty) return;

    final double num1=double.parse(number1);
    final double num2=double.parse(number2);

    var result=0.0;
    switch (operand){
      case Btn.add:
        result=num1+num2;
        break;
      case Btn.subtract:
        result=num1-num2;
        break;
      case Btn.multiply:
        result=num1*num2;
        break;
      case Btn.divide:
        result=num1/num2;
        break;
      default:
    }
    setState(() {
      number1="$result";
      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);//remove last 2 character
      }
      operand="";
      number2="";
    });
  }




//##################
//clears all output
  void clearAll(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }
//################
  //convert output to %
  void convertToPercentage(){
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      //calculate before conversion
      calculate();
    }
    if(operand.isNotEmpty){
      //cannot be converted
      return;
    }
    final number=double.parse(number1);
    setState(() {
      number1="${(number / 100)}";
      operand="";
      number2="";
    });
  }

//##################
  //delete one from the end
void delete(){
    if(number2.isNotEmpty){
      //123=>12
      number2=number2.substring(0,number2.length-1);
    }else if(operand.isNotEmpty){
      operand="";
    }else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {

    });
}

//######################
void appendValue(String value){
  //if is operand and not "."
  if(value!=Btn.dot && int.tryParse(value)==null){
    //operand pressed
    if(operand.isNotEmpty&&number2.isNotEmpty){
      // TODO calculate the equation before assigning new operand
      calculate();
    }
    operand=value;
  }else if(number1.isEmpty || operand.isEmpty){
    //check if value is "."  ex:number1='3.6'
    if(value==Btn.dot && number1.contains(Btn.dot)) return;
    if(value==Btn.dot && (number1.isEmpty || number1==Btn.n0)){
      // number1='' or '0'
      value="0.";
    }
    number1+=value;
  }else if(number2.isEmpty || operand.isNotEmpty){
    // number2='3.6'
    if(value==Btn.dot && number2.contains(Btn.dot)) return;
    if(value==Btn.dot && (number2.isEmpty || number2==Btn.n0)){
      // number2='' or '0'
      value="0.";
    }
    number2+=value;
  }

  setState(() {});

}


 //###################
  Color getBtnColor(value){
    return [Btn.del,Btn.clr].contains(value)
        ?Colors.blueGrey
        :[
      Btn.per,
      Btn.multiply,
      Btn.add,
      Btn.subtract,
      Btn.divide,
      Btn.calculate,
    ].contains(value)
        ?Colors.indigo.shade400
        : Colors.black87;
  }
}
