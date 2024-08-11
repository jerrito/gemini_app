part of 'search_bloc.dart';

sealed class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

final class SearchInitState extends SearchState {}

final class SearchTextLoading extends SearchState {}

final class SearchTextLoaded extends SearchState {
  final String data;
  const SearchTextLoaded({required this.data});
}

final class SearchTextError extends SearchState {
  final String errorMessage;
  const SearchTextError({required this.errorMessage});
}

final class ChatLoading extends SearchState {}

final class ChatLoaded extends SearchState {
  final String data;
  const ChatLoaded({required this.data});
}

final class ChatError extends SearchState {
  final String errorMessage;
  const ChatError({required this.errorMessage});
}

final class ReadAll extends SearchState {
  const ReadAll();
}

final class SearchTextAndImageLoading extends SearchState {}

final class SearchTextAndImageLoaded extends SearchState {
  final String data;
  const SearchTextAndImageLoaded({required this.data});
}

final class SearchTextAndImageError extends SearchState {
  final String errorMessage;
  const SearchTextAndImageError({required this.errorMessage});
}

final class GenerateContentLoading extends SearchState {}

final class GenerateContentLoaded extends SearchState {
  final String data;
  const GenerateContentLoaded({required this.data});
}

final class GenerateContentAllDone extends SearchState {
  const GenerateContentAllDone();
}

final class GenerateContentError extends SearchState {
  final String errorMessage;
  const GenerateContentError({required this.errorMessage});
}

final class AddMultipleImageLoading extends SearchState {}

final class AddMultipleImageLoaded extends SearchState {
  final Map<List<Uint8List>, List<String>> data;

  const AddMultipleImageLoaded({required this.data});
}

final class AddMultipleImageError extends SearchState {
  final String errorMessage;
  const AddMultipleImageError({required this.errorMessage});
}

final class GenerateStream extends SearchState {}

final class GenerateStreamLoading extends SearchState {}

final class GenerateStreamError extends SearchState {
  final String errorMessage;
  const GenerateStreamError({required this.errorMessage});
}

final class GenerateStreamStop extends SearchState {}

final class ReadDataLoaded extends SearchState {
  final List<TextEntity>? data;

  const ReadDataLoaded({required this.data});
}

final class ReadDataLoading extends SearchState {}

final class ReadDataError extends SearchState {
  final String errorMessage;
  const ReadDataError({required this.errorMessage});
}

final class ReadDataDetailsLoaded extends SearchState {
  final Data? textEntity;

  const ReadDataDetailsLoaded(this.textEntity);
}

final class ReadDataDetailsLoading extends SearchState {}

final class IsSpeechTextEnabledError extends SearchState {
  final String errorMessage;
  const IsSpeechTextEnabledError({required this.errorMessage});
}

final class IsSpeechTextEnabledLoaded extends SearchState {}

final class StopSpeechTextError extends SearchState {
  final String errorMessage;
  const StopSpeechTextError({required this.errorMessage});
}

final class StopSpeechTextLoaded extends SearchState {
  const StopSpeechTextLoaded();
}

final class ListenSpeechTextError extends SearchState {
  final String errorMessage;
  const ListenSpeechTextError({required this.errorMessage});
}

final class OnSpeechResultError extends SearchState {
  final String errorMessage;
  const OnSpeechResultError({required this.errorMessage});
}

final class ListenSpeechTextLoaded extends SearchState {
  const ListenSpeechTextLoaded();
}

final class OnSpeechResultLoaded extends SearchState {
  final String result;
  const OnSpeechResultLoaded({required this.result});
}

final class OnSpeechResultLoading extends SearchState {}

final class DeleteDataLoaded extends SearchState {
  const DeleteDataLoaded();
}

final class DeleteDataLoading extends SearchState {}

final class DeleteDataError extends SearchState {
  final String errorMessage;

  const DeleteDataError({required this.errorMessage});
}
