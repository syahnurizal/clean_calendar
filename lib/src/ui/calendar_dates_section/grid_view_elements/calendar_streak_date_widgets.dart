import 'package:clean_calendar/src/models/calendar_properties.dart';
import 'package:clean_calendar/src/models/dates_properties.dart';
import 'package:clean_calendar/src/utils/get_end_weekday_from_start_weekday.dat.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_on_tap.dart';
import 'package:clean_calendar/src/utils/get_suitable_dates_properties.dart';
import 'package:clean_calendar/src/utils/get_widget_center_offset_info.dart';
import 'package:clean_calendar/src/utils/simulate_tap_on_an_offset.dart';
import 'package:clean_calendar/src/utils/space_fixer.dart';
import 'package:flutter/material.dart';

/// Only use Ink if its parent is a button otherwise it will act weird such as this https://github.com/flutter/flutter/issues/73315
/// Use space fixer between containers of same color to fix lines due to antialiasing will be fixed with impeller in future.

class CalendarStreakStartDenseDate extends StatelessWidget {
  const CalendarStreakStartDenseDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    List<dynamic> eventMatch = [];
    if(calendarProperties.events != null){
      for (var event in calendarProperties.events!) {
        if(event['start_date'] == '${pageViewElementDate.year}-${pageViewElementDate.month.toString().padLeft(2,'0')}-${pageViewElementDate.day.toString().padLeft(2,'0')}'){
          if(eventMatch.length < 3) {
            eventMatch.add(event);
          }
        }
      }
    }

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(datesBorderRadius),
                      bottomLeft: Radius.circular(datesBorderRadius),
                    ),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [

                    SizedBox(
                      width: 40,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                              decoration: BoxDecoration(
                                border: datesBorderColor != null
                                    ? Border.all(color: datesBorderColor, width: 1)
                                    : null,
                                borderRadius: datesBorderRadius != null
                                    ? BorderRadius.only(
                                        topLeft: Radius.circular(datesBorderRadius),
                                        bottomLeft:
                                            Radius.circular(datesBorderRadius),
                                      )
                                    : null,
                                color: datesBackgroundColor,
                              ),
                              child: Center(
                                child: Text(
                                  pageViewElementDate.day.toString(),
                                  style: datesTextStyle != null
                                      ? datesTextStyle.copyWith(
                                          color: datesTextColor,
                                        )
                                      : TextStyle(color: datesTextColor),
                                ),
                              ),
                            ),
                            eventMatch.isEmpty ? const SizedBox(height: 8) : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: eventMatch.map((e) {
                                  return Container(
                                    height: 6,
                                    width: 6,
                                    margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                    decoration: BoxDecoration(
                                        color: e['color'], borderRadius: BorderRadius.circular(6)
                                    ),
                                  );
                                }).toList()
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// No middle border mode
                /*Stack(
                alignment: Alignment.topRight,
                children: [
                  SizedBox(
                    width: 40,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          border: datesBorderColor != null
                              ? Border.all(color: datesBorderColor, width: 1)
                              : null,
                          borderRadius: datesBorderRadius != null
                              ? BorderRadius.only(
                            topLeft: Radius.circular(datesBorderRadius),
                            bottomLeft:
                            Radius.circular(datesBorderRadius),
                          )
                              : null,
                          color: datesBackgroundColor,
                        ),
                        child: Container(
                          // margin: const EdgeInsets.only(left: 4.0),
                          child: Center(
                            child: Text(
                              pageViewElementDate.day.toString(),
                              style: datesTextStyle != null
                                  ? datesTextStyle.copyWith(
                                color: datesTextColor,
                              )
                                  : TextStyle(color: datesTextColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Container(
                      margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                      child: Ink(
                        decoration: BoxDecoration(
                          border: datesBorderColor != null
                              ? Border.symmetric(
                              horizontal: BorderSide(
                                  color: datesBorderColor, width: 1))
                              : null,
                          color: datesBackgroundColor,
                        ),
                        child: Container(
                          width: 40 / 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),*/
                ///
                /// Little far Border mode
                /*SizedBox(
                width: 40,
                child: Container(
                  margin:
                      const EdgeInsets.only(top: 4.0, bottom: 4.0, left: 4.0),
                  child: Ink(
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.all(color: datesBorderColor, width: 1)
                          : null,
                      borderRadius: datesBorderRadius != null
                          ? BorderRadius.only(
                              topLeft: Radius.circular(datesBorderRadius),
                              bottomLeft: Radius.circular(datesBorderRadius),
                            )
                          : null,
                      color: datesBackgroundColor,
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(right: 4.0),
                      child: Center(
                        child: Text(
                          pageViewElementDate.day.toString(),
                          style: datesTextStyle != null
                              ? datesTextStyle.copyWith(
                                  color: datesTextColor,
                                )
                              : TextStyle(color: datesTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
                ///
                /*datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalInkLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBackgroundColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),*/
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 3.0,
                        bottom: 11.0,
                        right: pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border.symmetric(
                                horizontal: BorderSide(color: datesBorderColor, width: 1))
                            : null,
                        color: datesBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakStartDenseSplashDate extends StatelessWidget {
  const CalendarStreakStartDenseSplashDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(datesBorderRadius),
                            bottomLeft: Radius.circular(datesBorderRadius),
                          ),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: disable ? null : dateSuitableDatesOnTap,
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.symmetric(
                                      horizontal: BorderSide(
                                          color: datesBorderColor, width: 1))
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Container(
                              width: 40 / 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.all(
                                      color: datesBorderColor, width: 1)
                                  : null,
                              borderRadius: datesBorderRadius != null
                                  ? BorderRadius.only(
                                      topLeft:
                                          Radius.circular(datesBorderRadius),
                                      bottomLeft:
                                          Radius.circular(datesBorderRadius),
                                    )
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Center(
                              child: Text(
                                key: widgetKey,
                                pageViewElementDate.day.toString(),
                                style: datesTextStyle != null
                                    ? datesTextStyle.copyWith(
                                        color: datesTextColor,
                                      )
                                    : TextStyle(color: datesTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right:
                            pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
// class CalendarStreakStartDenseSplashDate extends StatelessWidget {
//   const CalendarStreakStartDenseSplashDate(
//       {Key? key,
//       required this.pageViewElementDate,
//       required this.pageViewMonthDate})
//       : super(key: key);
//
//   final DateTime pageViewElementDate;
//   final DateTime pageViewMonthDate;
//
//   @override
//   Widget build(BuildContext context) {
//     final GlobalKey widgetKey = GlobalKey();
//
//     return Consumer(
//       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//         final DatesProperties dateSuitablePropertiesProviderValue = ref.watch(
//             dateSuitablePropertiesProvider(IndividualDateElementProperties(
//                     pageViewElementDate: pageViewElementDate,
//                     pageViewMonthDate: pageViewMonthDate))
//                 .select((value) => value));
//
//         DatesProperties datesProperties = dateSuitablePropertiesProviderValue;
//
//         Color? datesBackgroundColor =
//             datesProperties.decorationProperties?.datesBackgroundColor;
//         Color? datesTextColor =
//             datesProperties.decorationProperties?.datesTextColor;
//         TextStyle? datesTextStyle =
//             datesProperties.decorationProperties?.datesTextStyle;
//         Color? datesBorderColor =
//             datesProperties.decorationProperties?.datesBorderColor;
//         double? datesBorderRadius =
//             datesProperties.decorationProperties?.datesBorderRadius;
//
//         return InkWell(
//           // clipBehavior: Clip.antiAlias,
//           customBorder: const RoundedRectangleBorder(side: BorderSide.none),
//           borderRadius: datesBorderRadius != null
//               ? BorderRadius.only(
//                   topLeft: Radius.circular(datesBorderRadius),
//                   bottomLeft: Radius.circular(datesBorderRadius))
//               : null,
//           focusColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           overlayColor: MaterialStateProperty.all(Colors.transparent),
//           splashColor: Colors.transparent,
//           splashFactory: NoSplash.splashFactory,
//           enableFeedback: false,
//           onTap: pageViewElementDate.month == pageViewMonthDate.month
//               ? () {
//                   Offset widgetCenterOffset =
//                       getWidgetCenterOffsetInfo(widgetKey);
//                   // print(widgetCenterOffset);
//                   simulateTapOnAnOffset(widgetCenterOffset);
//                 }
//               : null,
//           child: Row(
//             children: [
//               const Expanded(
//                 child: SizedBox(),
//               ),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size.zero,
//                   padding: EdgeInsets.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   foregroundColor: Theme.of(context).colorScheme.onSurface,
//                   side: BorderSide.none,
//                   shape: datesBorderRadius != null
//                       ? RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(datesBorderRadius),
//                             bottomLeft: Radius.circular(datesBorderRadius),
//                           ),
//                         )
//                       : null,
//                 ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
//                 onPressed: pageViewElementDate.month == pageViewMonthDate.month
//                     ? () {
//                         final CalendarPropertiesState
//                             readCalendarPropertiesStateProviderValue =
//                             ref.read(calendarPropertiesStateProvider);
//
//                         readCalendarPropertiesStateProviderValue
//                             .updateSelectedDates(
//                                 selectedDates: [pageViewElementDate]);
//                         // widget.onSelectedDate.call(widget.date);
//                       }
//                     : null,
//                 child: Stack(
//                   alignment: Alignment.topRight,
//                   children: [
//                     SizedBox(
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                             border: datesBorderColor != null
//                                 ? Border.symmetric(
//                                     horizontal: BorderSide(
//                                         color: datesBorderColor, width: 1))
//                                 : null,
//                             color: datesBackgroundColor,
//                           ),
//                           child: Container(
//                             width: 40 / 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: Container(
//                         margin: const EdgeInsets.all(4.0),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                             border: datesBorderColor != null
//                                 ? Border.all(color: datesBorderColor, width: 1)
//                                 : null,
//                             borderRadius: datesBorderRadius != null
//                                 ? BorderRadius.only(
//                                     topLeft: Radius.circular(datesBorderRadius),
//                                     bottomLeft:
//                                         Radius.circular(datesBorderRadius),
//                                   )
//                                 : null,
//                             color: datesBackgroundColor,
//                           ),
//                           child: Center(
//                             child: Text(
//                               key: widgetKey,
//                               pageViewElementDate.day.toString(),
//                               style: datesTextStyle != null
//                                   ? datesTextStyle.copyWith(
//                                       color: datesTextColor,
//                                     )
//                                   : TextStyle(color: datesTextColor),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               datesBackgroundColor != null
//                   ? Container(
//                       margin: const EdgeInsets.only(top: 4, bottom: 4),
//                       child: SpaceFixerVerticalLine(
//                         overflowWidth: 1,
//                         overflowColor: datesBackgroundColor,
//                         border: datesBorderColor != null
//                             ? Border.symmetric(
//                                 horizontal: BorderSide(
//                                     color: datesBorderColor, width: 1))
//                             : null,
//                       ),
//                     )
//                   : const SizedBox(),
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(
//                       top: 4.0,
//                       bottom: 4.0,
//                       right: pageViewElementDate.weekday == DateTime.saturday
//                           ? 4
//                           : 0),
//                   decoration: BoxDecoration(
//                     border: datesBorderColor != null
//                         ? Border.symmetric(
//                             horizontal:
//                                 BorderSide(color: datesBorderColor, width: 1))
//                         : null,
//                     color: datesBackgroundColor,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class CalendarStreakStartExpandedDate extends StatelessWidget {
  const CalendarStreakStartExpandedDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int endWeekday = getEndWeekdayFromStartWeekday(
        startWeekday: getIntFromWeekday(calendarProperties.startWeekday));

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(datesBorderRadius),
                        bottomLeft: Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  left: 4,
                  right: pageViewElementDate.weekday == endWeekday ? 4 : 0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border(
                          top: BorderSide(color: datesBorderColor, width: 1),
                          bottom: BorderSide(color: datesBorderColor, width: 1),
                          left: BorderSide(color: datesBorderColor, width: 1),
                          right: BorderSide(color: datesBorderColor, width: 1),
                        )
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.only(
                          topLeft: Radius.circular(datesBorderRadius),
                          bottomLeft: Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: Text(
                    pageViewElementDate.day.toString(),
                    style: datesTextStyle != null
                        ? datesTextStyle.copyWith(
                            color: datesTextColor,
                          )
                        : TextStyle(color: datesTextColor),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakBetweenDenseSplashDate extends StatelessWidget {
  const CalendarStreakBetweenDenseSplashDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    final int endWeekday =
        getEndWeekdayFromStartWeekday(startWeekday: startWeekday);
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    List<dynamic> eventMatch = [];
    if(calendarProperties.events != null){
      for (var event in calendarProperties.events!) {
        if(event['start_date'] == '${pageViewElementDate.year}-${pageViewElementDate.month.toString().padLeft(2,'0')}-${pageViewElementDate.day.toString().padLeft(2,'0')}'){
          if(eventMatch.length < 3) {
            eventMatch.add(event);
          }
        }
      }
    }

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);

                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1),
                            )
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                  ),
                  splashFactory: InkRipple.splashFactory,
                  onTap: disable ? null : dateSuitableDatesOnTap,
                  child: Container(
                    margin: const EdgeInsets.only(top: 4, bottom: 4),
                    width: 40,
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border.symmetric(
                                horizontal: BorderSide(
                                    color: datesBorderColor, width: 1))
                            : null,
                        color: datesBackgroundColor,
                      ),
                      child: Center(
                        child: Text(
                          key: widgetKey,
                          pageViewElementDate.day.toString(),
                          style: datesTextStyle != null
                              ? datesTextStyle.copyWith(
                                  color: datesTextColor,
                                )
                              : TextStyle(color: datesTextColor),
                        ),
                      ),
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        right:
                            pageViewElementDate.weekday == endWeekday ? 4 : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
// class CalendarStreakBetweenDenseSplashDate extends StatelessWidget {
//   const CalendarStreakBetweenDenseSplashDate(
//       {Key? key,
//       required this.pageViewElementDate,
//       required this.pageViewMonthDate})
//       : super(key: key);
//
//   final DateTime pageViewElementDate;
//   final DateTime pageViewMonthDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//         final DatesProperties dateSuitablePropertiesProviderValue = ref.watch(
//             dateSuitablePropertiesProvider(IndividualDateElementProperties(
//                     pageViewElementDate: pageViewElementDate,
//                     pageViewMonthDate: pageViewMonthDate))
//                 .select((value) => value));
//
//         DatesProperties datesProperties = dateSuitablePropertiesProviderValue;
//
//         Color? datesBackgroundColor =
//             datesProperties.decorationProperties?.datesBackgroundColor;
//         Color? datesTextColor =
//             datesProperties.decorationProperties?.datesTextColor;
//         TextStyle? datesTextStyle =
//             datesProperties.decorationProperties?.datesTextStyle;
//         Color? datesBorderColor =
//             datesProperties.decorationProperties?.datesBorderColor;
//
//         return Row(
//           children: [
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(
//                     top: 4.0,
//                     bottom: 4.0,
//                     left:
//                         pageViewElementDate.weekday == DateTime.sunday ? 4 : 0),
//                 decoration: BoxDecoration(
//                   border: datesBorderColor != null
//                       ? Border.symmetric(
//                           horizontal:
//                               BorderSide(color: datesBorderColor, width: 1),
//                         )
//                       : null,
//                   color: datesBackgroundColor,
//                 ),
//               ),
//             ),
//             datesBackgroundColor != null
//                 ? Container(
//                     margin: const EdgeInsets.only(top: 4, bottom: 4),
//                     child: SpaceFixerVerticalLine(
//                       overflowWidth: 1,
//                       overflowColor: datesBackgroundColor,
//                       border: datesBorderColor != null
//                           ? Border.symmetric(
//                               horizontal:
//                                   BorderSide(color: datesBorderColor, width: 1))
//                           : null,
//                     ),
//                   )
//                 : const SizedBox(),
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 minimumSize: Size.zero,
//                 padding: EdgeInsets.zero,
//                 tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                 foregroundColor: Theme.of(context).colorScheme.onSurface,
//                 side: BorderSide.none,
//                 shape: const RoundedRectangleBorder(
//                   borderRadius: BorderRadius.all(Radius.circular(0)),
//                 ),
//               ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
//               onPressed: pageViewElementDate.month == pageViewMonthDate.month
//                   ? () {
//                       // widget.onSelectedDate.call(widget.date);
//                     }
//                   : null,
//               child: Container(
//                 margin: const EdgeInsets.only(top: 4, bottom: 4),
//                 width: 40,
//                 child: Ink(
//                   decoration: BoxDecoration(
//                     border: datesBorderColor != null
//                         ? Border.symmetric(
//                             horizontal:
//                                 BorderSide(color: datesBorderColor, width: 1))
//                         : null,
//                     color: datesBackgroundColor,
//                   ),
//                   child: Center(
//                     child: Text(
//                       pageViewElementDate.day.toString(),
//                       style: datesTextStyle != null
//                           ? datesTextStyle.copyWith(
//                               color: datesTextColor,
//                             )
//                           : TextStyle(color: datesTextColor),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             datesBackgroundColor != null
//                 ? Container(
//                     margin: const EdgeInsets.only(top: 4, bottom: 4),
//                     child: SpaceFixerVerticalLine(
//                       overflowWidth: 1,
//                       overflowColor: datesBackgroundColor,
//                       border: datesBorderColor != null
//                           ? Border.symmetric(
//                               horizontal:
//                                   BorderSide(color: datesBorderColor, width: 1))
//                           : null,
//                     ),
//                   )
//                 : const SizedBox(),
//             Expanded(
//               child: Container(
//                 margin: EdgeInsets.only(
//                     top: 4.0,
//                     bottom: 4.0,
//                     right: pageViewElementDate.weekday == DateTime.saturday
//                         ? 4
//                         : 0),
//                 decoration: BoxDecoration(
//                   border: datesBorderColor != null
//                       ? Border.symmetric(
//                           horizontal:
//                               BorderSide(color: datesBorderColor, width: 1))
//                       : null,
//                   color: datesBackgroundColor,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class CalendarStreakBetweenExpandedDate extends StatelessWidget {
  const CalendarStreakBetweenExpandedDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    final int endWeekday =
        getEndWeekdayFromStartWeekday(startWeekday: startWeekday);
    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    List<dynamic> eventMatch = [];
    if(calendarProperties.events != null){
      for (var event in calendarProperties.events!) {
        if(event['start_date'] == '${pageViewElementDate.year}-${pageViewElementDate.month.toString().padLeft(2,'0')}-${pageViewElementDate.day.toString().padLeft(2,'0')}'){
          if(eventMatch.length < 3) {
            eventMatch.add(event);
          }
        }
      }
    }

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Container(
              margin: EdgeInsets.only(
                right: pageViewElementDate.weekday == endWeekday ? 4 : 0,
                left: pageViewElementDate.weekday == startWeekday ? 4 : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: pageViewElementDate.weekday == startWeekday ? 4 : 0,
                        left: pageViewElementDate.weekday == endWeekday ? 4 : 0,
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                            child: SizedBox(),
                          ),
                          Center(
                            child: Text(
                              pageViewElementDate.day.toString(),
                              style: datesTextStyle != null
                                  ? datesTextStyle.copyWith(
                                      color: datesTextColor,
                                    )
                                  : TextStyle(color: datesTextColor),
                            ),
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  eventMatch.isEmpty ? const SizedBox(height: 8) : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: eventMatch.map((e) {
                        return Container(
                          height: 6,
                          width: 6,
                          margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
                          decoration: BoxDecoration(
                              color: e['color'], borderRadius: BorderRadius.circular(6)
                          ),
                        );
                      }).toList()
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakEndDenseDate extends StatelessWidget {
  const CalendarStreakEndDenseDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    List<dynamic> eventMatch = [];
    if(calendarProperties.events != null){
      for (var event in calendarProperties.events!) {
        if(event['start_date'] == '${pageViewElementDate.year}-${pageViewElementDate.month.toString().padLeft(2,'0')}-${pageViewElementDate.day.toString().padLeft(2,'0')}'){
          if(eventMatch.length < 3) {
            eventMatch.add(event);
          }
        }
      }
    }

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(datesBorderRadius),
                      bottomRight: Radius.circular(datesBorderRadius),
                    ),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 3.0,
                        bottom: 11.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    child: Container(
                      //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                      decoration: BoxDecoration(
                        border: datesBorderColor != null
                            ? Border(
                                top: BorderSide(
                                    color: datesBorderColor, width: 1),
                                bottom: BorderSide(
                                    color: datesBorderColor, width: 1),
                                // left:
                                //     BorderSide(color: datesBorderColor, width: 1),
                              )
                            : null,
                        color: datesBackgroundColor,
                      ),
                    ),
                  ),
                ),
                /*datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalInkLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),*/
                Stack(
                  children: [
                    SizedBox(
                      width: 40,
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                              decoration: BoxDecoration(
                                border: datesBorderColor != null
                                    ? Border.all(color: datesBorderColor, width: 1)
                                    : null,
                                borderRadius: datesBorderRadius != null
                                    ? BorderRadius.only(
                                        topRight:
                                            Radius.circular(datesBorderRadius),
                                        bottomRight:
                                            Radius.circular(datesBorderRadius),
                                      )
                                    : null,
                                color: datesBackgroundColor,
                              ),
                              child: Center(
                                child: Text(
                                  pageViewElementDate.day.toString(),
                                  style: datesTextStyle != null
                                      ? datesTextStyle.copyWith(
                                          color: datesTextColor,
                                        )
                                      : TextStyle(color: datesTextColor),
                                ),
                              ),
                            ),
                            eventMatch.isEmpty ? const SizedBox(height: 8) : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: eventMatch.map((e) {
                                  return Container(
                                    height: 6,
                                    width: 6,
                                    margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                    decoration: BoxDecoration(
                                        color: e['color'], borderRadius: BorderRadius.circular(6)
                                    ),
                                  );
                                }).toList()
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakEndDenseSplashDate extends StatelessWidget {
  const CalendarStreakEndDenseSplashDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 4.0,
                        bottom: 4.0,
                        left: pageViewElementDate.weekday == startWeekday
                            ? 4
                            : 0),
                    decoration: BoxDecoration(
                      border: datesBorderColor != null
                          ? Border.symmetric(
                              horizontal:
                                  BorderSide(color: datesBorderColor, width: 1))
                          : null,
                      color: datesBackgroundColor,
                    ),
                  ),
                ),
                datesBackgroundColor != null
                    ? Container(
                        margin: const EdgeInsets.only(top: 4, bottom: 4),
                        child: SpaceFixerVerticalLine(
                          overflowWidth: 1,
                          overflowColor: datesBackgroundColor,
                          border: datesBorderColor != null
                              ? Border.symmetric(
                                  horizontal: BorderSide(
                                      color: datesBorderColor, width: 1))
                              : null,
                        ),
                      )
                    : const SizedBox(),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(datesBorderRadius),
                            bottomRight: Radius.circular(datesBorderRadius),
                          ),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: dateSuitableDatesOnTap,
                  child: Stack(
                    children: [
                      SizedBox(
                        child: Container(
                          margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.symmetric(
                                      horizontal: BorderSide(
                                          color: datesBorderColor, width: 1))
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Container(
                              width: 40 / 2,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        child: Container(
                          margin: const EdgeInsets.all(4.0),
                          child: Container(
                            //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                            decoration: BoxDecoration(
                              border: datesBorderColor != null
                                  ? Border.all(
                                      color: datesBorderColor, width: 1)
                                  : null,
                              borderRadius: datesBorderRadius != null
                                  ? BorderRadius.only(
                                      topRight:
                                          Radius.circular(datesBorderRadius),
                                      bottomRight:
                                          Radius.circular(datesBorderRadius),
                                    )
                                  : null,
                              color: datesBackgroundColor,
                            ),
                            child: Center(
                              child: Text(
                                key: widgetKey,
                                pageViewElementDate.day.toString(),
                                style: datesTextStyle != null
                                    ? datesTextStyle.copyWith(
                                        color: datesTextColor,
                                      )
                                    : TextStyle(color: datesTextColor),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
// class CalendarStreakEndDenseSplashDate extends StatelessWidget {
//   const CalendarStreakEndDenseSplashDate(
//       {Key? key,
//       required this.pageViewElementDate,
//       required this.pageViewMonthDate})
//       : super(key: key);
//
//   final DateTime pageViewElementDate;
//   final DateTime pageViewMonthDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//         final DatesProperties dateSuitablePropertiesProviderValue = ref.watch(
//             dateSuitablePropertiesProvider(IndividualDateElementProperties(
//                     pageViewElementDate: pageViewElementDate,
//                     pageViewMonthDate: pageViewMonthDate))
//                 .select((value) => value));
//
//         DatesProperties datesProperties = dateSuitablePropertiesProviderValue;
//
//         Color? datesBackgroundColor =
//             datesProperties.decorationProperties?.datesBackgroundColor;
//         Color? datesTextColor =
//             datesProperties.decorationProperties?.datesTextColor;
//         TextStyle? datesTextStyle =
//             datesProperties.decorationProperties?.datesTextStyle;
//         Color? datesBorderColor =
//             datesProperties.decorationProperties?.datesBorderColor;
//         double? datesBorderRadius =
//             datesProperties.decorationProperties?.datesBorderRadius;
//
//         return InkWell(
//           // clipBehavior: Clip.antiAlias,
//           customBorder: const RoundedRectangleBorder(side: BorderSide.none),
//           borderRadius: datesBorderRadius != null
//               ? BorderRadius.only(
//                   topRight: Radius.circular(datesBorderRadius),
//                   bottomRight: Radius.circular(datesBorderRadius))
//               : null,
//           focusColor: Colors.transparent,
//           hoverColor: Colors.transparent,
//           highlightColor: Colors.transparent,
//           overlayColor: MaterialStateProperty.all(Colors.transparent),
//           splashColor: Colors.transparent,
//           splashFactory: NoSplash.splashFactory,
//           enableFeedback: false,
//           onTap: pageViewElementDate.month == pageViewMonthDate.month
//               ? () {
//                   // simulateTapOnAnOffset(
//                   //     getWidgetCenterOffsetInfo(widgetKey));
//                 }
//               : null,
//           child: Row(
//             children: [
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(
//                       top: 4.0,
//                       bottom: 4.0,
//                       left: pageViewElementDate.weekday == DateTime.sunday
//                           ? 4
//                           : 0),
//                   decoration: BoxDecoration(
//                     border: datesBorderColor != null
//                         ? Border.symmetric(
//                             horizontal:
//                                 BorderSide(color: datesBorderColor, width: 1))
//                         : null,
//                     color: datesBackgroundColor,
//                   ),
//                 ),
//               ),
//               datesBackgroundColor != null
//                   ? Container(
//                       margin: const EdgeInsets.only(top: 4, bottom: 4),
//                       child: SpaceFixerVerticalLine(
//                         overflowWidth: 1,
//                         overflowColor: datesBackgroundColor,
//                         border: datesBorderColor != null
//                             ? Border.symmetric(
//                                 horizontal: BorderSide(
//                                     color: datesBorderColor, width: 1))
//                             : null,
//                       ),
//                     )
//                   : const SizedBox(),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size.zero,
//                   padding: EdgeInsets.zero,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   foregroundColor: Theme.of(context).colorScheme.onSurface,
//                   side: BorderSide.none,
//                   shape: datesBorderRadius != null
//                       ? RoundedRectangleBorder(
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(datesBorderRadius),
//                             bottomRight: Radius.circular(datesBorderRadius),
//                           ),
//                         )
//                       : null,
//                 ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
//                 onPressed: pageViewElementDate.month == pageViewMonthDate.month
//                     ? () {
//                         // widget.onSelectedDate.call(widget.date);
//                       }
//                     : null,
//                 child: Stack(
//                   children: [
//                     SizedBox(
//                       child: Container(
//                         margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                             border: datesBorderColor != null
//                                 ? Border.symmetric(
//                                     horizontal: BorderSide(
//                                         color: datesBorderColor, width: 1))
//                                 : null,
//                             color: datesBackgroundColor,
//                           ),
//                           child: Container(
//                             width: 40 / 2,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: Container(
//                         margin: const EdgeInsets.all(4.0),
//                         child: Ink(
//                           decoration: BoxDecoration(
//                             border: datesBorderColor != null
//                                 ? Border.all(color: datesBorderColor, width: 1)
//                                 : null,
//                             borderRadius: datesBorderRadius != null
//                                 ? BorderRadius.only(
//                                     topRight:
//                                         Radius.circular(datesBorderRadius),
//                                     bottomRight:
//                                         Radius.circular(datesBorderRadius),
//                                   )
//                                 : null,
//                             color: datesBackgroundColor,
//                           ),
//                           child: Center(
//                             child: Text(
//                               pageViewElementDate.day.toString(),
//                               style: datesTextStyle != null
//                                   ? datesTextStyle.copyWith(
//                                       color: datesTextColor,
//                                     )
//                                   : TextStyle(color: datesTextColor),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const Expanded(
//                 child: SizedBox(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class CalendarStreakEndExpandedDate extends StatelessWidget {
  const CalendarStreakEndExpandedDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    final int startWeekday = getIntFromWeekday(calendarProperties.startWeekday);

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(datesBorderRadius),
                        bottomRight: Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4,
                  bottom: 4,
                  right: 4,
                  left: pageViewElementDate.weekday == startWeekday ? 4 : 0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border(
                          top: BorderSide(color: datesBorderColor, width: 1),
                          bottom: BorderSide(color: datesBorderColor, width: 1),
                          left: BorderSide(color: datesBorderColor, width: 1),
                          right: BorderSide(color: datesBorderColor, width: 1),
                        )
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.only(
                          topRight: Radius.circular(datesBorderRadius),
                          bottomRight: Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: Text(
                    pageViewElementDate.day.toString(),
                    style: datesTextStyle != null
                        ? datesTextStyle.copyWith(
                            color: datesTextColor,
                          )
                        : TextStyle(color: datesTextColor),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakSingleDenseDate extends StatelessWidget {
  const CalendarStreakSingleDenseDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    List<dynamic> eventMatch = [];
    if(calendarProperties.events != null){
      for (var event in calendarProperties.events!) {
        if(event['start_date'] == '${pageViewElementDate.year}-${pageViewElementDate.month.toString().padLeft(2,'0')}-${pageViewElementDate.day.toString().padLeft(2,'0')}'){
          if(eventMatch.length < 3) {
            eventMatch.add(event);
          }
        }
      }
    }

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                SizedBox(
                  width: 40,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                          decoration: BoxDecoration(
                            border: datesBorderColor != null
                                ? Border.all(color: datesBorderColor, width: 1)
                                : null,
                            borderRadius: datesBorderRadius != null
                                ? BorderRadius.all(
                                    Radius.circular(datesBorderRadius))
                                : null,
                            color: datesBackgroundColor,
                          ),
                          child: Center(
                            child: Text(
                              pageViewElementDate.day.toString(),
                              style: datesTextStyle != null
                                  ? datesTextStyle.copyWith(
                                      color: datesTextColor,
                                    )
                                  : TextStyle(color: datesTextColor),
                            ),
                          ),
                        ),
                        eventMatch.isEmpty ? const SizedBox() : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: eventMatch.map((e) {
                              return Container(
                                height: 6,
                                width: 6,
                                margin: const EdgeInsets.only(top: 2, left: 2, right: 2),
                                decoration: BoxDecoration(
                                    color: e['color'], borderRadius: BorderRadius.circular(6)
                                ),
                              );
                            }).toList()
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}

class CalendarStreakSingleDenseSplashDate extends StatelessWidget {
  const CalendarStreakSingleDenseSplashDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final GlobalKey widgetKey = GlobalKey();

    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            splashColor: Colors.transparent,
            splashFactory: NoSplash.splashFactory,
            enableFeedback: false,
            onTap: disable
                ? null
                : () {
                    Offset widgetCenterOffset =
                        getWidgetCenterOffsetInfo(widgetKey);
                    // print(widgetCenterOffset);
                    simulateTapOnAnOffset(widgetCenterOffset);
                  },
            child: Row(
              children: [
                const Expanded(
                  child: SizedBox(),
                ),
                InkResponse(
                  containedInkWell: true,
                  // highlightColor: Colors.blue,
                  highlightShape: BoxShape.rectangle,
                  customBorder: datesBorderRadius != null
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(datesBorderRadius)),
                        )
                      : null,
                  splashFactory: InkRipple.splashFactory,
                  onTap: dateSuitableDatesOnTap,
                  child: SizedBox(
                    width: 40,
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      child: Container(
                        //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                        decoration: BoxDecoration(
                          border: datesBorderColor != null
                              ? Border.all(color: datesBorderColor, width: 1)
                              : null,
                          borderRadius: datesBorderRadius != null
                              ? BorderRadius.all(
                                  Radius.circular(datesBorderRadius))
                              : null,
                          color: datesBackgroundColor,
                        ),
                        child: Center(
                          child: Text(
                            key: widgetKey,
                            pageViewElementDate.day.toString(),
                            style: datesTextStyle != null
                                ? datesTextStyle.copyWith(
                                    color: datesTextColor,
                                  )
                                : TextStyle(color: datesTextColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
// class CalendarStreakSingleDenseSplashDate extends StatelessWidget {
//   const CalendarStreakSingleDenseSplashDate(
//       {Key? key,
//       required this.pageViewElementDate,
//       required this.pageViewMonthDate})
//       : super(key: key);
//
//   final DateTime pageViewElementDate;
//   final DateTime pageViewMonthDate;
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (BuildContext context, WidgetRef ref, Widget? child) {
//         final DatesProperties dateSuitablePropertiesProviderValue = ref.watch(
//             dateSuitablePropertiesProvider(IndividualDateElementProperties(
//                     pageViewElementDate: pageViewElementDate,
//                     pageViewMonthDate: pageViewMonthDate))
//                 .select((value) => value));
//
//         DatesProperties datesProperties = dateSuitablePropertiesProviderValue;
//
//         Color? datesBackgroundColor =
//             datesProperties.decorationProperties?.datesBackgroundColor;
//         Color? datesTextColor =
//             datesProperties.decorationProperties?.datesTextColor;
//         TextStyle? datesTextStyle =
//             datesProperties.decorationProperties?.datesTextStyle;
//         Color? datesBorderColor =
//             datesProperties.decorationProperties?.datesBorderColor;
//         double? datesBorderRadius =
//             datesProperties.decorationProperties?.datesBorderRadius;
//
//         return InkWell(
//           // clipBehavior: Clip.antiAlias,
//           // customBorder: const RoundedRectangleBorder(side: BorderSide.none),
//           // borderRadius: datesBorderRadius != null
//           //     ? BorderRadius.all(Radius.circular(datesBorderRadius))
//           //     : null,
//           // focusColor: Colors.transparent,
//           // hoverColor: Colors.transparent,
//           // highlightColor: Colors.transparent,
//           // overlayColor: MaterialStateProperty.all(Colors.transparent),
//           splashColor: Colors.transparent,
//           splashFactory: NoSplash.splashFactory,
//           enableFeedback: false,
//           onTap: pageViewElementDate.month == pageViewMonthDate.month
//               ? () {
//                   // Offset widgetCenterOffset =
//                   //     getWidgetCenterOffsetInfo(widgetKey);
//                   // // print(widgetCenterOffset);
//                   // simulateTapOnAnOffset(widgetCenterOffset);
//                 }
//               : null,
//           child: Row(
//             children: [
//               const Expanded(
//                 child: SizedBox(),
//               ),
//               OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   minimumSize: Size.zero,
//                   // splashFactory: NoSplash.splashFactory,
//                   padding: EdgeInsets.zero,
//                   foregroundColor: Theme.of(context).colorScheme.onSurface,
//                   // backgroundColor: Theme.of(context).colorScheme.primary,
//                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                   side: BorderSide.none,
//                   // side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
//                   shape: datesBorderRadius != null
//                       ? RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(
//                               Radius.circular(datesBorderRadius)),
//                         )
//                       : null,
//                 ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
//                 onPressed: pageViewElementDate.month == pageViewMonthDate.month
//                     ? () {
//                         // widget.onSelectedDate.call(widget.date);
//                       }
//                     : null,
//                 child: SizedBox(
//                   width: 40,
//                   child: Container(
//                     margin: const EdgeInsets.all(4.0),
//                     child: Ink(
//                       decoration: BoxDecoration(
//                         border: datesBorderColor != null
//                             ? Border.all(color: datesBorderColor, width: 1)
//                             : null,
//                         borderRadius: datesBorderRadius != null
//                             ? BorderRadius.all(
//                                 Radius.circular(datesBorderRadius))
//                             : null,
//                         color: datesBackgroundColor,
//                       ),
//                       child: Center(
//                         child: Text(
//                           // key: widgetKey,
//                           pageViewElementDate.day.toString(),
//                           style: datesTextStyle != null
//                               ? datesTextStyle.copyWith(
//                                   color: datesTextColor,
//                                 )
//                               : TextStyle(color: datesTextColor),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const Expanded(
//                 child: SizedBox(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

class CalendarStreakSingleExpandedDate extends StatelessWidget {
  const CalendarStreakSingleExpandedDate(
      {Key? key,
      required this.calendarProperties,
      required this.pageViewElementDate,
      required this.pageViewDate})
      : super(key: key);

  final CalendarProperties calendarProperties;
  final DateTime pageViewElementDate;
  final DateTime pageViewDate;

  @override
  Widget build(BuildContext context) {
    final Function()? dateSuitableDatesOnTap = getSuitableDatesOnTap(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
    );

    final DatesProperties datesProperties = getSuitableDatesProperties(
      calendarProperties: calendarProperties,
      pageViewElementDate: pageViewElementDate,
      pageViewDate: pageViewDate,
    );

    Color? datesBackgroundColor =
        datesProperties.datesDecoration?.datesBackgroundColor;
    Color? datesTextColor = datesProperties.datesDecoration?.datesTextColor;
    TextStyle? datesTextStyle = datesProperties.datesDecoration?.datesTextStyle;
    Color? datesBorderColor = datesProperties.datesDecoration?.datesBorderColor;
    double? datesBorderRadius =
        datesProperties.datesDecoration?.datesBorderRadius;
    bool hide = datesProperties.hide ?? false;
    bool disable = datesProperties.disable ?? false;

    return !hide
        ? InkResponse(
            containedInkWell: true,
            highlightShape: BoxShape.rectangle,
            customBorder: datesBorderRadius != null
                ? RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(datesBorderRadius)),
                  )
                : null,
            splashFactory: InkRipple.splashFactory,
            onTap: disable ? null : dateSuitableDatesOnTap,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                //Replace here with Ink after this fix https://github.com/flutter/flutter/issues/73315
                decoration: BoxDecoration(
                  border: datesBorderColor != null
                      ? Border.all(color: datesBorderColor, width: 1)
                      : null,
                  borderRadius: datesBorderRadius != null
                      ? BorderRadius.all(Radius.circular(datesBorderRadius))
                      : null,
                  color: datesBackgroundColor,
                ),
                child: Center(
                  child: Text(
                    pageViewElementDate.day.toString(),
                    style: datesTextStyle != null
                        ? datesTextStyle.copyWith(
                            color: datesTextColor,
                          )
                        : TextStyle(color: datesTextColor),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
