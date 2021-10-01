import 'package:flutter/material.dart';
import 'dart:math';

class Interests extends StatefulWidget {
  static const routeName = "/interest";

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final interestController = TextEditingController();
  List interests = [];

  void addInterest(String interest) {
    interests.add(interest);
  }

  @override
  Widget build(BuildContext context) {
    var c = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: SizedBox(height: 100),
            ),
            Container(
              child: Text(
                "Enter your interests",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Row(
              children: [
                Container(
                  height: 0.15 * c,
                  width: 250,
                  padding: EdgeInsets.only(left: 0.027 * c, right: 0.027 * c),
                  margin: EdgeInsets.only(bottom: 0.054 * c),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0.0405 * c)),
                    border: Border.all(color: Color.fromRGBO(141, 131, 252, 1), width: 0.0108 * c),
                  ),
                  child: TextField(
                    scrollPhysics: BouncingScrollPhysics(),
                    maxLines: null,
                    controller: interestController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Interests :)",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 0.054 * c, left: 20),
                    width: 50,
                    height: 0.15 * c,
                    color: Colors.amber,
                    child: Center(child: Text("Add")),
                  ),
                  onTap: () {
                    setState(() {
                      addInterest(interestController.text);
                      interestController.text = "";
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 100),
            Container(
              child: Text(
                "Entered Interests: ",
                style: TextStyle(fontSize: 20),
              ),
            ),
            interests.length == 0
                ? Container(
                    child: Text("No interests selected!"),
                  )
                : Expanded(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      children: [
                        ...(interests as List).map((e) {
                          return SelectedInterests(e);
                        }).toList()
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class SelectedInterests extends StatelessWidget {
  String interest;

  SelectedInterests(this.interest);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.orange[200],
      ),
      margin: EdgeInsets.only(left: 10, right: 20, top: 20, bottom: 20),
      child: Center(child: Text(interest)),
    );
  }
}
