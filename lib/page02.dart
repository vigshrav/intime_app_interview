// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intime_digital_interview/models.dart';
import 'package:intime_digital_interview/services.dart';

class Page02 extends StatefulWidget {
  const Page02({super.key, required this.friendname, required this.friendID, required this.userID});
  final String friendname;
  final String friendID;
  final String userID;

  @override
  State<Page02> createState() => _Page02State();
}

class _Page02State extends State<Page02> {

  List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  TextEditingController chatTxtController = TextEditingController();
  bool sendEnabled = true;

  @override
  void initState(){
    super.initState();
    ChatServices(userID: widget.userID).markchatsasread(widget.friendID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor("3683FC").withOpacity(0.10),
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios_new_rounded), color: Colors.black,),
        title: Text(widget.friendname, style: const TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('chats').doc(widget.userID).collection("friends").doc(widget.friendID).collection('msgs').orderBy("timestamp", descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot ) {
                if(snapshot.connectionState == ConnectionState.waiting){ return const Center(child: CircularProgressIndicator()); }
                if(snapshot.hasData){
                  var chatitems = snapshot.data!.docs;
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: HexColor("3683FC").withOpacity(0.10),
                    child: ListView.builder(
                      shrinkWrap: true,
                      reverse: true,
                      itemCount: chatitems.length,
                      itemBuilder: (context, index) {
                        var dt = DateTime.parse((chatitems[index].data() as dynamic)['timestamp'].toDate().toString());
                        var d = dt.day.toString().padLeft(2, '0');
                        var _m = dt.month;
                        var m = months[_m-1];
                        var mm = dt.minute.toString().padLeft(2, '0');
                        var _hh = dt.hour;
                        var hh = _hh.toString();
                        var ampm = 'am';
                        if(_hh>=12){
                          ampm = 'pm';
                          hh = (_hh-12).toString().padLeft(2,'0');
                        } else {hh = hh.toString().padLeft(2, '0');}
                        var author = (chatitems[index].data() as dynamic)['author'];
          
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Dismissible(
                            key: Key(chatitems[index].id),
                            background: Container(color:Colors.grey.withOpacity(0.5), child: const Center(child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [Icon(Icons.delete, color: Colors.red,), SizedBox(width: 10.0,), Text('DELETE', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, letterSpacing: 0.9)), const SizedBox(width: 10.0,)],)),),
                            direction: author == widget.userID ? DismissDirection.endToStart : DismissDirection.none,
                            onDismissed: (direction) async {
                              await ChatServices(userID: widget.userID).deleteChat(widget.userID, widget.friendID, chatitems[index].id);
                              await showDialog(context: context, builder: ((context) {
                                return AlertDialog(
                                  title: const Text('Chat Deleted'),
                                  content: const Text('The selected Chat entry has been deleted.'),
                                  actions: [TextButton(child: const Text('OK'), onPressed: (){Navigator.pop(context);},)],
                                );
                              }));
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: author == widget.userID ? const EdgeInsets.only(right : 20.0) : const EdgeInsets.only(left : 20.0),
                                  child: Row(
                                    mainAxisAlignment: author == widget.userID ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        constraints: const BoxConstraints(
                                            maxWidth: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          color: HexColor("3683FC").withOpacity(0.30),
                                          borderRadius: author == widget.userID 
                                                  ? const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0),)
                                                  : const BorderRadius.only(topRight: Radius.circular(10.0), topLeft: Radius.circular(10.0), bottomRight: Radius.circular(10.0),) ,
                                        ),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: author == widget.userID ? MainAxisAlignment.end : MainAxisAlignment.start,
                                          children: [
                                            Expanded(child: Text((chatitems[index].data() as dynamic)['msg']))
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: author == widget.userID ? const EdgeInsets.only(right : 20.0) : const EdgeInsets.only(left : 20.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: author == widget.userID ? MainAxisAlignment.end : MainAxisAlignment.start,
                                    children: [
                                      Text('$d $m $hh:$mm $ampm', style: const TextStyle(color: Colors.black, fontSize: 12.0)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return const Center(
                    child: Text("No messages here. Please start a conversation."),
                  );
                }
              }
            ),
          ),
          Container(
            color: HexColor("3683FC").withOpacity(0.10),
            height: 56.0, 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: TextFormField(
                      controller: chatTxtController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(31.0)),
                            borderSide: BorderSide.none,
                          ),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(31.0)),
                            borderSide: BorderSide.none,
                          ),
                        hintText: 'Type message here ...', 
                        hintStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500, color: HexColor('BFC4D0')),
                        fillColor: HexColor('F5F8FE'),
                        filled: true,
                        suffixIcon: InkWell(
                          child: Icon(Icons.send, color: HexColor("3683FC").withOpacity(0.90)),
                          onTap: () async {
                            if(sendEnabled && chatTxtController.text != ''){
                              setState((){sendEnabled = false;});
                              var tempText = chatTxtController.text;
                              chatTxtController.clear();
                              Msgs msgObj1 = Msgs(author: widget.userID, msg: tempText, timestamp: DateTime.now(), unread: false);
                              Msgs msgObj2 = Msgs(author: widget.userID, msg: tempText, timestamp: DateTime.now(), unread: true);
                              await ChatServices(userID: widget.userID).uploadChat(tempText, widget.userID, widget.friendID, msgObj1, msgObj2);
                              chatTxtController.clear();
                              setState((){sendEnabled = true;});
                            }
                          },
                        ),
                        contentPadding: const EdgeInsets.only(left: 20.0)
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                )
              ],
            ), 
          ),
        ],
      ),
    );
  }
}