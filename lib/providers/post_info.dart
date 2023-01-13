import 'package:flutter/widgets.dart';
import 'package:saf_user/models/post.dart';

class PostInfo with  ChangeNotifier {

   List<Post> _entries = [];

  List<Post> get entries {
    return _entries;
  }

}