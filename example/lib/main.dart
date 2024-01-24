import 'package:clean_calendar/clean_calendar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<DateTime> selectedDates = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text("Calendar"),
      ),
      body: Center(
        child: ListView(
          children: [
            Card(
              margin: const EdgeInsets.fromLTRB(24, 10, 24, 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
                child: CleanCalendar(
                    enableDenseViewForDates: true,
                    headerProperties: HeaderProperties(
                        navigatorDecoration: NavigatorDecoration(
                          navigatorResetButtonIcon: const Icon(Icons.today, size: 20),
                          navigateLeftButtonIcon: const Icon(Icons.chevron_left, size: 20),
                          navigateRightButtonIcon: const Icon(Icons.chevron_right, size: 20),
                        ),
                        monthYearDecoration: MonthYearDecoration(
                            monthYearTextStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                )),
                            monthYearTextColor: Colors.green)),
                    weekdaysProperties: WeekdaysProperties(
                        generalWeekdaysDecoration: WeekdaysDecoration(
                            weekdayTextStyle: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ))
                        )
                    ),
                    leadingTrailingDatesProperties: DatesProperties(
                      disable: true,
                      hide: false,
                      datesDecoration: DatesDecoration(
                          datesBorderRadius: 1000,
                          datesBackgroundColor: Colors.grey[100],
                          datesBorderColor: Colors.white,
                          datesTextStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 13,
                              ))),
                    ),
                    currentDateProperties: DatesProperties(
                      datesDecoration: DatesDecoration(
                          datesBorderRadius: 1000,
                          datesBackgroundColor: Colors.green.withOpacity(0.2),
                          datesBorderColor: Colors.green,
                          datesTextColor: Colors.green,
                          datesTextStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 13,
                              ))),
                    ),
                    generalDatesProperties: DatesProperties(
                      datesDecoration: DatesDecoration(
                          datesBorderRadius: 1000,
                          datesBackgroundColor: Colors.white,
                          datesBorderColor: Colors.white,
                          datesTextColor: Colors.black87,
                          datesTextStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 13,
                              ))),
                    ),
                    selectedDatesProperties:  DatesProperties(
                      datesDecoration: DatesDecoration(
                          datesBorderRadius: 1000,
                          datesBackgroundColor: Colors.green,
                          datesBorderColor: Colors.green,
                          datesTextColor: Colors.white,
                          datesTextStyle: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                fontSize: 13,
                              ))),
                    ),
                    dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
                    events: [{
                      "data_type": "Holiday",
                      "name": "Cuti Selangor",
                      "start_date": "2024-01-16",
                      "end_date": "2024-01-16",
                      "description": "",
                      "color": Colors.blue
                    }],
                    onEventClick: (v){
                        print(v);
                    },
                    ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CleanCalendar(
              datePickerCalendarView: DatePickerCalendarView.weekView,
              enableDenseViewForDates: true,
              datesForStreaks: [
                DateTime(2023, 01, 5),
                DateTime(2023, 01, 6),
                DateTime(2023, 01, 7),
                DateTime(2023, 01, 9),
                DateTime(2023, 01, 10),
                DateTime(2023, 01, 11),
                DateTime(2023, 01, 13),
                DateTime(2023, 01, 20),
                DateTime(2023, 01, 21),
                DateTime(2023, 01, 23),
                DateTime(2023, 01, 24),
                DateTime(2023, 01, 25),
              ],
              dateSelectionMode: DatePickerSelectionMode.singleOrMultiple,
              onCalendarViewDate: (DateTime calendarViewDate) {
                // print(calendarViewDate);
              },
              selectedDates: selectedDates,
              onSelectedDates: (List<DateTime> value) {
                setState(() {
                  if (selectedDates.contains(value.first)) {
                    selectedDates.remove(value.first);
                  } else {
                    selectedDates.add(value.first);
                  }
                });
                // print(selectedDates);
              },
            ),
            CleanCalendar(
              headerProperties: HeaderProperties(
                monthYearDecoration: MonthYearDecoration(
                  monthYearTextColor: Colors.amber,
                  monthYearTextStyle: Theme.of(context).textTheme.labelMedium,
                ),
                navigatorDecoration: NavigatorDecoration(
                  navigatorResetButtonIcon: const Icon(
                    Icons.restart_alt,
                    color: Colors.amber,
                  ),
                  navigateLeftButtonIcon: const Icon(
                    Icons.arrow_circle_left,
                    color: Colors.amber,
                  ),
                  navigateRightButtonIcon: const Icon(
                    Icons.arrow_circle_right,
                    color: Colors.amber,
                  ),
                ),
              ),
              datePickerCalendarView: DatePickerCalendarView.weekView,
              enableDenseViewForDates: true,
              enableDenseSplashForDates: true,
              datesForStreaks: [
                DateTime(2023, 01, 5),
                DateTime(2023, 01, 6),
                DateTime(2023, 01, 7),
                DateTime(2023, 01, 9),
                DateTime(2023, 01, 10),
                DateTime(2023, 01, 11),
                DateTime(2023, 01, 13),
                DateTime(2023, 01, 20),
                DateTime(2023, 01, 21),
                DateTime(2023, 01, 23),
                DateTime(2023, 01, 24),
                DateTime(2023, 01, 25),
              ],
              dateSelectionMode: DatePickerSelectionMode.disable,
              onCalendarViewDate: (DateTime calendarViewDate) {
                // print(calendarViewDate);
              },
              startWeekday: WeekDay.monday,
              weekdaysSymbol: const Weekdays(
                sunday: "s",
                monday: "m",
                tuesday: "t",
                wednesday: "w",
                thursday: "t",
                friday: "f",
                saturday: "s",
              ),
              monthsSymbol: const Months(
                  january: "Jan",
                  february: "Feb",
                  march: "Mar",
                  april: "Apr",
                  may: "May",
                  june: "Jun",
                  july: "Jul",
                  august: "Aug",
                  september: "Sep",
                  october: "Oct",
                  november: "Nov",
                  december: "Dec"),
              weekdaysProperties: WeekdaysProperties(
                generalWeekdaysDecoration:
                    WeekdaysDecoration(weekdayTextColor: Colors.red),
                sundayDecoration: WeekdaysDecoration(
                    weekdayTextColor: Colors.green,
                    weekdayTextStyle:
                        Theme.of(context).textTheme.headlineMedium),
                saturdayDecoration: WeekdaysDecoration(
                    weekdayTextColor: Colors.green,
                    weekdayTextStyle:
                        Theme.of(context).textTheme.headlineMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
