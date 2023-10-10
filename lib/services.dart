import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intime_digital_interview/models.dart';

class ChatServices{
  String? userID;
  ChatServices({this.userID});

  var dbinstance = FirebaseFirestore.instance;

  getAllUsers() async {
    List<AllUsers> allUsers = [];
    await dbinstance.collection('chats').orderBy('username').get().then((snap){
      for(var doc in snap.docs){
        AllUsers user = AllUsers(id: doc.id, status: (doc.data() as dynamic)['isOnline']);
        allUsers.add(user);
      }
    });
    return allUsers;
  }
  
  getFriendsList() async {
    try{
      var friendsList = [];
      var friendscollection = dbinstance.collection('chats');
      await friendscollection.doc(userID).collection('friends').orderBy('username').get().then((frlist){
        if(frlist.docs.isNotEmpty){
          for(DocumentSnapshot doc in frlist.docs){
            friendsList.add(doc);
          }
        }
      });
      return friendsList;
    }catch(e){
      log(e.toString());
    }
  }

  getrecentlist(docs) async {
    try{
      var friendscollection = dbinstance.collection('chats');
      List<ChatUserRecent> recentDocs = [];
      int unread = 0;
      for(var doc in docs){
        await friendscollection.doc(userID).collection('friends').doc(doc.id).collection('msgs').orderBy('timestamp', descending: true).get().then((msgDocs) async {
          if(msgDocs.docs.isNotEmpty){
            for(var msg in msgDocs.docs){
              if((msg.data()as dynamic)["unread"]){
                unread++;
              }
            }
            var lastMsg = msgDocs.docs.first;
            DateTime latestMsgDt = DateTime.parse((lastMsg.data() as dynamic)["timestamp"].toDate().toString());
            var recentcutoff = DateTime.now().subtract(const Duration(hours: 6));
            log("$latestMsgDt, $recentcutoff, ${DateTime.now()}");
            if(latestMsgDt.isAfter(recentcutoff)){
              ChatUserRecent userData = ChatUserRecent(id: doc.id, username: (doc.data() as dynamic)["username"], avatarurl: "xxx", unreadCount: unread, msgTime: latestMsgDt);
              recentDocs.add(userData);
            }
          }
        });
      }
      log(recentDocs.length.toString());
      return recentDocs;
    }catch(e){
      log(e.toString());
    }
  }

  getallpatientslist(docs) async {
    try{
      var friendscollection = dbinstance.collection('chats');
      List<ChatUser> allpatientsList = [];
      int unread = 0;
      var lastMsg = "";
      for(var doc in docs){
        await friendscollection.doc(userID).collection('friends').doc(doc.id).collection('msgs').orderBy('timestamp', descending: true).get().then((msgDocs) async {
          if(msgDocs.docs.isNotEmpty){
            for(var msg in msgDocs.docs){
              if((msg.data()as dynamic)["unread"]){
                unread++;
              }
            }
            lastMsg = (msgDocs.docs.first.data() as dynamic)["msg"];
          }
          ChatUser userData = ChatUser(id: doc.id, username: (doc.data() as dynamic)["username"], avatarurl: "xxx", unreadCount: unread, msg: lastMsg);
          allpatientsList.add(userData);
        });
        lastMsg = "";
        unread = 0;
      }
      log(allpatientsList.length.toString());
      return allpatientsList;
    }catch(e){
      log(e.toString());
    }
  }

  uploadChat(tempText, userID, friendID, Msgs msg1, Msgs msg2) async {
    var userchatscollection = dbinstance.collection('chats').doc(userID).collection('friends').doc(friendID).collection('msgs');
    var friendchatscollection = dbinstance.collection('chats').doc(friendID).collection('friends').doc(userID).collection('msgs');
    await userchatscollection.add(msg1.toMap());
    await friendchatscollection.add(msg2.toMap());
  }

  deleteChat(userID, friendID, id) async {
    var userchatscollection = dbinstance.collection('chats').doc(userID).collection('friends').doc(friendID).collection('msgs');
    var friendchatscollection = dbinstance.collection('chats').doc(friendID).collection('friends').doc(userID).collection('msgs');
    await userchatscollection.doc(id).delete();
    await friendchatscollection.doc(id).delete();
  }

  markchatsasread(friendID) async {
    dbinstance.collection('chats').doc(userID).collection('friends').doc(friendID).collection('msgs').where('unread', isEqualTo: true).get().then((snap){
      for(var doc in snap.docs){
        doc.reference.update({'unread': false});
      }
    });
  }


}