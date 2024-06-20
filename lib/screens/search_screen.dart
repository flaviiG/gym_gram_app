import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_gram_app/providers/user_provider.dart';
import 'package:gym_gram_app/screens/my_profile_screen.dart';
import 'package:gym_gram_app/screens/profile_screen.dart';
import 'package:gym_gram_app/services/user_api.dart';

class SearchSreen extends ConsumerStatefulWidget {
  const SearchSreen({super.key});

  @override
  ConsumerState<SearchSreen> createState() => _SearchSreenState();
}

class _SearchSreenState extends ConsumerState<SearchSreen> {
  final TextEditingController searchController = TextEditingController();
  bool showUsers = false;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: TextFormField(
          onTap: () => setState(() {
            showUsers = false;
          }),
          decoration: const InputDecoration(
            labelText: 'Search for a user',
          ),
          controller: searchController,
          onFieldSubmitted: (String _) {
            setState(() {
              showUsers = true;
            });
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: showUsers == false
          ? Container()
          : FutureBuilder(
              future: searchUser(searchController.text),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: LinearProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No user found'),
                  );
                }

                return ListView.builder(
                    itemCount: (snapshot.data!.length),
                    itemBuilder: (context, index) {
                      return ListTile(
                          onTap: () {
                            setState(() {
                              searchController.text = '';
                              showUsers = false;
                            });
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ref
                                              .read(userProvider)!
                                              .id ==
                                          snapshot.data![index].id
                                      ? const MyProfileScreen()
                                      : ProfileScreen(
                                          userId: snapshot.data![index].id,
                                          username:
                                              snapshot.data![index].username,
                                        ),
                                ));
                          },
                          leading: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                'http://10.0.2.2:8080/img/users/${snapshot.data![index].photo}'),
                          ),
                          title: Text(
                            (snapshot.data![index].username),
                          ));
                    });
              }),
    );
  }
}
