import 'package:equatable/equatable.dart';
import 'package:spacemate/features/menu/data/models/screen_model.dart';

class ScreenApiResponse extends Equatable {
  final List<ScreenModel> data;

  const ScreenApiResponse({required this.data});

  factory ScreenApiResponse.fromJson(Map<String, dynamic> json) {
    return ScreenApiResponse(
      data: (json['data'] as List)
          .map((item) => ScreenModel.fromJson(item))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [data];
}
