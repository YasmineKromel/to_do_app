import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils/app_colors.dart';
import 'package:to_do_app/views/tasks.dart';

import '../widgets/add_task_dailog.dart';
import 'calender.dart';
import 'categories.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController  pageController = PageController(initialPage: 0);
  late int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar
      appBar: AppBar(
        centerTitle: true,
        title: const Text("To-Do List"),
        actions: [
          IconButton(onPressed: (){
            showDialog(context: context, builder: (BuildContext context){
              return const CalenderDialog();
            });
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return CalendarApp();
          //  }));
          }, icon: const Icon(CupertinoIcons.calendar),
          ),
        ],
      ),

      extendBody: true,

      //Floating Action Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context){
            return const AddTaskAlertDialog();
          });
        },
        child:  const Icon(Icons.add),
      ),
      
      //bottom navigation bar
      bottomNavigationBar: BottomAppBar(
        shape:  const CircularNotchedRectangle(),
        notchMargin: 6.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          //he kBottomNavigationBarHeight is a constant defined in the Flutter framework that represents the default height of the bottom navigation bar in Material Design. It is typically used to ensure consistent sizing and spacing within the app's UI.
          height: kBottomNavigationBarHeight ,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.green,
            unselectedItemColor: AppColors.greenUnselectedColor,
            onTap: (index){
              setState(() {
                _selectedIndex= index;
                pageController.jumpToPage(index);

              });
            },
            items: const[
              BottomNavigationBarItem(icon:
              Icon(CupertinoIcons.square_list),
              label: ''),
              BottomNavigationBarItem(icon:
              Icon(CupertinoIcons.tag),
                  label: ''),
            ],
          ),
        ),
      ),

      body: PageView(
        controller: pageController,
        children:const <Widget> [
          Center(
            child: Tasks(),
          ),
          Center(
            child: Categories(),
          ),
        ],
      ),

    );
  }
}
