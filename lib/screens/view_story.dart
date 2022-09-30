import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class ViewStory extends StatefulWidget {
  final String name;
  final DateTime date;
  final List story;

  const ViewStory({
    super.key,
    required this.name,
    required this.story,
    required this.date,
  });

  @override
  State<ViewStory> createState() => _ViewStoryState();
}

class _ViewStoryState extends State<ViewStory> {
  final storyController = StoryController();
  List<StoryItem> storyItem = [];

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < widget.story.length; i++) {
      storyItem.add(
        StoryItem.pageImage(
          url: widget.story[i],
          controller: storyController,
        ),
      );
    }

    return Scaffold(
      body: (storyItem.isEmpty)
          ? Text("no stories here")
          : StoryView(
              onComplete: (() {
                Navigator.of(context).pop();
              }),
              storyItems: storyItem,
              controller: storyController,
              progressPosition: ProgressPosition.top,
              repeat: false,
            ),
    );
  }
}
