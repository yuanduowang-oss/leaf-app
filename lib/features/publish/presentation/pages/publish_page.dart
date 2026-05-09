import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/publish_post.dart';
import '../bloc/publish_bloc.dart';
import '../bloc/publish_event.dart';
import '../bloc/publish_state.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends State<PublishPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<PublishBloc>().add(AttachImage(image.path));
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null && mounted) {
      context.read<PublishBloc>().add(AttachVideo(video.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PublishBloc(),
      child: BlocConsumer<PublishBloc, PublishState>(
        listener: (context, state) {
          if (state.status == PublishStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('发布成功！'),
                backgroundColor: AppTheme.primaryGreen,
              ),
            );
            Navigator.pop(context);
          } else if (state.status == PublishStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? '发布失败'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppTheme.backgroundDark,
            appBar: AppBar(
              backgroundColor: AppTheme.surfaceDark,
              title: const Text('发布内容', style: TextStyle(color: AppTheme.textPrimary)),
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppTheme.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
              actions: [
                TextButton(
                  onPressed: state.canSubmit && state.status != PublishStatus.submitting
                      ? () => context.read<PublishBloc>().add(const SubmitPost())
                      : null,
                  child: state.status == PublishStatus.submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.primaryGreen),
                        )
                      : Text(
                          '发布',
                          style: TextStyle(
                            color: state.canSubmit ? AppTheme.primaryGreen : AppTheme.textHint,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Input
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '标题（必填）',
                      hintStyle: TextStyle(color: AppTheme.textHint, fontSize: 18, fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                    onChanged: (v) => context.read<PublishBloc>().add(UpdateTitle(v)),
                  ),

                  const Divider(color: AppTheme.surfaceDark, height: 24),

                  // Content Input
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(color: AppTheme.textPrimary, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: '分享你的用车经验...',
                      hintStyle: TextStyle(color: AppTheme.textHint),
                      border: InputBorder.none,
                    ),
                    maxLines: 8,
                    onChanged: (v) => context.read<PublishBloc>().add(UpdateContent(v)),
                  ),

                  const SizedBox(height: 16),

                  // Media Preview
                  if (state.imagePath != null || state.videoPath != null) ...[
                    _buildMediaPreview(state),
                    const SizedBox(height: 16),
                  ],

                  // Category Selection
                  const Text('分类', style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: PublishCategory.values.map((cat) {
                      final isSelected = state.category == cat;
                      return GestureDetector(
                        onTap: () => context.read<PublishBloc>().add(UpdateCategory(cat)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.primaryGreen : AppTheme.surfaceDark,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat.label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 16),

                  // EV Model Input
                  TextField(
                    controller: _modelController,
                    style: const TextStyle(color: AppTheme.textPrimary),
                    decoration: InputDecoration(
                      hintText: '车型（选填，如：比亚迪汉EV）',
                      hintStyle: const TextStyle(color: AppTheme.textHint),
                      prefixIcon: const Icon(Icons.directions_car, color: AppTheme.textHint),
                      filled: true,
                      fillColor: AppTheme.surfaceDark,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onChanged: (v) => context.read<PublishBloc>().add(UpdateEvModel(v.isEmpty ? null : v)),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surfaceDark,
                border: Border(top: BorderSide(color: AppTheme.cardDark)),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    _buildMediaButton(Icons.image_outlined, '图片', _pickImage),
                    const SizedBox(width: 24),
                    _buildMediaButton(Icons.videocam_outlined, '视频', _pickVideo),
                    const Spacer(),
                    if (state.imagePath != null || state.videoPath != null)
                      Text(
                        state.imagePath != null ? '1张图片' : '1个视频',
                        style: const TextStyle(color: AppTheme.textHint, fontSize: 13),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMediaPreview(PublishState state) {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  state.imagePath != null ? Icons.image : Icons.videocam,
                  color: AppTheme.primaryGreen,
                  size: 48,
                ),
                const SizedBox(height: 8),
                Text(
                  state.imagePath != null ? '图片已选择' : '视频已选择',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () {
                if (state.imagePath != null) {
                  context.read<PublishBloc>().add(const RemoveMedia(true));
                } else {
                  context.read<PublishBloc>().add(const RemoveMedia(false));
                }
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryGreen, size: 28),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }
}