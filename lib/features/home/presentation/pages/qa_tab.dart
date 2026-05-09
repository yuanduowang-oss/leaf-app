import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class QATab extends StatelessWidget {
  const QATab({super.key});

  void _showAskDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('发布问题', style: TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              style: const TextStyle(color: AppTheme.textPrimary),
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '描述你的问题...',
                hintStyle: const TextStyle(color: AppTheme.textHint),
                filled: true,
                fillColor: AppTheme.cardDark,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.video_call_outlined, color: AppTheme.textHint, size: 20),
                const SizedBox(width: 4),
                const Text('添加视频', style: TextStyle(color: AppTheme.textHint, fontSize: 13)),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('取消'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('问题已发布'), backgroundColor: AppTheme.primaryGreen),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGreen),
                  child: const Text('发布'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('问答', style: TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen),
                    onPressed: () => _showAskDialog(context),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: InputDecoration(
                  hintText: '搜索问题...',
                  hintStyle: const TextStyle(color: AppTheme.textHint),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                  filled: true,
                  fillColor: AppTheme.surfaceDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Q&A List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _qaList.length,
                itemBuilder: (context, index) => _buildQACard(_qaList[index]),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAskDialog(context),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildQACard(Map<String, String> qa) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppTheme.cardDark, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Center(child: Text('问', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(qa['question'] ?? '', style: const TextStyle(color: AppTheme.textPrimary, fontSize: 15, fontWeight: FontWeight.w500))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24, height: 24,
                decoration: BoxDecoration(color: AppTheme.categoryTips.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                child: const Center(child: Text('答', style: TextStyle(color: AppTheme.categoryTips, fontSize: 12, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(qa['answer'] ?? '', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.thumb_up_outlined, size: 14, color: AppTheme.textHint),
              const SizedBox(width: 4),
              Text(qa['likes'] ?? '0', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.chat_bubble_outline, size: 14, color: AppTheme.textHint),
              const SizedBox(width: 4),
              Text(qa['comments'] ?? '0', style: TextStyle(color: AppTheme.textHint, fontSize: 12)),
              const Spacer(),
              if (qa['hasVideo'] == 'true')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.primaryGreen.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_circle_outline, size: 12, color: AppTheme.primaryGreen),
                      const SizedBox(width: 2),
                      Text('视频回答', style: TextStyle(color: AppTheme.primaryGreen, fontSize: 10)),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

final List<Map<String, String>> _qaList = [
  {'question': '电动车冬季续航严重缩水，有什么办法可以提升续航？', 'answer': '亲测有效！充电前开启电池预热，空调使用内循环+2档，胎压定期检查', 'likes': '847', 'comments': '156', 'hasVideo': 'true'},
  {'question': '特斯拉AP经常退出，是怎么回事？', 'answer': '可能是摄像头脏了，或者阳光太强导致视觉系统受影响，建议清洁摄像头', 'likes': '423', 'comments': '89', 'hasVideo': 'false'},
  {'question': '家用充电桩申请需要什么流程？', 'answer': '先联系物业开证明，然后国家电网申请，最后找安装师傅安装，大概需要2-3周', 'likes': '1205', 'comments': '234', 'hasVideo': 'true'},
  {'question': '快充对电池寿命影响大吗？', 'answer': '偶尔快充问题不大，但经常快充会导致电池衰减加速，建议日常用慢充', 'likes': '678', 'comments': '145', 'hasVideo': 'false'},
  {'question': '比亚迪汉EV怎么设置最省电？', 'answer': '动能回收调至高档，空调23度自动模式，座椅加热比空调省电', 'likes': '534', 'comments': '98', 'hasVideo': 'true'},
  {'question': '电动车保险怎么买最划算？', 'answer': '建议三者险买200万，车损险一定要买，自燃险看情况，划痕险看停车环境', 'likes': '892', 'comments': '167', 'hasVideo': 'false'},
];
