// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spacemate_placeid_features_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpacematePlaceidFeaturesResponse {
  List<Feature> get data => throw _privateConstructorUsedError;

  /// Create a copy of SpacematePlaceidFeaturesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpacematePlaceidFeaturesResponseCopyWith<SpacematePlaceidFeaturesResponse>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpacematePlaceidFeaturesResponseCopyWith<$Res> {
  factory $SpacematePlaceidFeaturesResponseCopyWith(
          SpacematePlaceidFeaturesResponse value,
          $Res Function(SpacematePlaceidFeaturesResponse) then) =
      _$SpacematePlaceidFeaturesResponseCopyWithImpl<$Res,
          SpacematePlaceidFeaturesResponse>;
  @useResult
  $Res call({List<Feature> data});
}

/// @nodoc
class _$SpacematePlaceidFeaturesResponseCopyWithImpl<$Res,
        $Val extends SpacematePlaceidFeaturesResponse>
    implements $SpacematePlaceidFeaturesResponseCopyWith<$Res> {
  _$SpacematePlaceidFeaturesResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpacematePlaceidFeaturesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Feature>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpacematePlaceidFeaturesResponseImplCopyWith<$Res>
    implements $SpacematePlaceidFeaturesResponseCopyWith<$Res> {
  factory _$$SpacematePlaceidFeaturesResponseImplCopyWith(
          _$SpacematePlaceidFeaturesResponseImpl value,
          $Res Function(_$SpacematePlaceidFeaturesResponseImpl) then) =
      __$$SpacematePlaceidFeaturesResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Feature> data});
}

/// @nodoc
class __$$SpacematePlaceidFeaturesResponseImplCopyWithImpl<$Res>
    extends _$SpacematePlaceidFeaturesResponseCopyWithImpl<$Res,
        _$SpacematePlaceidFeaturesResponseImpl>
    implements _$$SpacematePlaceidFeaturesResponseImplCopyWith<$Res> {
  __$$SpacematePlaceidFeaturesResponseImplCopyWithImpl(
      _$SpacematePlaceidFeaturesResponseImpl _value,
      $Res Function(_$SpacematePlaceidFeaturesResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpacematePlaceidFeaturesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
  }) {
    return _then(_$SpacematePlaceidFeaturesResponseImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<Feature>,
    ));
  }
}

/// @nodoc

class _$SpacematePlaceidFeaturesResponseImpl
    with DiagnosticableTreeMixin
    implements _SpacematePlaceidFeaturesResponse {
  const _$SpacematePlaceidFeaturesResponseImpl(
      {required final List<Feature> data})
      : _data = data;

  final List<Feature> _data;
  @override
  List<Feature> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SpacematePlaceidFeaturesResponse(data: $data)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SpacematePlaceidFeaturesResponse'))
      ..add(DiagnosticsProperty('data', data));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpacematePlaceidFeaturesResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_data));

  /// Create a copy of SpacematePlaceidFeaturesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpacematePlaceidFeaturesResponseImplCopyWith<
          _$SpacematePlaceidFeaturesResponseImpl>
      get copyWith => __$$SpacematePlaceidFeaturesResponseImplCopyWithImpl<
          _$SpacematePlaceidFeaturesResponseImpl>(this, _$identity);
}

abstract class _SpacematePlaceidFeaturesResponse
    implements SpacematePlaceidFeaturesResponse {
  const factory _SpacematePlaceidFeaturesResponse(
          {required final List<Feature> data}) =
      _$SpacematePlaceidFeaturesResponseImpl;

  @override
  List<Feature> get data;

  /// Create a copy of SpacematePlaceidFeaturesResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpacematePlaceidFeaturesResponseImplCopyWith<
          _$SpacematePlaceidFeaturesResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
