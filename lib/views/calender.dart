
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../taskModel.dart';


class CalenderDialog extends StatefulWidget {
  const CalenderDialog({Key? key}) : super(key: key);

  @override
  State<CalenderDialog> createState() => _CalenderDialogState();
}

class _CalenderDialogState extends State<CalenderDialog> {
  late QuerySnapshot querySnapshot;
   final List<Color> _colorCollection = <Color>[];
  final List<String> options = <String>['Add', 'Delete'];

  @override
  void initState() {
    _initializeEventColor();
    getDataFromDatabase().then(
            (results) {
          setState(() {
            if (results != null) {
              querySnapshot = results;
            }
          });
        }
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;
    return AlertDialog(
      scrollable: true,
      title:   const Text("Upcoming Events", textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green, fontSize: 16),),
      content: SizedBox(
        height: height * 0.45,
        width: width,
        child: _showCalendar(),
      ),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child: const Text('Cancel'),),
        // ElevatedButton(
        //   onPressed: () {
        //     Navigator.of(context, rootNavigator: true).pop();
        //   },
        //   child:   const Text('Save'),
        // ),
      ],
    );

    // return Scaffold(
    //   body: _showCalendar(),
    // );

  }

  // show calender

  _showCalendar() {
    if (querySnapshot.size != 0) {
      List<TaskModel> collection = [];
     querySnapshot.docs.map((doc) {
       Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
       if(data.isNotEmpty)
         {
           TaskModel model = TaskModel(data['taskName'], data['taskDesc'],data['taskDate'] ,data['taskTime'] , data['taskId'], data['taskTag']);
           collection.add(model);
         }
       else {
         return   const Center(
           child: CircularProgressIndicator(),
         );
       }
     });
      return SfCalendar(
        view: CalendarView.timelineMonth,
        allowedViews:   const [
          CalendarView.timelineDay,
          CalendarView.timelineWeek,
          CalendarView.timelineWorkWeek,
          CalendarView.timelineMonth,
        ],
        initialDisplayDate: DateTime(2023, 5, 1, 0, 0, 0),
        dataSource: _getCalendarDataSource(collection),
        monthViewSettings:   const MonthViewSettings(appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
      );
    }
  }

  MeetingDataSource _getCalendarDataSource(List<TaskModel> collection) {
  List<TaskModel> dates = collection ?? <TaskModel>[];
  List<CalendarResource> resourceColl = <CalendarResource>[];
  resourceColl.add(CalendarResource(
    displayName: 'Willy',
    id: '0001',
    color: Colors.green,
  ));
  return MeetingDataSource(dates, resourceColl);
}



  void _initializeEventColor() {
    _colorCollection.add(  const Color(0xFF0F8644));
    _colorCollection.add(  const Color(0xFF8B1FA9));
    _colorCollection.add(  const Color(0xFFD20100));
    _colorCollection.add(  const Color(0xFFFC571D));
    _colorCollection.add(  const Color(0xFF36B37B));
    _colorCollection.add(  const Color(0xFF01A1EF));
    _colorCollection.add(  const Color(0xFF3D4FB5));
    _colorCollection.add(  const Color(0xFFE47C73));
    _colorCollection.add(  const Color(0xFF636363));
    _colorCollection.add(  const Color(0xFF0A8043));
  }

  // get calender data
  getDataFromDatabase() async {
    try {
      CollectionReference tasksRef = FirebaseFirestore.instance.collection(
          'tasks');
      QuerySnapshot snapshot = await tasksRef.get();

      // responseContent = snapshot.docs.map((doc) => doc.data()).toList();
      return snapshot;
    }
    catch (error) {
      print(error);
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<TaskModel> source, List<CalendarResource> resourceColl) {
    appointments = source;
    resources = resourceColl;
  }

  @override
  DateTime getStartTime(int index) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(_getMeetingData(index).taskTime);
    return tempDate ;
  }

  @override
  DateTime getEndTime(int index) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(_getMeetingData(index).taskTime);
    return tempDate;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).taskName;
  }

  @override
  Color getColor(int index) {
    return Colors.brown;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  TaskModel _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final TaskModel meetingData;
    if (meeting is TaskModel) {
      meetingData = meeting;
    }

    return meetingData;
  }

}