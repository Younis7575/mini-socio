
import 'package:get/get.dart';
import 'package:mini_social/presentation/pages/auth/login_page.dart';
import 'package:mini_social/presentation/pages/feed/feed_page.dart';
import 'package:mini_social/presentation/pages/post/create_post_page.dart';

abstract class AppPages {
  static const initial = '/login';
  
  static final routes = [
    GetPage(
      name: '/login',
      page: () => LoginPage(),
    ),
    GetPage(
      name: '/feed',
      page: () => FeedPage(),
    ),
    GetPage(
      name: '/create-post',
      page: () => CreatePostPage(),
    ),
  ];
}