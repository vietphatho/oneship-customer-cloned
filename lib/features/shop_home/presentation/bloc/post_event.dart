import 'package:oneship_customer/features/shop_home/data/enum.dart';

abstract class PostEvent {
  const PostEvent();
}

class PostFetchHomePreviewEvent extends PostEvent {
  const PostFetchHomePreviewEvent();
}

class PostFetchEvent extends PostEvent {
  const PostFetchEvent(this.category);

  final MobilePostCategory category;
}

class PostLoadMoreEvent extends PostEvent {
  const PostLoadMoreEvent(this.category);

  final MobilePostCategory category;
}
