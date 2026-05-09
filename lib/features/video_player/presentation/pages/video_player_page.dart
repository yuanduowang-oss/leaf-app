import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';

class VideoPlayerPage extends StatefulWidget {
  final String videoUrl;
  final String? title;
  final String? authorName;

  const VideoPlayerPage({
    super.key,
    required this.videoUrl,
    this.title,
    this.authorName,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isPlaying = false;
  bool _showControls = true;
  bool _isFullScreen = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() {
    // video_player on web only supports HTTPS or localhost
    if (!widget.videoUrl.startsWith('https://') &&
        !widget.videoUrl.startsWith('http://localhost')) {
      setState(() {
        _errorMessage = '视频链接必须是 HTTPS 协议';
      });
      return;
    }

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _initializeVideoPlayerFuture = _controller.initialize().then((_) {
      setState(() {});
      _controller.addListener(_videoListener);
    }).catchError((error) {
      setState(() {
        _errorMessage = '视频加载失败: $error';
      });
    });
  }

  void _videoListener() {
    if (!mounted) return;
    final isPlaying = _controller.value.isPlaying;
    if (isPlaying != _isPlaying) {
      setState(() {
        _isPlaying = isPlaying;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: _errorMessage != null
            ? _buildErrorView()
            : _isFullScreen
                ? _buildFullScreenVideo()
                : _buildNormalVideo(),
      ),
    );
  }

  Widget _buildNormalVideo() {
    return Column(
      children: [
        _buildAppBar(),
        Expanded(child: _buildVideoArea()),
        _buildBottomInfo(),
      ],
    );
  }

  Widget _buildFullScreenVideo() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildVideoArea(),
          if (_showControls) ...[
            _buildPlayPauseOverlay(),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildProgressBar(),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: _buildFullScreenButton(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      color: AppTheme.backgroundDark,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              widget.title ?? '视频播放',
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white),
            onPressed: _toggleFullScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildVideoArea() {
    return GestureDetector(
      onTap: _toggleControls,
      child: Container(
        color: Colors.black,
        child: Center(
          child: FutureBuilder<void>(
            future: _initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(color: AppTheme.primaryGreen);
              }
              if (snapshot.hasError || _errorMessage != null) {
                return _buildErrorView();
              }
              if (!_controller.value.isInitialized) {
                return const CircularProgressIndicator(color: AppTheme.primaryGreen);
              }
              return Stack(
                alignment: Alignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                  if (_showControls && !_isPlaying) _buildPlayPauseOverlay(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayPauseOverlay() {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: Colors.black.withOpacity(0.6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: _togglePlayPause,
            child: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: AppTheme.primaryGreen,
                bufferedColor: Colors.white30,
                backgroundColor: Colors.white10,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _controller.value.isInitialized
                ? '${_formatDuration(_controller.value.position)} / ${_formatDuration(_controller.value.duration)}'
                : '--:--',
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.fullscreen, color: Colors.white, size: 24),
            onPressed: _toggleFullScreen,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFullScreenButton() {
    return GestureDetector(
      onTap: _toggleFullScreen,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.fullscreen_exit, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 64),
          const SizedBox(height: 16),
          Text(
            _errorMessage ?? '视频加载失败',
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            '提示：Web 端仅支持 HTTPS 视频链接',
            style: TextStyle(color: Colors.white54, fontSize: 12),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
            ),
            child: const Text('返回'),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.backgroundDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null) ...[
            Text(
              widget.title!,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
          ],
          if (widget.authorName != null)
            Text(
              '作者: ${widget.authorName}',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          const SizedBox(height: 16),
          _buildProgressBar(),
        ],
      ),
    );
  }
}
