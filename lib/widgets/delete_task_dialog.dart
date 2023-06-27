
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DeleteTaskDialog extends StatefulWidget {
  final String taskId, taskName;
   DeleteTaskDialog({Key? key,required this.taskId,required this.taskName}) : super(key: key);

  @override
  State<DeleteTaskDialog> createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<DeleteTaskDialog> {
  @override
  Widget build(BuildContext context) {
    return  AlertDialog(
      title: const Text("Delete Task" , textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green, fontSize: 16),),
      content: SingleChildScrollView(
        child: SizedBox(
         // height: height * 0.35,
         // width: width,
          child: Form(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text('Are you sure you want to delete this task?' ,
                  style: TextStyle(fontSize: 14.0),),
                 const SizedBox(height: 15,),
                 Text(widget.taskName ,
                  style: const TextStyle(fontSize: 14.0 , fontWeight: FontWeight.bold),),
                const SizedBox(height: 15),
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
            _deleteTask();
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
  Future<void> _deleteTask ()
  async {
    var collection = FirebaseFirestore.instance.collection('tasks');
    collection.doc(widget.taskId)
    .delete()
    .then((value) => Fluttertoast.showToast(msg: " Task deleted successfully",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
      fontSize: 14.0
    )).catchError((error) => Fluttertoast.showToast(msg: " Failed:$error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0
    ) );
  }

}
