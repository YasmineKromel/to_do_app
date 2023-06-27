
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/utils/app_colors.dart';

import '../widgets/delete_task_dialog.dart';
import '../widgets/update_task_dialog.dart';
import 'package:share_plus/share_plus.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child:StreamBuilder<QuerySnapshot>(
        stream:fireStore.collection('tasks').snapshots(),
        builder:(context,snapshot) {
          if(!snapshot.hasData)
            {
              return const Center(child: Text('No tasks to display', style: TextStyle(fontSize: 14),));
            }else{
            return ListView(
              shrinkWrap: true,
             children: snapshot.data!.docs.map((DocumentSnapshot document)
              {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                Color taskColor = AppColors.blueShadeColor;
                var taskTag = data['taskTag'];
                if(taskTag == 'Work'){
                  taskColor = AppColors.salmonColor;
                }
                else if(taskTag == 'School')
                  {
                    taskColor = AppColors.greenShadeColor;
                  }
                return  Container(
                  height: 100,
                  margin:  const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
                      boxShadow: const [BoxShadow(
                          color: AppColors.shadowColor,
                          blurRadius: 5.0,
                          offset: Offset(0,5) //shadow direction: bottom right
                      )]
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      padding:  const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(backgroundColor: taskColor,),
                    ),
                    title: Text("${data['taskName']} \n"),
                    subtitle: Text("${data['taskDesc']} \n ${data['taskTime']} | ${data['taskDate']}" ),
                    isThreeLine: true,
                    trailing: PopupMenuButton(itemBuilder: (BuildContext context) {
                      return [
                         PopupMenuItem(
                          value: 'edit',
                          child: const Text('Edit', style: TextStyle(fontSize: 13.0),),
                           onTap:(){
                             String taskId = (data['id']);
                             String taskName = (data['taskName']);
                             String taskDesc = (data['taskDesc']);
                             String taskTag = (data['taskTag']);
                             Future.delayed(
                               const Duration(seconds: 0),
                                   ()=> showDialog(context: context, builder: (context) => UpdateTaskAlretDialog(taskId: taskId,
                                     taskDesc: taskDesc,taskName:taskName, taskTag: taskTag ,)),
                             );
                           } ,
                        ),
                         PopupMenuItem(
                          value: 'delete',
                          child: const Text('Delete', style: TextStyle(fontSize: 13.0),),
                          onTap: (){
                            String taskId = (data['id']);
                            String taskName = (data['taskName']);
                            Future.delayed(
                              const Duration(seconds: 0),
                                  ()=> showDialog(context: context, builder: (context) => DeleteTaskDialog(taskId: taskId, taskName: taskName,)),
                            );

                          },
                        ),
                         PopupMenuItem(
                          value: 'share',
                          child: const Text('Share', style: TextStyle(fontSize: 13.0),),
                          onTap: (){
                            String message = ("${data['taskName']} \n ${data["taskDesc"]}");
                            Future.delayed(
                              const Duration(seconds: 0),
                                  ()=> Share.share(message),
                            );

                          },
                        ),
                      ];
                    },

                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
      // child: ListView(
      //   children: ,
      // ),
    );
  }
  

}
