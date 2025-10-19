import 'package:captain_drive/features/map/passenger/presentation/views/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/storage/cache_helper.dart';
import '../../../core/localization/localization_cubit.dart';

class ChooseDateTimeScreen extends StatefulWidget {
  const ChooseDateTimeScreen({super.key});

  @override
  _ChooseDateTimeScreenState createState() => _ChooseDateTimeScreenState();
}

class _ChooseDateTimeScreenState extends State<ChooseDateTimeScreen> {
  DateTime? _selectedDate = DateTime.now(); // Initialize with current date
  TimeOfDay? _selectedTime = TimeOfDay.now(); // Initialize with current time

// Function to handle date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

// Function to handle time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

// Function to combine the selected date and time into a DateTime object
  String _combineDateAndTime(DateTime date, TimeOfDay time) {
    final DateTime combinedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    return "${combinedDateTime.year}-${combinedDateTime.month.toString().padLeft(2, '0')}-${combinedDateTime.day.toString().padLeft(2, '0')} "
        "${combinedDateTime.hour.toString().padLeft(2, '0')}:${combinedDateTime.minute.toString().padLeft(2, '0')}:00";
  }

// Function to get the date in Arabic format
  String _getFormattedArabicDate(DateTime date) {
    const List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    const List<String> arabicDays = [
      'الأحد',
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت'
    ];

    String dayName = arabicDays[date.weekday % 7];
    String monthName = arabicMonths[date.month - 1];
    return "$dayName، ${date.day} $monthName ${date.year}";
  }

// Function to get the date in English format
  String _getFormattedEnglishDate(DateTime date) {
    const List<String> englishMonths = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    const List<String> englishDays = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    String dayName = englishDays[date.weekday % 7];
    String monthName = englishMonths[date.month - 1];
    return "$dayName, ${date.day} $monthName ${date.year}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadLanguage();
  }

  String? languageCode; // Variable to hold the language code

  Future<void> loadLanguage() async {
    languageCode = await CacheHelper.getData(key: 'languageCode') ??
        'en'; // Default to 'en' if not set
    context.read<LocalizationCubit>().loadLanguage(languageCode!);
  }

  @override
  Widget build(BuildContext context) {
    bool isArabic = LocalizationCubit.get(context).isArabic();

    String formattedDateTime =
        _combineDateAndTime(_selectedDate!, _selectedTime!);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row with back button and title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios),
                  ),
                  const Spacer(),
                  Text(
                    isArabic ? 'اختر موعدا للالتقاء' : 'Choose a time to meet',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 40),

              // Choose Date Section
              _buildOptionCard(
                context,
                isArabic ? 'اختر التاريخ' : 'Select date',
                _selectedDate == null
                    ? isArabic
                        ? 'اختر التاريخ'
                        : 'Select date'
                    : isArabic
                        ? 'التاريخ المختار: ${_getFormattedArabicDate(_selectedDate!)}'
                        : 'Selected date: ${_getFormattedEnglishDate(_selectedDate!)}',
                Icons.calendar_today,
                _selectDate,
              ),

              const SizedBox(height: 20),

              // Choose Time Section
              _buildOptionCard(
                context,
                isArabic ? 'اختر الوقت' : 'Choose the time',
                _selectedTime == null
                    ? isArabic
                        ? 'اختر الوقت'
                        : 'Choose the time'
                    : isArabic
                        ? 'الوقت المختار: ${_selectedTime!.format(context)}'
                        : 'Selected time: ${_selectedTime!.format(context)}',
                Icons.access_time,
                _selectTime,
              ),

              const Spacer(),

              // Confirm Button
              ElevatedButton(
                onPressed: () {
                  if (_selectedDate != null && _selectedTime != null) {
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(
                    //       'تم اختيار ${_getFormattedArabicDate(_selectedDate!)} في ${_selectedTime!.format(context)}',
                    //     ),
                    //   ),
                    // );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapScreen(
                          booking: true,
                          selectedDate: _selectedDate,
                          selectedTime: _selectedTime,
                          formattedDateTime: formattedDateTime,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('يرجى اختيار التاريخ والوقت'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isArabic ? 'التالي' : 'Next',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for building option cards for selecting date and time
  // Widget for building option cards for selecting date and time
  Widget _buildOptionCard(BuildContext context, String title, String subtitle,
      IconData icon, Future<void> Function(BuildContext) onPressed) {
    return GestureDetector(
      onTap: () {
        onPressed(
            context); // Wrapping the future-returning function in a non-returning callback
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 2,
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.blue.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
