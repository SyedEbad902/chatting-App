import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class StoryPage extends StatefulWidget {
  final String userName;
  final List imageUrls;
  final String userProfileImage;

  const StoryPage(
      {super.key,
      required this.userName,
      required this.imageUrls,
      required this.userProfileImage});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final StoryController _storyController = StoryController();
  List<StoryItem> _storyItems = [];
  bool isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    // _preloadImages();
    _loadStories();
  }

  void _preloadImages() async {
    for (String url in widget.imageUrls) {
      await precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  void _loadStories() {
    setState(() {
      _storyItems = widget.imageUrls.map((url) {
        return StoryItem.pageImage(
          controller: _storyController,
          url: url,
          imageFit: BoxFit.contain,
          duration: Duration(seconds: 5),
          // caption: "Story from ${widget.userName}",
        );
      }).toList();
    });
    //   // setState(() {
    //   //   _storyItems = widget.imageUrls
    //   //       .map((url) => StoryItem.pageImage(
    //   //             url: url,
    //   //             controller: _storyController,
    //   //             // caption: "Story from ${widget.userName}",
    //   //           ))
    //   //       .toList();
    //   // });
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 24, left: 18, right: 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: Colors.black.withOpacity(0.4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    CachedNetworkImageProvider(widget.userProfileImage),
              ),
              title: Text(
                widget.userName,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              subtitle: Text("2 hrs ago",
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text("${widget.userName}'s Stories"),
      // ),
      body: _storyItems.isNotEmpty
          ? StoryView(
              storyItems: _storyItems,
              controller: _storyController,
              inline: false,
              repeat: false,
              onComplete: () {
                Navigator.pop(context);
              },
              onStoryShow: (storyItem, index) {
                if (!isImageLoaded) {
                  _storyController.pause(); // Pause until image is loaded
                }
              },
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
