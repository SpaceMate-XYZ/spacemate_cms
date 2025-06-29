// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Feature {
  int get id => throw _privateConstructorUsedError;
  FeatureAttributes get attributes => throw _privateConstructorUsedError;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureCopyWith<Feature> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureCopyWith<$Res> {
  factory $FeatureCopyWith(Feature value, $Res Function(Feature) then) =
      _$FeatureCopyWithImpl<$Res, Feature>;
  @useResult
  $Res call({int id, FeatureAttributes attributes});

  $FeatureAttributesCopyWith<$Res> get attributes;
}

/// @nodoc
class _$FeatureCopyWithImpl<$Res, $Val extends Feature>
    implements $FeatureCopyWith<$Res> {
  _$FeatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attributes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as FeatureAttributes,
    ) as $Val);
  }

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FeatureAttributesCopyWith<$Res> get attributes {
    return $FeatureAttributesCopyWith<$Res>(_value.attributes, (value) {
      return _then(_value.copyWith(attributes: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FeatureImplCopyWith<$Res> implements $FeatureCopyWith<$Res> {
  factory _$$FeatureImplCopyWith(
          _$FeatureImpl value, $Res Function(_$FeatureImpl) then) =
      __$$FeatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, FeatureAttributes attributes});

  @override
  $FeatureAttributesCopyWith<$Res> get attributes;
}

/// @nodoc
class __$$FeatureImplCopyWithImpl<$Res>
    extends _$FeatureCopyWithImpl<$Res, _$FeatureImpl>
    implements _$$FeatureImplCopyWith<$Res> {
  __$$FeatureImplCopyWithImpl(
      _$FeatureImpl _value, $Res Function(_$FeatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? attributes = null,
  }) {
    return _then(_$FeatureImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      attributes: null == attributes
          ? _value.attributes
          : attributes // ignore: cast_nullable_to_non_nullable
              as FeatureAttributes,
    ));
  }
}

/// @nodoc

class _$FeatureImpl with DiagnosticableTreeMixin implements _Feature {
  const _$FeatureImpl({required this.id, required this.attributes});

  @override
  final int id;
  @override
  final FeatureAttributes attributes;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Feature(id: $id, attributes: $attributes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Feature'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('attributes', attributes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.attributes, attributes) ||
                other.attributes == attributes));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, attributes);

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureImplCopyWith<_$FeatureImpl> get copyWith =>
      __$$FeatureImplCopyWithImpl<_$FeatureImpl>(this, _$identity);
}

abstract class _Feature implements Feature {
  const factory _Feature(
      {required final int id,
      required final FeatureAttributes attributes}) = _$FeatureImpl;

  @override
  int get id;
  @override
  FeatureAttributes get attributes;

  /// Create a copy of Feature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureImplCopyWith<_$FeatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$FeatureAttributes {
  @JsonKey(name: 'feature_name')
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'onboarding_carousel')
  List<OnboardingSlide>? get onboardingCarousel =>
      throw _privateConstructorUsedError;

  /// Create a copy of FeatureAttributes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FeatureAttributesCopyWith<FeatureAttributes> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureAttributesCopyWith<$Res> {
  factory $FeatureAttributesCopyWith(
          FeatureAttributes value, $Res Function(FeatureAttributes) then) =
      _$FeatureAttributesCopyWithImpl<$Res, FeatureAttributes>;
  @useResult
  $Res call(
      {@JsonKey(name: 'feature_name') String name,
      @JsonKey(name: 'onboarding_carousel')
      List<OnboardingSlide>? onboardingCarousel});
}

/// @nodoc
class _$FeatureAttributesCopyWithImpl<$Res, $Val extends FeatureAttributes>
    implements $FeatureAttributesCopyWith<$Res> {
  _$FeatureAttributesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureAttributes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? onboardingCarousel = freezed,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingCarousel: freezed == onboardingCarousel
          ? _value.onboardingCarousel
          : onboardingCarousel // ignore: cast_nullable_to_non_nullable
              as List<OnboardingSlide>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FeatureAttributesImplCopyWith<$Res>
    implements $FeatureAttributesCopyWith<$Res> {
  factory _$$FeatureAttributesImplCopyWith(_$FeatureAttributesImpl value,
          $Res Function(_$FeatureAttributesImpl) then) =
      __$$FeatureAttributesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'feature_name') String name,
      @JsonKey(name: 'onboarding_carousel')
      List<OnboardingSlide>? onboardingCarousel});
}

/// @nodoc
class __$$FeatureAttributesImplCopyWithImpl<$Res>
    extends _$FeatureAttributesCopyWithImpl<$Res, _$FeatureAttributesImpl>
    implements _$$FeatureAttributesImplCopyWith<$Res> {
  __$$FeatureAttributesImplCopyWithImpl(_$FeatureAttributesImpl _value,
      $Res Function(_$FeatureAttributesImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureAttributes
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? onboardingCarousel = freezed,
  }) {
    return _then(_$FeatureAttributesImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      onboardingCarousel: freezed == onboardingCarousel
          ? _value._onboardingCarousel
          : onboardingCarousel // ignore: cast_nullable_to_non_nullable
              as List<OnboardingSlide>?,
    ));
  }
}

/// @nodoc

class _$FeatureAttributesImpl
    with DiagnosticableTreeMixin
    implements _FeatureAttributes {
  const _$FeatureAttributesImpl(
      {@JsonKey(name: 'feature_name') required this.name,
      @JsonKey(name: 'onboarding_carousel')
      final List<OnboardingSlide>? onboardingCarousel})
      : _onboardingCarousel = onboardingCarousel;

  @override
  @JsonKey(name: 'feature_name')
  final String name;
  final List<OnboardingSlide>? _onboardingCarousel;
  @override
  @JsonKey(name: 'onboarding_carousel')
  List<OnboardingSlide>? get onboardingCarousel {
    final value = _onboardingCarousel;
    if (value == null) return null;
    if (_onboardingCarousel is EqualUnmodifiableListView)
      return _onboardingCarousel;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FeatureAttributes(name: $name, onboardingCarousel: $onboardingCarousel)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FeatureAttributes'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('onboardingCarousel', onboardingCarousel));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FeatureAttributesImpl &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality()
                .equals(other._onboardingCarousel, _onboardingCarousel));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name,
      const DeepCollectionEquality().hash(_onboardingCarousel));

  /// Create a copy of FeatureAttributes
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FeatureAttributesImplCopyWith<_$FeatureAttributesImpl> get copyWith =>
      __$$FeatureAttributesImplCopyWithImpl<_$FeatureAttributesImpl>(
          this, _$identity);
}

abstract class _FeatureAttributes implements FeatureAttributes {
  const factory _FeatureAttributes(
          {@JsonKey(name: 'feature_name') required final String name,
          @JsonKey(name: 'onboarding_carousel')
          final List<OnboardingSlide>? onboardingCarousel}) =
      _$FeatureAttributesImpl;

  @override
  @JsonKey(name: 'feature_name')
  String get name;
  @override
  @JsonKey(name: 'onboarding_carousel')
  List<OnboardingSlide>? get onboardingCarousel;

  /// Create a copy of FeatureAttributes
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FeatureAttributesImplCopyWith<_$FeatureAttributesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
