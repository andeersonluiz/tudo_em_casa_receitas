import 'dart:convert';

import 'package:intl/intl.dart';

class NotificationModel {
  String title;
  String body;
  bool isViewed;
  DateTime dateNotification;
  NotificationModel({
    required this.title,
    required this.body,
    required this.isViewed,
    required this.dateNotification,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json,
      {bool isViewed = false, dynamic dateNotification}) {
    dateNotification ??= DateTime.now();
    if (dateNotification is String) {
      print("é string ${dateNotification.runtimeType}");
      return NotificationModel(
          title: json['title'],
          body: json['body'],
          isViewed: isViewed,
          dateNotification:
              DateFormat("yyyy-MM-dd hh:mm:ss").parse(dateNotification));
    }
    print("n é  string");
    return NotificationModel(
        title: json['title'],
        body: json['body'],
        isViewed: isViewed,
        dateNotification: dateNotification);
  }

  toJson() => {
        "title": title,
        "body": body,
        "isViewed": isViewed,
        "dateNotification":
            DateFormat("yyyy-MM-dd hh:mm:ss").format(dateNotification),
      };

  static String encode(List<NotificationModel> notifications) => json.encode(
        notifications.map<Map<String, dynamic>>((notification) {
          print("encode");
          print(notification);
          return notification.toJson();
        }).toList(),
      );
  static List<NotificationModel> decode(String notifications) =>
      (json.decode(notifications) as List<dynamic>)
          .map<NotificationModel>((notification) {
        print(notification);
        return NotificationModel.fromJson(notification,
            isViewed: notification["isViewed"],
            dateNotification: notification["dateNotification"]);
      }).toList();

  @override
  String toString() {
    return "$title : $isViewed";
  }
}
