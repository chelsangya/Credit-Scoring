import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CsvResultView extends StatefulWidget {
  final String filePath;

  const CsvResultView({super.key, required this.filePath});

  @override
  State<CsvResultView> createState() => _CsvResultViewState();
}

class _CsvResultViewState extends State<CsvResultView> {
  List<Map<String, dynamic>>? parsedData;
  String selectedView = 'Visualization';
  String _selectedRange = '300-579';

  @override
  void initState() {
    super.initState();
    parseCsvData();
  }

  Future<void> parseCsvData() async {
    try {
      final csvFile = File(widget.filePath);
      final csvString = await csvFile.readAsString();

      List<List<dynamic>> rowsAsListOfValues =
          const CsvToListConverter().convert(csvString, eol: '\n');

      if (rowsAsListOfValues.isEmpty) {
        print("CSV file is empty.");
        setState(() {
          parsedData = [];
        });
        return;
      }

      List<String> headers =
          rowsAsListOfValues[0].map((header) => header.toString()).toList();

      List<Map<String, dynamic>> rowsAsListOfMaps = rowsAsListOfValues
          .skip(1)
          .where((row) => row.length == headers.length)
          .map((row) => Map.fromIterables(headers, row))
          .toList();

      if (rowsAsListOfValues.length - 1 != rowsAsListOfMaps.length) {
        print(
            "Warning: Some rows have a different number of columns than the header.");
      }

      print("Headers: $headers");
      print("Parsed CSV Data: $rowsAsListOfMaps");

      setState(() {
        parsedData = rowsAsListOfMaps;
      });
    } catch (e) {
      print("Error parsing CSV: $e");
    }
  }

  Map<String, int> categorizeCreditScores(List<Map<String, dynamic>> data) {
    Map<String, int> scoreRanges = {
      '300-579': 0,
      '580-669': 0,
      '670-739': 0,
      '740-799': 0,
      '800-850': 0,
    };

    for (var row in data) {
      double score = double.parse(row['Predicted Credit Score'].toString());
      if (score >= 300 && score <= 579) {
        scoreRanges['300-579'] = scoreRanges['300-579']! + 1;
      } else if (score >= 580 && score <= 669) {
        scoreRanges['580-669'] = scoreRanges['580-669']! + 1;
      } else if (score >= 670 && score <= 739) {
        scoreRanges['670-739'] = scoreRanges['670-739']! + 1;
      } else if (score >= 740 && score <= 799) {
        scoreRanges['740-799'] = scoreRanges['740-799']! + 1;
      } else if (score >= 800 && score <= 850) {
        scoreRanges['800-850'] = scoreRanges['800-850']! + 1;
      }
    }

    var sortedKeys = scoreRanges.keys.toList()
      ..sort((a, b) => scoreRanges[b]!.compareTo(scoreRanges[a]!));
    Map<String, int> sortedScoreRanges = {
      for (var k in sortedKeys) k: scoreRanges[k]!
    };

    print("Categorized Credit Scores: $sortedScoreRanges");
    return sortedScoreRanges;
  }

  List<ChartSeries<String, String>> createBarChartData(Map<String, int> data) {
    List<String> ranges = data.keys.toList();
    List<Color> colors = [
      Colors.blue[800]!,
      Colors.blue[600]!,
      Colors.blue[400]!,
      Colors.blue[200]!,
      Colors.blue[100]!,
    ];
    return [
      BarSeries<String, String>(
        dataSource: ranges,
        xValueMapper: (range, _) => range,
        yValueMapper: (range, _) => data[range]!.toDouble(),
        pointColorMapper: (range, index) => colors[index % colors.length],
        dataLabelSettings: const DataLabelSettings(isVisible: true),
        name: 'Credit Score Range',
      )
    ];
  }

  Widget buildVisualizationView() {
    final colorMapping = [
      Colors.blue[800]!,
      Colors.blue[600]!,
      Colors.blue[400]!,
      Colors.blue[200]!,
      Colors.blue[100]!,
    ];

    return Column(
      children: [
        Text(
          'Bar Chart Showing Credit Scores',
          textAlign: TextAlign.start,
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 300,
          child: SfCartesianChart(
            margin: const EdgeInsets.all(5),
            primaryXAxis: CategoryAxis(isVisible: false, isInversed: true),
            primaryYAxis: NumericAxis(
              isVisible: false,
            ),
            legend: Legend(isVisible: false),
            plotAreaBorderWidth: 0,
            tooltipBehavior: TooltipBehavior(enable: true),
            series: createBarChartData(categorizeCreditScores(parsedData!)),
          ),
        ),
        const SizedBox(height: 40),
        Table(
          border: TableBorder.symmetric(
            outside: const BorderSide(width: 0.5, color: Colors.grey),
          ),
          children: [
            const TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Color',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Credit Score',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Credit Rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            for (int i = 0;
                i < categorizeCreditScores(parsedData!).keys.length;
                i++)
              TableRow(
                children: [
                  TableCell(
                    child: Container(
                      height: 32,
                      width: 15,
                      color: colorMapping[i % colorMapping.length],
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categorizeCreditScores(parsedData!).keys.toList()[i],
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _getCreditRating(categorizeCreditScores(parsedData!)
                            .keys
                            .toList()[i]),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }

  Widget buildTableView() {
    // Filter data based on selected range
    List<Map<String, dynamic>> filteredData = parsedData!.where((row) {
      double score = double.parse(row['Predicted Credit Score'].toString());
      return _isScoreInRange(score, _selectedRange);
    }).toList();

    // Define a map to replace specific headers with desired labels
    Map<String, String> headerMappings = {
      'creditCards': 'Credit Cards',
      'annual income': 'Annual Income',
      'loans': 'No. of Loans',
      'amount of loan remaining': 'Loan Remaining ',
      'loan duration in months': 'Loan Duration ',
      'Predicted Credit Score': 'Predicted Score',
    };

    return Column(
      children: [
        // const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerRight,
          child: DropdownButton<String>(
            value: _selectedRange,
            dropdownColor: Colors.blueGrey[300],
            items: categorizeCreditScores(parsedData!).keys.map((String range) {
              return DropdownMenuItem<String>(
                value: range,
                child: Text(
                  range,
                  style: const TextStyle(color: Colors.black),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRange = newValue!;
              });
            },
          ),
        ),
        // const SizedBox(height: 0),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: filteredData.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> row = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Divider(color: Colors.grey),
                      // Display "Customer Number" instead of "Row Number"
                      Text(
                        'Customer ${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const Divider(color: Colors.grey),
                      ...row.entries.map((entry) {
                        String displayKey =
                            headerMappings[entry.key] ?? entry.key;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  displayKey,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(entry.value.toString()),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  bool _isScoreInRange(double score, String range) {
    switch (range) {
      case '300-579':
        return score >= 300 && score <= 579;
      case '580-669':
        return score >= 580 && score <= 669;
      case '670-739':
        return score >= 670 && score <= 739;
      case '740-799':
        return score >= 740 && score <= 799;
      case '800-850':
        return score >= 800 && score <= 850;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(96, 125, 139, 1),
        title: const Text(
          'CSV Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
        actions: [
          DropdownButton<String>(
            value: selectedView,
            dropdownColor: Colors.blueGrey[300],
            items: <String>['Visualization', 'Table'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedView = newValue!;
              });
            },
          ),
        ],
      ),
      body: parsedData == null
          ? const Center(child: CircularProgressIndicator())
          : parsedData!.isEmpty
              ? const Center(child: Text('No data available.'))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: selectedView == 'Visualization'
                      ? buildVisualizationView()
                      : buildTableView(),
                ),
    );
  }

  String _getCreditRating(String range) {
    switch (range) {
      case '300-579':
        return 'Poor';
      case '580-669':
        return 'Fair';
      case '670-739':
        return 'Good';
      case '740-799':
        return 'Very Good';
      case '800-850':
        return 'Excellent';
      default:
        return '';
    }
  }
}
