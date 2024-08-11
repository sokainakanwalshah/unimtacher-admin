import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';
import 'package:unimatcher_admin/resources/userRepo.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class UserStatics extends StatelessWidget {
  const UserStatics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserRepository repository = new UserRepository();

    return FutureBuilder<int>(
      future: repository.getUsersCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While fetching data
          return const CircularProgressIndicator(); // Show a loading indicator
        } else if (snapshot.hasError) {
          // If an error occurred
          return Text('Error: ${snapshot.error}');
        } else {
          int totalCount = snapshot.data ?? 0;

          return Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(15.0), // Adjust the radius as needed
            ),
            child: Card(
              elevation: 4.0,
              margin: const EdgeInsets.all(10.0),
              child: Container(
                color: Color.fromARGB(255, 223, 174, 14),
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "User Statistics",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: UMColors.white,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: UMColors.white,
                            elevation: 4.0,
                            child: Container(
                              height: 170.0,
                              padding: const EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Column(children: [
                                  const Text(
                                    'Total Users',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                      color: UMColors.black,
                                    ),
                                  ),
                                  UserStatsChart(totalCount: totalCount)
                                ]),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Card(
                            elevation: 4.0,
                            child: Container(
                              height: 170.0,
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Text(
                                    "User Registrations (Last 20 Days)",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                    child: UserStatsLineChart(
                                      data: [
                                        UserData("Day 1", 2),
                                        UserData("Day 2", 5),
                                        // Add more data here...
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class UserStatsChart extends StatelessWidget {
  final int totalCount;

  const UserStatsChart({Key? key, required this.totalCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double completionPercentage = totalCount > 0 ? totalCount / 70 * 100 : 0;

    return Stack(
      children: [
        AnimatedCircularChart(
          size: const Size(150.0, 150.0),
          initialChartData: <CircularStackEntry>[
            CircularStackEntry(
              <CircularSegmentEntry>[
                CircularSegmentEntry(
                  completionPercentage,
                  const Color.fromARGB(255, 222, 164, 5),
                  rankKey: 'completed',
                ),
                CircularSegmentEntry(
                  100 - completionPercentage,
                  Colors.grey[300]!,
                  rankKey: 'remaining',
                ),
              ],
              rankKey: 'progress',
            ),
          ],
          chartType: CircularChartType.Pie,
          holeRadius: 40,
          holeLabel: '${completionPercentage.toStringAsFixed(2)}%',
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
          duration: const Duration(seconds: 3), // Slow down the animation speed
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              '${completionPercentage.toStringAsFixed(2)}%',
              style: const TextStyle(
                color: UMColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

///line chart,

class UserStatsLineChart extends StatelessWidget {
  final List<UserData> data;

  const UserStatsLineChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: <CartesianSeries>[
        LineSeries<UserData, String>(
          dataSource: data,
          xValueMapper: (UserData userData, _) => userData.date,
          yValueMapper: (UserData userData, _) => userData.users,
        ),
      ],
    );
  }
}

class UserData {
  final String date;
  final int users;

  UserData(this.date, this.users);
}
