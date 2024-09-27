import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gym_gram_app/models/comment.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        //        height: 60,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Container(
                padding: const EdgeInsets.only(left: 10),
                child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '$kBaseStorageUrl/users/${comment.user.photo}'))),
          ),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Container(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    comment.user.username,
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    comment.commentText,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Text(
              DateFormat('yMd').format(DateTime.parse(comment.date)),
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          )
        ]),
      ),
    );
  }
}
