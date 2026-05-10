import '../models/post.dart';

class MockPosts {
  static final List<Post> _posts = [
    Post(
      id: '1',
      authorId: 'user_1',
      authorName: '电车老王',
      authorAvatar: null,
      content: '电动车充电技巧：这样充增加电池寿命🔋 1. 不要等电量耗尽再充；2. 慢充比快充更保护电池；3. 充到80%最好；4. 高温天气避免充电',
      imageUrl: 'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      category: PostCategory.tips,
      evModel: '特斯拉 Model 3',
      location: '北京',
      likesCount: 2847,
      commentsCount: 326,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Post(
      id: '2',
      authorId: 'user_2',
      authorName: '新能源车主小李',
      authorAvatar: null,
      content: '特斯拉AP使用教程，新手必看👀 终于整理好了AP的正确打开方式',
      imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=800',
      videoUrl: null,
      category: PostCategory.experience,
      evModel: '特斯拉 Model Y',
      location: '上海',
      likesCount: 5621,
      commentsCount: 892,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    Post(
      id: '3',
      authorId: 'user_3',
      authorName: '蔚来车主阿涛',
      authorAvatar: null,
      content: '比亚迪汉EV vs 蔚来ET7怎么选？全面对比来了🔥',
      imageUrl: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?w=800',  // 蔚来ET7风格轿车
      videoUrl: null,
      category: PostCategory.problemSolving,
      evModel: '蔚来 ET7',
      location: '深圳',
      likesCount: 8932,
      commentsCount: 1247,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    Post(
      id: '4',
      authorId: 'user_4',
      authorName: '修车师傅老张',
      authorAvatar: null,
      content: '电动车突然抛锚怎么办？记住这三步🚗 1. 打开双闪；2. 靠边停车；3. 联系救援',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
      videoUrl: null,
      category: PostCategory.problemSolving,
      evModel: null,
      location: '广州',
      likesCount: 3421,
      commentsCount: 445,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Post(
      id: '5',
      authorId: 'user_5',
      authorName: '充电桩安装小王',
      authorAvatar: null,
      content: '家用充电桩安装全攻略🏠 从申请到安装，一文说清楚',
      imageUrl: 'https://images.unsplash.com/photo-1621954915653-cd9f4f2f7a03?w=800',
      videoUrl: null,
      category: PostCategory.experience,
      evModel: null,
      location: '成都',
      likesCount: 7823,
      commentsCount: 678,
      createdAt: DateTime.now().subtract(const Duration(hours: 18)),
    ),
    Post(
      id: '6',
      authorId: 'user_6',
      authorName: '电池专家老陈',
      authorAvatar: null,
      content: '冬季电池保养的3个误区❄️ 1. 误区一：一直充着电；2. 误区二：不开暖风；3. 误区三：长期不开',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',  // 比亚迪汉EV风格
      videoUrl: null,
      category: PostCategory.maintenance,
      evModel: '比亚迪 汉EV',
      location: '杭州',
      likesCount: 4521,
      commentsCount: 521,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Post(
      id: '7',
      authorId: 'user_7',
      authorName: '理想ONE车主',
      authorAvatar: null,
      content: '理想ONE续航实测：市区能跑多少公里？📊',
      imageUrl: 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=800',  // 理想ONE风格SUV
      videoUrl: null,
      category: PostCategory.experience,
      evModel: '理想 ONE',
      location: '武汉',
      likesCount: 2341,
      commentsCount: 298,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
    ),
    Post(
      id: '8',
      authorId: 'user_8',
      authorName: '小鹏P7车主',
      authorAvatar: null,
      content: '小鹏NGP自动辅助驾驶体验报告🛣️ 高速实测200公里',
      imageUrl: 'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800',  // 小鹏P7风格轿车
      videoUrl: null,
      category: PostCategory.tips,
      evModel: '小鹏 P7',
      location: '南京',
      likesCount: 6234,
      commentsCount: 734,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 6)),
    ),
  ];

  static List<Post> getPosts({PostCategory? category, String? searchQuery}) {
    var result = List<Post>.from(_posts);
    
    if (category != null) {
      result = result.where((p) => p.category == category).toList();
    }
    
    if (searchQuery != null && searchQuery.isNotEmpty) {
      result = result.where((p) =>
        p.content.toLowerCase().contains(searchQuery.toLowerCase()) ||
        (p.evModel?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false)
      ).toList();
    }
    
    return result;
  }

  static Post? getPostById(String id) {
    try {
      return _posts.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}
