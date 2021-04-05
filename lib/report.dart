import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'util.dart';
import 'FileController.dart';

class Report {
  String _title;
  String _course;
  String _updateDate;
  String _reportThumbnailPath;
  //DateTime _date;
  String _targetMonth;
  bool _isCompleted;

  Report() {
    _title = 'タイトルA';
    _course = '数学（2年）';
    _updateDate = '2020/9/30';
    _reportThumbnailPath = 'images/content/report/report.png';
    _targetMonth = '1月';
    _isCompleted = false;
  }

  String getTitle() {
    return _title;
  }

  void setTitle(String title) {
    _title = title;
  }

  String getCourse() {
    return _course;
  }

  String getUpdateDate() {
    return _updateDate;
  }

  String getReportThumbnailPath() {
    return _reportThumbnailPath;
  }

  String getTargetMonth() {
    return _targetMonth;
  }

  bool isCompleted() {
    return _isCompleted;
  }

  void setCompleted(bool isComplete) {
    _isCompleted = isComplete;
  }

}

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: Container(child: ChangeForm())));
  }
}

class ChangeForm extends StatefulWidget {
  @override
  _ReportPageDetail createState() {
    return _ReportPageDetail();
  }
}

class _ReportPageDetail extends State<ChangeForm> {
  TextStyle _standardText = TextStyle(color: Colors.black, fontSize: 18.0);
  TextStyle _detailText = TextStyle(color: Colors.white, fontSize: 14.0);
  double _standardIconSize = 40.0;
  List<Report> reports;

  @override
  Widget build(BuildContext context) {
    reports = loadReports();

    return Container(
      padding: EdgeInsets.only(left: 20.0, top: 40.0, right: 20.0),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
                width: MediaQuery.of(context).size.width / 1.6,
                height: 80.0,
                child: SearchBar(onSearch: searchReport, onItemFound: null)),
            GestureDetector(
              onTap: sortReport,
              child: Row(
                children: [
                  Text('並べ替え', style: _standardText),
                  ImageIcon(AssetImage('images/icon/icon_sort.png'),
                      size: _standardIconSize)
                ],
              ),
            )
          ]),
          SpaceBox(height: 10.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: showAll, child: Text('すべて', style: _standardText)),
              TextButton(
                  onPressed: showCompleted,
                  child: Text('完了', style: _standardText)),
              TextButton(
                  onPressed: showIncompleted,
                  child: Text('未完了', style: _standardText))
            ],
          ),
          Flexible(
              child: ListView(children: getReportContents())
          )
        ],
      ),
    );
  }

  void sortReport() {
    debugPrint('run sortReport()');
  }

  void showAll() {
    debugPrint('run showAll()');
  }

  void showCompleted() {
    debugPrint('run showCompleted()');
  }

  void showIncompleted() {
    debugPrint('run showIncompleted()');
  }

  Future<List<Report>> searchReport(String reportName) {}

  //DBからレポート情報をロードする
  List<Report> loadReports() {
    List<Report> _reports = new List();

    Report report;
    for(int i = 0; i < 30; i++) {
      report = new Report();
      report.setTitle('タイトル$i');
      _reports.add(report);
    }
    return _reports;
  }

  List<Widget> getReportContents() {
    List<Widget> reportContents = new List();
    for(int i = 0; i < reports.length; i++) {
      reportContents.add(SpaceBox(height: 5.0));
      reportContents.add(getReportStack(i));
    }
    return reportContents;
  }

  Stack getReportStack(int reportNumber) {
    return Stack(
      children: [
        Container(
          height: 100.0,
          width: double.infinity,
          color: Colors.grey,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SpaceBox(width: 5.0),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Image.asset(
                    reports[reportNumber].getReportThumbnailPath(),
                    height: 80.0),
                Text(reports[reportNumber].getTitle(), style: _detailText)
              ],
            ),
            SpaceBox(width: 5.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(reports[reportNumber].getTitle(), style: _detailText),
                SpaceBox(height: 10.0),
                Text(reports[reportNumber].getCourse(), style: _detailText),
                Text(reports[reportNumber].getTargetMonth(), style: _detailText)
              ],
            ),
            Text(reports[reportNumber].getUpdateDate(), style: _detailText)
          ],
        )
      ],
    );
  }
}