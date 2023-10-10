class ChatUser{

  final String id;
  final String username;
  final String avatarurl;
  final String msg;
  final int unreadCount;

  ChatUser({
    required this.id,
    required this.username,
    required this.avatarurl,
    required this.msg,
    required this.unreadCount,
  });

  @override
  String toString() {
    return 'ChatUser{id: $id, username: $username, avatarurl: $avatarurl, msg: $msg, unreadCount: $unreadCount}';
  }
}

class ChatUserRecent{

  final String id;
  final String username;
  final String avatarurl;
  final int unreadCount;
  final DateTime msgTime;

  ChatUserRecent({
    required this.id,
    required this.username,
    required this.avatarurl,
    required this.unreadCount,
    required this.msgTime,
  });
  
  @override
  String toString() {
    return 'ChatUserRecent{id: $id, username: $username, avatarurl: $avatarurl, unreadCount: $unreadCount, msgTime: $msgTime}';
  }
}

class AllUsers{

  final String id;
  final bool status;

  AllUsers({
    required this.id,
    required this.status,
  });

  @override
  String toString() {
    return 'AllUsers{id: $id, status: $status}';
  }
}

class Msgs{
  final String author;
  final String msg;
  final DateTime timestamp;
  final bool unread;

  Msgs({
    required this.author,
    required this.msg,
    required this.timestamp,
    required this.unread,
  });

  @override
  String toString() {
    return 'AllUsers{author: $author, msg: $msg, timestamp: $timestamp, unread: $unread}';
  }

  Map<String,dynamic> toMap(){
    return {
      "author": author,
      "msg": msg,
      "timestamp": timestamp,
      "unread": unread,
    };
  }
}