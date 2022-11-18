import 'package:flutter/material.dart';
import 'package:tudo_em_casa_receitas/model/notification_model.dart';
import 'package:tudo_em_casa_receitas/support/local_variables.dart';

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  const NotificationTile({required this.notification, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: notification.isViewed
          ? Colors.transparent
          : Theme.of(context).textTheme.bodySmall!.color!.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              notification.title,
              maxLines: 1,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 16,
                  fontWeight: notification.isViewed
                      ? FontWeight.normal
                      : FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: notification.isViewed
                      ? FontWeight.normal
                      : FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 9.0, bottom: 4.0),
            child: Text(
              LocalVariables.checkDate(notification.dateNotification),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontFamily: "Arial",
                  fontSize: 13,
                  fontWeight: notification.isViewed
                      ? FontWeight.normal
                      : FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
