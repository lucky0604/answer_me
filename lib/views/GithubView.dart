import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class GithubView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Github Repository', style: TextStyle(fontSize: 20)),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey.withOpacity(0.1)),
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SelectableText('https://github.com/lucky0604'),
          ),
          SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.withOpacity(0.1),
                ),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SelectableText('Email: lucky_soft@163.com')),
            SizedBox(
              width: 20,
            ),
            Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.1), width: 1),
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.grey.withOpacity(0.1)),
                padding: EdgeInsets.only(left: 10, right: 10),
                child: SelectableText('Wechat: lucky0604'))
          ])
        ])));
  }
}
