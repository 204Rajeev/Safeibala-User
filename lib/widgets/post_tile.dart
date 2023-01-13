import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:saf_user/resources/firestore_methods.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class PostTile extends StatefulWidget {
  final snap;

  const PostTile({
    super.key,
    required this.snap,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addressSeperate();
  }

  int idx = 0;

  String address1 = 'ghf';
  String address2 = '';

  void addressSeperate() {
    int cnt = 0;
    for (int i = 0; i < widget.snap['address'].length; i++) {
      if (widget.snap['address'][i] == ',') cnt++;

      if (cnt == 2) {
        address1 = widget.snap['address'].substring(0, i);
        address2 = widget.snap['address']
            .substring(i + 1, widget.snap['address'].length);
        break;
      }
    }
  }

  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.snap['username'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address1,
                      style: TextStyle(fontSize: 12),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      address2,
                      style: TextStyle(fontSize: 12),
                      softWrap: false,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
            const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.redAccent,
            )
          ]),
        ),
        GestureDetector(
          onDoubleTap: () async {
            await FirestoreMethods().likePost(
                widget.snap['postId'], user.uid, widget.snap['likes']);
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: widget.snap['postUrl'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await FirestoreMethods().likePost(
                              widget.snap['postId'],
                              user.uid,
                              widget.snap['likes']);
                        },
                        child: widget.snap['likes'].contains(user.uid)
                            ? Container(
                                height: 30 * 0.75,
                                width: 20 * 0.75,
                                child: Image.asset(
                                  'assets/images/Upvote_user.png',
                                  fit: BoxFit.cover,
                                ))
                            : Container(
                                height: 30 * 0.75,
                                width: 20 * 0.75,
                                child: Image.asset(
                                  'assets/images/Upvote.png',
                                  fit: BoxFit.cover,
                                )),
                      ),
                      const SizedBox(width: 10),
                      Text(widget.snap['likes'].length.toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.snap['description'],
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.snap['datePublished'].substring(0, 10),
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: Colors.grey,
        )
      ],
    );
  }
}
