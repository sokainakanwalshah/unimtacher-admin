import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:unimatcher_admin/resources/studyRepo.dart';
import 'package:unimatcher_admin/study_material/study_material.dart';
import 'package:unimatcher_admin/utils/constants/colors.dart';
import 'package:circular_chart_flutter/circular_chart_flutter.dart';
import 'package:unimatcher_admin/utils/constants/image_strings.dart';

class StudyMaterialStatics extends StatelessWidget {
  const StudyMaterialStatics({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudyMaterialRepository repository = new StudyMaterialRepository();

    return FutureBuilder<int>(
      future: repository.getmaterialCount(),
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
              borderRadius: BorderRadius.circular(15.0),
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
                      "Study Material Statistics",
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
                                    'Total Study Material',
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
                                    "Navigate to Manage Study Materials",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10.0),
                                  Expanded(
                                      child: Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => StudyMaterialsScreen());
                                          },
                                          child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                  image: AssetImage(UMImages
                                                      .onBoardingImage2))),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => StudyMaterialsScreen());
                                          },
                                          child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                  image: AssetImage(
                                                      UMImages.search))),
                                        ),
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            Get.to(
                                                () => StudyMaterialsScreen());
                                          },
                                          child: Container(
                                              height: 130,
                                              width: double.infinity,
                                              child: const Image(
                                                  image: AssetImage(UMImages
                                                      .onBoardingImage3))),
                                        ),
                                      ),
                                    ],
                                  )),
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
