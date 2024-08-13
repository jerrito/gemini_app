import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonPage extends StatefulWidget {
  const SkeletonPage({super.key});

  @override
  State<SkeletonPage> createState() => _SkeletonPageState();
}

class _SkeletonPageState extends State<SkeletonPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      isLoading = !isLoading;
      setState(() {});
    });
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Skeleton Test"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(),
          child: Column(
            children: [
              Skeletonizer(
                enabled: isLoading,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const Card(
                        child: ListTile(
                      title: Text("users[index].name"),
                      subtitle: Text("users[index].jobTitle"),
                      leading: SizedBox(
                        width: 48, // width of replacement
                        height: 48, // height of replacement
                        child: Skeleton.leaf(
                          child: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                                "https://img-cdn.pixlr.com/image-generator/history/65bb506dcb310754719cf81f/ede935de-1138-4f66-8ed7-44bd16efc709/medium.webp"),
                          ),
                        ),
                      ),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
