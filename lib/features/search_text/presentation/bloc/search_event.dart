part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchTextEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const SearchTextEvent({required this.params});
}

final class ReadAllEvent extends SearchEvent {}

final class SearchTextAndImageEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const SearchTextAndImageEvent({required this.params});
}

final class GenerateContentEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const GenerateContentEvent({required this.params});
}

final class AddMultipleImageEvent extends SearchEvent {
  final NoParams noParams;

  const AddMultipleImageEvent({required this.noParams});
}

final class ChatEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const ChatEvent({required this.params});
}

final class GenerateStreamEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const GenerateStreamEvent({required this.params});
}

final class GenerateStreamStopEvent extends SearchEvent {
  final Map<String, dynamic> params;

 const GenerateStreamStopEvent({required this.params});

}

final class ReadSQLDataEvent extends SearchEvent {}

final class ReadDataDetailsEvent extends SearchEvent {
  final Map<String, dynamic> params;
  const ReadDataDetailsEvent({required this.params});
}

final class IsSpeechTextEnabledEvent extends SearchEvent {}

final class ListenSpeechTextEvent extends SearchEvent {}

final class StopSpeechTextEvent extends SearchEvent {}

final class OnSpeechResultEvent extends SearchEvent {}

final class DeleteDataEvent extends SearchEvent {
  final List<TextEntity>? params;
  const DeleteDataEvent({required this.params});
}
