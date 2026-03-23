import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class PlotsSections extends StatelessWidget {
  final List<BarChartGroupData> chartData;
  final double maxY;
final String? plotTitle;
  const PlotsSections({
    super.key, 
    required this.chartData, 
    this.maxY = 20, this.plotTitle,
  });
static const List<String> weekTitles = [
      "1st Week", "2nd Week", "3rd Week", "4th Week",
      "5th Week", "6th Week", "7th Week", "8th Week"
    ];
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: AppColors.lightGreen,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
        child: Column(
          children: [
            _PlotHeader(plotTitle: plotTitle,),
Gap(10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                width: chartData.length * 80.0 < MediaQuery.of(context).size.width 
             ? MediaQuery.of(context).size.width - 60 
             : chartData.length * 80.0,
              child: BarChart(
                
                    BarChartData(
                      maxY: 20,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35,
                            getTitlesWidget: (value, meta) => Text(
                              '${value.toInt()}k',
                               style: TextStyles.caption3_12.copyWith(color: AppColors.lightBlueButton),
                               
                            ),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              int index = value.toInt();
                             if (index >= 0 && index < weekTitles.length) {
                                return SideTitleWidget(
                                  meta: meta,
                                 
                                  fitInside :const SideTitleFitInsideData(enabled: false, distanceFromEdge: 0, parentAxisSize: 0, axisPosition: 0),
                                  space: 5, 
                                  child: Text(
                                    weekTitles[index],
                                    style: TextStyles.caption3_12.copyWith(color: AppColors.darkGreen),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: AppColors.lightBlueButton,
                          strokeWidth: .5,
                          dashArray: [5, 5],
                        ),
                        horizontalInterval: maxY/ 4,
                      ),
                     borderData: FlBorderData(
                    show: true, 
                    border: const Border(
                      bottom: BorderSide(
                        color:AppColors.darkGreen,
                        width: 1, 
                      ),
                      left: BorderSide(color: Colors.transparent),
                      right: BorderSide(color: Colors.transparent),
                      top: BorderSide(color: Colors.transparent),
                    ),
                  ),
                      barGroups: chartData
                    ),
                    duration: const Duration(milliseconds: 400),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class _PlotHeader extends StatelessWidget {
  const _PlotHeader({this.plotTitle});
final String? plotTitle;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(plotTitle??"Income & Expenses", style: TextStyles.body_15),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const CustomSvgPicture(
                path: AppAssets.searchButton,
              ),
            ),
    
            IconButton(
              onPressed: () {},
              icon: const CustomSvgPicture(path: AppAssets.calender),
            ),
          ],
        ),
      ],
    );
  }
}
