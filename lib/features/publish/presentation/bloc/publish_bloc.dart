import 'package:flutter_bloc/flutter_bloc.dart';
import 'publish_event.dart';
import 'publish_state.dart';

class PublishBloc extends Bloc<PublishEvent, PublishState> {
  PublishBloc() : super(const PublishState()) {
    on<UpdateTitle>(_onUpdateTitle);
    on<UpdateContent>(_onUpdateContent);
    on<UpdateCategory>(_onUpdateCategory);
    on<UpdateEvModel>(_onUpdateEvModel);
    on<AttachImage>(_onAttachImage);
    on<AttachVideo>(_onAttachVideo);
    on<RemoveMedia>(_onRemoveMedia);
    on<SubmitPost>(_onSubmitPost);
  }

  void _onUpdateTitle(UpdateTitle event, Emitter<PublishState> emit) {
    emit(state.copyWith(title: event.title));
  }

  void _onUpdateContent(UpdateContent event, Emitter<PublishState> emit) {
    emit(state.copyWith(content: event.content));
  }

  void _onUpdateCategory(UpdateCategory event, Emitter<PublishState> emit) {
    emit(state.copyWith(category: event.category));
  }

  void _onUpdateEvModel(UpdateEvModel event, Emitter<PublishState> emit) {
    emit(state.copyWith(evModel: event.evModel, clearEvModel: event.evModel == null));
  }

  void _onAttachImage(AttachImage event, Emitter<PublishState> emit) {
    emit(state.copyWith(imagePath: event.path, clearVideo: true));
  }

  void _onAttachVideo(AttachVideo event, Emitter<PublishState> emit) {
    emit(state.copyWith(videoPath: event.path, clearImage: true));
  }

  void _onRemoveMedia(RemoveMedia event, Emitter<PublishState> emit) {
    if (event.isImage) {
      emit(state.copyWith(clearImage: true));
    } else {
      emit(state.copyWith(clearVideo: true));
    }
  }

  Future<void> _onSubmitPost(SubmitPost event, Emitter<PublishState> emit) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: PublishStatus.submitting));

    try {
      // 模拟网络延迟（实际接Firebase时替换这里）
      await Future.delayed(const Duration(seconds: 2));

      // TODO: 上传到 Firebase Firestore + Storage
      // final post = PublishPost(
      //   title: state.title,
      //   content: state.content,
      //   category: state.category,
      //   evModel: state.evModel,
      //   imagePath: state.imagePath,
      //   videoPath: state.videoPath,
      // );
      // await repository.createPost(post);

      emit(state.copyWith(status: PublishStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: PublishStatus.error,
        errorMessage: '发布失败，请重试',
      ));
    }
  }
}