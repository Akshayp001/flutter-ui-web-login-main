import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class temp extends StatelessWidget {
  const temp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      width: 300,
      color: Colors.black,
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: DropdownButton<String>(
                    value: 'DEFAULT',
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {},
                    items: <String>['COMP', 'ENTC', 'MECH', 'CIVIL', 'IT', 'DEFAULT']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.orange),
                  ),
                  child: DropdownButton<String>(
                    value: 'NA',
                    icon: Icon(Icons.arrow_drop_down),
                    onChanged: (String? newValue) {},
                    items: <String>['FY', 'SY', 'TY', 'BE', 'NA']
                        .map<DropdownMenuItem<String>>(
                          (String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Container(
            width: double.infinity,
            height: 48.0,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: Text(
                'Apply',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    )
    );
  }
}