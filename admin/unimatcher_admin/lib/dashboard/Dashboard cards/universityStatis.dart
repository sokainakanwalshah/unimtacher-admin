import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:unimatcher_admin/resources/uniRepo.dart';
import 'package:unimatcher_admin/univerities_data/alluniveritiesData.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:unimatcher_admin/utils/constants/image_strings.dart';

class UniversityStatics extends StatelessWidget {
  const UniversityStatics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UuniversityRepository repository = UuniversityRepository();

    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(15.0), // Adjust the radius as needed
      ),
      child: Card(
        elevation: 4.0,
        margin: const EdgeInsets.all(10.0),
        child: Container(
          color: const Color.fromARGB(255, 223, 174, 14),
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Universities Statistics",
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  color: UMColors.white,
                ),
              ),
              const SizedBox(height: 10.0),
              FutureBuilder<int>(
                future: repository.getUniveristyCount(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else if (snapshot.hasData) {
                    int data = snapshot.data!;
                    return Row(
                      children: [
                        Expanded(
                          child: Card(
                            color: UMColors.white,
                            elevation: 4.0,
                            child: Container(
                              height: 170.0,
                              padding: const EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Total Universities',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: UMColors.black,
                                      ),
                                    ),
                                    UserStatsChart(totalCount: data),
                                  ],
                                ),
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
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  const Text(
                                    "Navigate to Manage Universities Data",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                  () => AllUniveritiesData());
                                            },
                                            child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                image: AssetImage(
                                                    UMImages.onBoardingImage3),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                  () => AllUniveritiesData());
                                            },
                                            child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                image: AssetImage(
                                                    UMImages.search2),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Get.to(
                                                  () => AllUniveritiesData());
                                            },
                                            child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                image: AssetImage(
                                                    UMImages.onBoardingImage2),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
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
