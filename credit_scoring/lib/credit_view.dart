import 'package:arc_progress_bar_new/arc_progress_bar_new.dart';
import 'package:flutter/material.dart';

class CreditView extends StatefulWidget {
  final double currentScore;
  final List<String> recommendations; // Added recommendations
  const CreditView(
      {super.key, required this.currentScore, required this.recommendations});

  @override
  State<CreditView> createState() => _CreditViewState();
}

class _CreditViewState extends State<CreditView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _showCreditRating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showCreditRating = true;
          });
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentScore = widget.currentScore.toInt();
    const minScore = 300;
    const maxScore = 850;
    double percentage =
        ((currentScore - minScore) / (maxScore - minScore)) * 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[500],
        title: const Text(
          textAlign: TextAlign.start,
          'Credit Scoring',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 246, 249, 250),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: 400,
                  child: ArcProgressBar(
                    percentage: percentage,
                    innerPadding: 30,
                    animationCurve: Curves.fastOutSlowIn,
                    animationDuration: const Duration(seconds: 4),
                    handleColor: _getScoreColor(currentScore),
                    handleWidget: const Icon(Icons.circle_sharp,
                        color: Colors.transparent),
                    arcThickness: 25,
                    strokeCap: StrokeCap.round,
                    foregroundColor: _getScoreColor(currentScore),
                    backgroundColor: Colors.black12,
                    bottomCenterWidget: TweenAnimationBuilder<double>(
                      tween:
                          Tween<double>(begin: 0, end: currentScore.toDouble()),
                      duration: const Duration(seconds: 4),
                      builder: (_, value, child) {
                        return Column(
                          children: [
                            Text(
                              value.toInt().toString(),
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            _showCreditRating
                                ? Text(
                                    'Credit Rating: ${_getCreditRating(currentScore)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  )
                                : const Text(
                                    'Credit Rating: Calculating',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 246, 249, 250),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: 400,
                  child: Column(
                    children: [
                      const Text(
                        'Recommendations',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.recommendations.map((recommendation) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              '- $recommendation',
                              style: const TextStyle(fontSize: 16),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 246, 249, 250),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Colors.blueGrey,
                        width: 1,
                      ),
                    ),
                  ),
                  width: 400,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'How Credit Scoring Works',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        textAlign: TextAlign.justify,
                        'A credit score is a prediction of your credit behavior, such as how likely you are to pay a loan back on time, based on information from your credit reports.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        textAlign: TextAlign.justify,
                        'The credit scores are divided into five categories:',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.symmetric(
                          outside: const BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                          inside: const BorderSide(
                            color: Colors.black38,
                            width: 0.5,
                          ),
                        ),
                        children: [
                          TableRow(
                            decoration:
                                BoxDecoration(color: Colors.blueGrey[400]),
                            children: const [
                              Text(
                                textAlign: TextAlign.start,
                                '  Credit Rating',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                textAlign: TextAlign.start,
                                '   Score Range',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text(
                                '  Excellent',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '   800 and above',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text('  Very Good',
                                  textAlign: TextAlign.start,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text('   740-799',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text('  Good',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                '   670-739',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text('  Fair',
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text(
                                '   580-669',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const TableRow(
                            children: [
                              Text(
                                '  Poor',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                '   579 and below',
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Recommendations Section
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 800) {
      return Colors.green;
    } else if (score >= 740) {
      return Colors.blue;
    } else if (score >= 670) {
      return Colors.orange;
    } else if (score >= 580) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _getCreditRating(int score) {
    if (score >= 800) {
      return 'Excellent';
    } else if (score >= 740) {
      return 'Very Good';
    } else if (score >= 670) {
      return 'Good';
    } else if (score >= 580) {
      return 'Fair';
    } else {
      return 'Poor';
    }
  }
}
