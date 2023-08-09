import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';

class ExpWidget extends StatelessWidget {
  String title;
  bool fun;
  List<Widget> content;

  ExpWidget({required this.title, required this.fun, required this.content});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width > 600
        ? 600
        : MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height < 860
        ? 860
        : MediaQuery.of(context).size.height;
    return AnimatedContainer(
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutBack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: height * 0.015, horizontal: width * 0.04),
            height: fun ? height * 0.25 : height * 0.075,
            width: ((MediaQuery.of(context).size.width - width) / 2.5),
            child: SingleChildScrollView(
              child: Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                              fontSize: (width < 350 ? 350 : width) * 0.03,
                              color: Colors.white60),
                        ),
                        Icon(
                          fun
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down_sharp,
                          color: Colors.white60,
                          size: (width < 350 ? 350 : width) * 0.055,
                        )
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    SingleChildScrollView(child: Column(children: content,)),
                    // Center(
                    //   child: Text(
                    //     Content,
                    //     style: TextStyle(
                    //         fontSize: (width < 350 ? 350 : width) * 0.03,
                    //         color: Colors.white60),
                    //   ),
                    // )
                  ]),
            ),
            // color: Colors.red.withOpacity(0.5),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.orange.withOpacity(0.2),
                      Color.fromARGB(255, 191, 2, 62).withOpacity(0.2)
                    ]),
                borderRadius: BorderRadius.circular(12)),
          )
        ],
      ),
    );
  }
}
