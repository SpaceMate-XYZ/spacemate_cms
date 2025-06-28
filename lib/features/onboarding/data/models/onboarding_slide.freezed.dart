// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_slide.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingSlide _$OnboardingSlideFromJson(Map<String, dynamic> json) {
  return _OnboardingSlide.fromJson(json);
}

/// @nodoc
mixin _$OnboardingSlide {
  int get id => throw _privateConstructorUsedError;
  String get feature => throw _privateConstructorUsedError;
  int get screen => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'imageURL')
  String get imageUrl => throw _privateConstructorUsedError;
  String get header => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  @JsonKey(name: 'button_label')
  String? get buttonLabel => throw _privateConstructorUsedError;

  /// Serializes this OnboardingSlide to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingSlide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingSlideCopyWith<OnboardingSlide> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingSlideCopyWith<$Res> {
  factory $OnboardingSlideCopyWith(
          OnboardingSlide value, $Res Function(OnboardingSlide) then) =
      _$OnboardingSlideCopyWithImpl<$Res, OnboardingSlide>;
  @useResult
  $Res call(
      {int id,
      String feature,
      int screen,
      String title,
      @JsonKey(name: 'imageURL') String imageUrl,
      String header,
      String body,
      @JsonKey(name: 'button_label') String? buttonLabel});
}

/// @nodoc
class _$OnboardingSlideCopyWithImpl<$Res, $Val extends OnboardingSlide>
    implements $OnboardingSlideCopyWith<$Res> {
  _$OnboardingSlideCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingSlide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? feature = null,
    Object? screen = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? header = null,
    Object? body = null,
    Object? buttonLabel = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
      screen: null == screen
          ? _value.screen
          : screen // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      buttonLabel: freezed == buttonLabel
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingSlideImplCopyWith<$Res>
    implements $OnboardingSlideCopyWith<$Res> {
  factory _$$OnboardingSlideImplCopyWith(_$OnboardingSlideImpl value,
          $Res Function(_$OnboardingSlideImpl) then) =
      __$$OnboardingSlideImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String feature,
      int screen,
      String title,
      @JsonKey(name: 'imageURL') String imageUrl,
      String header,
      String body,
      @JsonKey(name: 'button_label') String? buttonLabel});
}

/// @nodoc
class __$$OnboardingSlideImplCopyWithImpl<$Res>
    extends _$OnboardingSlideCopyWithImpl<$Res, _$OnboardingSlideImpl>
    implements _$$OnboardingSlideImplCopyWith<$Res> {
  __$$OnboardingSlideImplCopyWithImpl(
      _$OnboardingSlideImpl _value, $Res Function(_$OnboardingSlideImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingSlide
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? feature = null,
    Object? screen = null,
    Object? title = null,
    Object? imageUrl = null,
    Object? header = null,
    Object? body = null,
    Object? buttonLabel = freezed,
  }) {
    return _then(_$OnboardingSlideImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      feature: null == feature
          ? _value.feature
          : feature // ignore: cast_nullable_to_non_nullable
              as String,
      screen: null == screen
          ? _value.screen
          : screen // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      header: null == header
          ? _value.header
          : header // ignore: cast_nullable_to_non_nullable
              as String,
      body: null == body
          ? _value.body
          : body // ignore: cast_nullable_to_non_nullable
              as String,
      buttonLabel: freezed == buttonLabel
          ? _value.buttonLabel
          : buttonLabel // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingSlideImpl
    with DiagnosticableTreeMixin
    implements _OnboardingSlide {
  const _$OnboardingSlideImpl(
      {required this.id,
      required this.feature,
      required this.screen,
      required this.title,
      @JsonKey(name: 'imageURL') required this.imageUrl,
      required this.header,
      required this.body,
      @JsonKey(name: 'button_label') this.buttonLabel});

  factory _$OnboardingSlideImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingSlideImplFromJson(json);

  @override
  final int id;
  @override
  final String feature;
  @override
  final int screen;
  @override
  final String title;
  @override
  @JsonKey(name: 'imageURL')
  final String imageUrl;
  @override
  final String header;
  @override
  final String body;
  @override
  @JsonKey(name: 'button_label')
  final String? buttonLabel;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OnboardingSlide(id: $id, feature: $feature, screen: $screen, title: $title, imageUrl: $imageUrl, header: $header, body: $body, buttonLabel: $buttonLabel)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OnboardingSlide'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('feature', feature))
      ..add(DiagnosticsProperty('screen', screen))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('imageUrl', imageUrl))
      ..add(DiagnosticsProperty('header', header))
      ..add(DiagnosticsProperty('body', body))
      ..add(DiagnosticsProperty('buttonLabel', buttonLabel));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingSlideImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.feature, feature) || other.feature == feature) &&
            (identical(other.screen, screen) || other.screen == screen) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.header, header) || other.header == header) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.buttonLabel, buttonLabel) ||
                other.buttonLabel == buttonLabel));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, feature, screen, title,
      imageUrl, header, body, buttonLabel);

  /// Create a copy of OnboardingSlide
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingSlideImplCopyWith<_$OnboardingSlideImpl> get copyWith =>
      __$$OnboardingSlideImplCopyWithImpl<_$OnboardingSlideImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingSlideImplToJson(
      this,
    );
  }
}

abstract class _OnboardingSlide implements OnboardingSlide {
  const factory _OnboardingSlide(
          {required final int id,
          required final String feature,
          required final int screen,
          required final String title,
          @JsonKey(name: 'imageURL') required final String imageUrl,
          required final String header,
          required final String body,
          @JsonKey(name: 'button_label') final String? buttonLabel}) =
      _$OnboardingSlideImpl;

  factory _OnboardingSlide.fromJson(Map<String, dynamic> json) =
      _$OnboardingSlideImpl.fromJson;

  @override
  int get id;
  @override
  String get feature;
  @override
  int get screen;
  @override
  String get title;
  @override
  @JsonKey(name: 'imageURL')
  String get imageUrl;
  @override
  String get header;
  @override
  String get body;
  @override
  @JsonKey(name: 'button_label')
  String? get buttonLabel;

  /// Create a copy of OnboardingSlide
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingSlideImplCopyWith<_$OnboardingSlideImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
