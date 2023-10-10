
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intime_digital_interview/models.dart';
import 'package:intime_digital_interview/page02.dart';
import 'package:intime_digital_interview/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class Page01 extends StatefulWidget {
  const Page01({super.key});

  @override
  State<Page01> createState() => _Page01State();
}

class _Page01State extends State<Page01> {

  bool isDismissed = false;
  final userID = "SOL5GxNQ7LYeHM4jHe1G";

  List<AllUsers> allUsersDoc = [];
  List allFriendsDocs = [];
  List<ChatUserRecent> recentDocs = [];
  List<ChatUser> allPatientsList = [];
  int totUnreadMsgs = 0;

  @override
  void initState(){
    super.initState();
    loadChatData();
  }

  loadChatData() async {
    await getAllUsers();
    await getFriendsList();
    await getRecentActivities();
    await getAllPatientsList();
    await totalUnreadCount();
    setState(() {});
  }

  getAllUsers() async {
    allUsersDoc = await ChatServices(userID: userID).getAllUsers();
  }

  getFriendsList() async {
    allFriendsDocs = await ChatServices(userID: userID).getFriendsList();
    log(allFriendsDocs.length.toString());
  }

  getRecentActivities() async {
    recentDocs = await ChatServices(userID: userID).getrecentlist(allFriendsDocs);
    log(recentDocs.length.toString());
  }

  getAllPatientsList() async {
    allPatientsList = await ChatServices(userID: userID).getallpatientslist(allFriendsDocs);
    log(allPatientsList.length.toString());
  }

  totalUnreadCount() async {
    totUnreadMsgs = 0;
    for(var e in allPatientsList){
      totUnreadMsgs = totUnreadMsgs + e.unreadCount; 
    }
  }

  devinprogress(){
    return AlertDialog(
      title: const Text("Under Development"),
      content: const Text("Coming soon to a device near you.\n\nThis functionality is under development."),
      actions: [
        TextButton(onPressed: (){Navigator.pop(context);}, child: const Text("OK")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: const Text("Patients", style: TextStyle(color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.w500),),
        centerTitle: true,
        leading: IconButton(onPressed: (){showDialog(context: context, builder: (_)=> devinprogress());}, icon: const Icon(Icons.arrow_back_ios_new_rounded), color: Colors.black,),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 5.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 40.0, 0.0),
              child: Visibility(
                visible: !isDismissed,
                child: Column(
                  children: [
                    Container(
                      height: 180.0,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                        color: HexColor("3683FC").withOpacity(0.10),
                      ),
                      padding: const EdgeInsets.fromLTRB(18.0, 24.0, 18.0, 8.0),
                      child: Column(
                        children: [
                          const Expanded(
                            child: Text("Add, look up, update and run AI models for your patients, which makes it easier to track appointments and treatment process",
                                style: TextStyle(fontSize: 18.0),
                              ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                child: GradientText("Dismiss", style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500), colors: [HexColor("3683FC"), HexColor("21355C")]),
                                onTap: (){
                                  setState((){isDismissed = true;});
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 47.0,),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 0.0, 40.0, 0.0),
              child: Container(
                height: 40.0,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  color: HexColor("3683FC").withOpacity(0.10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(18.0, 9.5, 0.0, 9.5),
                      child: Text("Username, Name, Date...", style: TextStyle(color: HexColor("3683FC").withOpacity(0.3), fontWeight: FontWeight.w500, fontSize: 16.0),),
                    ),
                    IconButton(onPressed: (){showDialog(context: context, builder: (_)=> devinprogress());}, icon: const Icon(Icons.search), color: HexColor("707D8B"),)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 40.0, 0.0),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 14.0,),
                  const SizedBox(width: 8.0,),
                  Text("Use username or email to start a new chat", style: TextStyle(color: HexColor("20335B"), fontSize: 14.0),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 28.0, 16.0, 32.0),
              child: SizedBox(
                height: 32.0,
                width: MediaQuery.of(context).size.width/0.7,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  children: [
                    SizedBox(
                      width: 142, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))), backgroundColor: HexColor("3683FC").withOpacity(0.10), elevation: 0.0), 
                        onPressed: (){showDialog(context: context, builder: (_)=> devinprogress());},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/msg.png', height: 18.0, width: 18.0,),
                            const Text("Chats", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                            Container(
                              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(10.0)), color: HexColor("70FFB8"),),
                              height: 20.0,
                              width: 39.0,
                              child: Center(child: Text(totUnreadMsgs < 100 ? totUnreadMsgs.toString() : "99+", style: const TextStyle(color: Colors.black, fontSize: 12.0),)),
                            )
                          ],
                    ))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: SizedBox(
                      width: 142, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))), backgroundColor: HexColor("3683FC").withOpacity(0.10), elevation: 0.0), 
                        onPressed: (){showDialog(context: context, builder: (_)=> devinprogress());},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/personadd.png', height: 18.0, width: 18.0,),
                            const Text("New Patient", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                          ],
                      ))),  
                    ),
                    SizedBox(
                      width: 143, 
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))), backgroundColor: HexColor("3683FC").withOpacity(0.10), elevation: 0.0), 
                        onPressed: (){showDialog(context: context, builder: (_)=> devinprogress());},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset('assets/images/upload.png', height: 18.0, width: 18.0,),
                            const Text("Quick Upload", style: TextStyle(color: Colors.black, fontSize: 15.0),),
                          ],
                    ))),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.43,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 24.0, bottom: 18.0),
                        child: Row(
                          children: [
                            Text("Recent", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 18.0),
                        child: recentDocs.isEmpty ?
                        const Row(
                          children: [
                            Text("No recent activities"),
                          ],
                        ) :
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: recentDocs.length,
                          itemBuilder:(context, index) {
                            String uname = (recentDocs[index].username);
                            String unreadcount = (recentDocs[index].unreadCount > 0) ? "${recentDocs[index].unreadCount} unread messages" : "";      
                            int timediff = DateTime.now().difference(recentDocs[index].msgTime).inMinutes;
                            String timediffString = timediff < 5 ? "Just now" : timediff < 10 ? "5 mins ago" 
                            : timediff < 20 ? "10 mins ago" : timediff < 30 ? "20 mins ago" : timediff < 40 ? "30 mins ago" 
                            : timediff < 30 ? "20 mins ago" : timediff < 45 ? "30 mins ago"  : timediff < 60 ? "~1hr ago"  : timediff < 120 ? "1 hr ago"
                            : timediff < 180 ? "2 hrs ago" : timediff < 240 ? "3 hrs ago" : timediff < 300 ? "4 hrs ago" : "6 hrs ago";                      
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey,
                                child: uname.contains("John") ? Image.asset("assets/images/john_doe.png", height: 48.0, width: 48.0,) : Image.asset("assets/images/jane_doe.png", height: 48.0, width: 48.0,),
                              ),
                              title: Text(uname, style: const TextStyle(fontSize: 20.0),),
                              subtitle: Text("$timediffString, $unreadcount", style: const TextStyle(fontSize: 14.0),),
                            );
                          },),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0, bottom: 18.0),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Text("All Patients", style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w500),),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Recent first", style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),),
                            InkWell(child: GradientText(" - tap to filter", style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500), colors: [HexColor("3683FC"), HexColor("21355C")])),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 18.0),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: allPatientsList.length,
                      itemBuilder:(context, index) {
                        String uname = allPatientsList[index].username;
                        log(allPatientsList[index].toString());
                        log(allUsersDoc.toString());
                        var userDoc = allUsersDoc.firstWhere((e) => e.id.trim() == allPatientsList[index].id.trim());
                        bool userStatus = userDoc.status;
                        return ListTile(
                          onTap: () async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => Page02(friendname: allPatientsList[index].username, friendID: allPatientsList[index].id, userID: userID,)));
                            await loadChatData();
                          },
                          leading: CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: uname.contains("John") ? Image.asset("assets/images/john_doe.png", height: 48.0, width: 48.0,) : Image.asset("assets/images/jane_doe.png", height: 48.0, width: 48.0,),
                          ),
                          title: Text(uname, style: const TextStyle(fontSize: 20.0),),
                          subtitle: Text(allPatientsList[index].msg, style: const TextStyle(fontSize: 14.0),),
                          trailing: allPatientsList[index].unreadCount == 0 ? 
                          Image.asset("assets/images/msg.png", color: userStatus ? Colors.green : Colors.grey,)                           
                          : Stack(children: [Image.asset("assets/images/msgonlinefill.png"), Positioned(left: 7, top: 3, child: Text(allPatientsList[index].unreadCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),))]),
                        );
                      },),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}