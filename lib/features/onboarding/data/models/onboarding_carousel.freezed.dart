// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_carousel.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OnboardingCarousel _$OnboardingCarouselFromJson(Map<String, dynamic> json) {
  return _OnboardingCarousel.fromJson(json);
}

/// @nodoc
mixin _$OnboardingCarousel {
  List<OnboardingSlide> get slides => throw _privateConstructorUsedError;

  /// Serializes this OnboardingCarousel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OnboardingCarousel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OnboardingCarouselCopyWith<OnboardingCarousel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OnboardingCarouselCopyWith<$Res> {
  factory $OnboardingCarouselCopyWith(
          OnboardingCarousel value, $Res Function(OnboardingCarousel) then) =
      _$OnboardingCarouselCopyWithImpl<$Res, OnboardingCarousel>;
  @useResult
  $Res call({List<OnboardingSlide> slides});
}

/// @nodoc
class _$OnboardingCarouselCopyWithImpl<$Res, $Val extends OnboardingCarousel>
    implements $OnboardingCarouselCopyWith<$Res> {
  _$OnboardingCarouselCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OnboardingCarousel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slides = null,
  }) {
    return _then(_value.copyWith(
      slides: null == slides
          ? _value.slides
          : slides // ignore: cast_nullable_to_non_nullable
              as List<OnboardingSlide>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OnboardingCarouselImplCopyWith<$Res>
    implements $OnboardingCarouselCopyWith<$Res> {
  factory _$$OnboardingCarouselImplCopyWith(_$OnboardingCarouselImpl value,
          $Res Function(_$OnboardingCarouselImpl) then) =
      __$$OnboardingCarouselImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<OnboardingSlide> slides});
}

/// @nodoc
class __$$OnboardingCarouselImplCopyWithImpl<$Res>
    extends _$OnboardingCarouselCopyWithImpl<$Res, _$OnboardingCarouselImpl>
    implements _$$OnboardingCarouselImplCopyWith<$Res> {
  __$$OnboardingCarouselImplCopyWithImpl(_$OnboardingCarouselImpl _value,
      $Res Function(_$OnboardingCarouselImpl) _then)
      : super(_value, _then);

  /// Create a copy of OnboardingCarousel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slides = null,
  }) {
    return _then(_$OnboardingCarouselImpl(
      slides: null == slides
          ? _value._slides
          : slides // ignore: cast_nullable_to_non_nullable
              as List<OnboardingSlide>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OnboardingCarouselImpl
    with DiagnosticableTreeMixin
    implements _OnboardingCarousel {
  const _$OnboardingCarouselImpl({required final List<OnboardingSlide> slides})
      : _slides = slides;

  factory _$OnboardingCarouselImpl.fromJson(Map<String, dynamic> json) =>
      _$$OnboardingCarouselImplFromJson(json);

  final List<OnboardingSlide> _slides;
  @override
  List<OnboardingSlide> get slides {
    if (_slides is EqualUnmodifiableListView) return _slides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slides);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OnboardingCarousel(slides: $slides)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OnboardingCarousel'))
      ..add(DiagnosticsProperty('slides', slides));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingCarouselImpl &&
            const DeepCollectionEquality().equals(other._slides, _slides));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_slides));

  /// Create a copy of OnboardingCarousel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingCarouselImplCopyWith<_$OnboardingCarouselImpl> get copyWith =>
      __$$OnboardingCarouselImplCopyWithImpl<_$OnboardingCarouselImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OnboardingCarouselImplToJson(
      this,
    );
  }
}

abstract class _OnboardingCarousel implements OnboardingCarousel {
  const factory _OnboardingCarousel(
      {required final List<OnboardingSlide> slides}) = _$OnboardingCarouselImpl;

  factory _OnboardingCarousel.fromJson(Map<String, dynamic> json) =
      _$OnboardingCarouselImpl.fromJson;

  @override
  List<OnboardingSlide> get slides;

  /// Create a copy of OnboardingCarousel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingCarouselImplCopyWith<_$OnboardingCarouselImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
