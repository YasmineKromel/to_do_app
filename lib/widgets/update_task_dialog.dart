import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdateTaskAlretDialog extends StatefulWidget {
  final String taskId, taskName, taskDesc,taskTag;
   UpdateTaskAlretDialog({Key? key , required this.taskId,
     required this.taskName,
     required this.taskDesc,
     required this.taskTag}) : super(key: key);

  @override
  State<UpdateTaskAlretDialog> createState() => _UpdateTaskAlretDialogState();
}

class _UpdateTaskAlretDialogState extends State<UpdateTaskAlretDialog> {
  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController taskDescController = TextEditingController();
  final List<String> taskTags = ['Work', 'School', 'Other'];
  String selectedValue = 'Work';
  
  @override
  Widget build(BuildContext context) {
    taskNameController.text = widget.taskName;
    taskDescController.text = widget.taskDesc;
    
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    
    return AlertDialog(
      title: const Text("Update Task" , textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green, fontSize: 16),),
      content: SingleChildScrollView(
        child: SizedBox(
          height: height * 0.35,
          width: width,
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: taskNameController,
                  style: const TextStyle(fontSize: 14,),
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    // hintText: 'Task',
                    // hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.square_list ,color:
                    Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),


                ),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: taskDescController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: const TextStyle(fontSize: 14,),
                  decoration:  InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    // hintText: 'Description',
                    // hintStyle: const TextStyle(fontSize: 14),
                    icon: const Icon(CupertinoIcons.bubble_left_bubble_right ,color:
                    Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),


                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Icon(CupertinoIcons.tag, color: Colors.green),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child:  DropdownButtonFormField2<String>(
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          isExpanded: true,
                          // hint: const Text(
                          //   'Add a task tag',
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          buttonStyleData: ButtonStyleData(
                              height: 60,
                              padding: const EdgeInsets.only(left:20, right:20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              )
                          ),
                          value: widget.taskTag,
                          items: taskTags.map(
                                  (String item) {
                                return  DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(item,style:const TextStyle(fontSize: 14
                                    )
                                    )
                                );
                              }
                          ).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              if(value != null)
                              {
                                selectedValue = value;
                              }
                            });
                          }
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      actions: [
        ElevatedButton(onPressed: (){
          Navigator.of(context, rootNavigator: true).pop();
        },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          child:const Text('Cancel'), ),
        ElevatedButton(
          onPressed: () {
            final taskName = taskNameController.text;
            final taskDesc = taskDescController.text;
            var taskTag = '';
            selectedValue == ''? taskTag = widget.taskTag : taskTag = selectedValue;
            _updateTasks(taskName, taskDesc, taskTag);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('update'),
        ),
      ],
    );
  }
  Future<void> _updateTasks (String taskName, String taskDesc, String taskTag) async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection.doc(widget.taskId).update({
      'taskName': taskName,
      'taskDesc':taskDesc,
      'taskTag': taskTag,
    }).then((value) => Fluttertoast.showToast(msg: "Task updated sucessfully",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,
    )).catchError((onError)=> Fluttertoast.showToast(msg: "Failed:$onError",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0,)
    );
  }
}
