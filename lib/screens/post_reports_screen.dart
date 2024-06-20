import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/cards/post_report_card.dart';
import 'package:gym_gram_app/providers/post_reports_provider.dart';

class PostReportsScreen extends ConsumerStatefulWidget {
  const PostReportsScreen({super.key});

  @override
  ConsumerState<PostReportsScreen> createState() => _PostReportsScreenState();
}

class _PostReportsScreenState extends ConsumerState<PostReportsScreen> {
  @override
  Widget build(BuildContext context) {
    //
    final reportsAsync = ref.watch(fetchReportsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: reportsAsync.when(
        data: (_) => Consumer(builder: (context, ref, _) {
          final reports = ref.watch(postReportsProvider);
          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) =>
                PostReportCard(report: reports[index]),
          );
        }),
        error: (error, stackTrace) {
          print(stackTrace);
          return Center(
            child: Text(error.toString()),
          );
        },
        loading: () => const CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
