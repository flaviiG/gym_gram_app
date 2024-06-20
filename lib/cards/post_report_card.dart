import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/workout_card.dart';
import 'package:gym_gram_app/models/post_report.dart';
import 'package:gym_gram_app/providers/post_reports_provider.dart';
import 'package:gym_gram_app/screens/post_details_screen.dart';
import 'package:gym_gram_app/screens/profile_screen.dart';
import 'package:gym_gram_app/utils/globals.dart';
import 'package:gym_gram_app/utils/transparent_route.dart';

class PostReportCard extends ConsumerStatefulWidget {
  const PostReportCard({super.key, required this.report});

  final PostReport report;

  @override
  ConsumerState<PostReportCard> createState() => _PostReportCardState();
}

class _PostReportCardState extends ConsumerState<PostReportCard> {
  //
  void _markPostAsOk() async {
    ref.read(postReportsProvider.notifier).markPostAsOk(widget.report.id);
  }

  void _deletePost() async {
    ref
        .read(postReportsProvider.notifier)
        .deletePostAndReport(widget.report.id, widget.report.post.id);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10),
            height: 32,
            width: double.infinity,
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userId: widget.report.post.user.id,
                        username: widget.report.post.user.username,
                      ),
                    ));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        '$kBaseStorageUrl/users/${widget.report.post.user.photo}'),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 7),
                    child: Text(
                      widget.report.post.user.username,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).push(TransparentRoute(
                    builder: (ctx) =>
                        PostDetailsScreen(post: widget.report.post))),
                child: CachedNetworkImage(
                  imageUrl:
                      '$kBaseStorageUrl/posts/${widget.report.post.user.id}/${widget.report.post.photo}',
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
              Expanded(
                child: WorkoutCard(
                    workout: widget.report.post.workout, isSelectable: false),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
              margin: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerLeft,
              child: Text(widget.report.post.description)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ReportButton(
                  text: 'Mark as ok',
                  onTap: _markPostAsOk,
                  color: CupertinoColors.activeBlue),
              ReportButton(
                  text: 'Delete post',
                  onTap: _deletePost,
                  color: CupertinoColors.systemRed)
            ],
          )
        ],
      ),
    ));
  }
}

class ReportButton extends StatelessWidget {
  const ReportButton(
      {super.key,
      required this.text,
      required this.onTap,
      required this.color});

  final String text;
  final void Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 150,
      child: CupertinoButton(
        padding: const EdgeInsets.all(0),
        color: color,
        onPressed: onTap,
        child: Text(
          text,
          style: const TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
