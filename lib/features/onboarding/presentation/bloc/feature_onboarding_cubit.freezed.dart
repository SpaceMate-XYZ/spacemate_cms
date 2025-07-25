// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feature_onboarding_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FeatureOnboardingState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeatureOnboardingStateCopyWith<$Res> {
  factory $FeatureOnboardingStateCopyWith(FeatureOnboardingState value,
          $Res Function(FeatureOnboardingState) then) =
      _$FeatureOnboardingStateCopyWithImpl<$Res, FeatureOnboardingState>;
}

/// @nodoc
class _$FeatureOnboardingStateCopyWithImpl<$Res,
        $Val extends FeatureOnboardingState>
    implements $FeatureOnboardingStateCopyWith<$Res> {
  _$FeatureOnboardingStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$FeatureOnboardingStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'FeatureOnboardingState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements FeatureOnboardingState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$FeatureOnboardingStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl implements _Loading {
  const _$LoadingImpl();

  @override
  String toString() {
    return 'FeatureOnboardingState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements FeatureOnboardingState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$OnboardingNeededImplCopyWith<$Res> {
  factory _$$OnboardingNeededImplCopyWith(_$OnboardingNeededImpl value,
          $Res Function(_$OnboardingNeededImpl) then) =
      __$$OnboardingNeededImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<OnboardingSlide> slides});
}

/// @nodoc
class __$$OnboardingNeededImplCopyWithImpl<$Res>
    extends _$FeatureOnboardingStateCopyWithImpl<$Res, _$OnboardingNeededImpl>
    implements _$$OnboardingNeededImplCopyWith<$Res> {
  __$$OnboardingNeededImplCopyWithImpl(_$OnboardingNeededImpl _value,
      $Res Function(_$OnboardingNeededImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? slides = null,
  }) {
    return _then(_$OnboardingNeededImpl(
      slides: null == slides
          ? _value._slides
          : slides // ignore: cast_nullable_to_non_nullable
              as List<OnboardingSlide>,
    ));
  }
}

/// @nodoc

class _$OnboardingNeededImpl implements _OnboardingNeeded {
  const _$OnboardingNeededImpl({required final List<OnboardingSlide> slides})
      : _slides = slides;

  final List<OnboardingSlide> _slides;
  @override
  List<OnboardingSlide> get slides {
    if (_slides is EqualUnmodifiableListView) return _slides;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_slides);
  }

  @override
  String toString() {
    return 'FeatureOnboardingState.onboardingNeeded(slides: $slides)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingNeededImpl &&
            const DeepCollectionEquality().equals(other._slides, _slides));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_slides));

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingNeededImplCopyWith<_$OnboardingNeededImpl> get copyWith =>
      __$$OnboardingNeededImplCopyWithImpl<_$OnboardingNeededImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) {
    return onboardingNeeded(slides);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) {
    return onboardingNeeded?.call(slides);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (onboardingNeeded != null) {
      return onboardingNeeded(slides);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) {
    return onboardingNeeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) {
    return onboardingNeeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (onboardingNeeded != null) {
      return onboardingNeeded(this);
    }
    return orElse();
  }
}

abstract class _OnboardingNeeded implements FeatureOnboardingState {
  const factory _OnboardingNeeded(
      {required final List<OnboardingSlide> slides}) = _$OnboardingNeededImpl;

  List<OnboardingSlide> get slides;

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingNeededImplCopyWith<_$OnboardingNeededImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OnboardingNotNeededImplCopyWith<$Res> {
  factory _$$OnboardingNotNeededImplCopyWith(_$OnboardingNotNeededImpl value,
          $Res Function(_$OnboardingNotNeededImpl) then) =
      __$$OnboardingNotNeededImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String? navigationTarget});
}

/// @nodoc
class __$$OnboardingNotNeededImplCopyWithImpl<$Res>
    extends _$FeatureOnboardingStateCopyWithImpl<$Res,
        _$OnboardingNotNeededImpl>
    implements _$$OnboardingNotNeededImplCopyWith<$Res> {
  __$$OnboardingNotNeededImplCopyWithImpl(_$OnboardingNotNeededImpl _value,
      $Res Function(_$OnboardingNotNeededImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? navigationTarget = freezed,
  }) {
    return _then(_$OnboardingNotNeededImpl(
      navigationTarget: freezed == navigationTarget
          ? _value.navigationTarget
          : navigationTarget // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OnboardingNotNeededImpl implements _OnboardingNotNeeded {
  const _$OnboardingNotNeededImpl({this.navigationTarget});

  @override
  final String? navigationTarget;

  @override
  String toString() {
    return 'FeatureOnboardingState.onboardingNotNeeded(navigationTarget: $navigationTarget)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OnboardingNotNeededImpl &&
            (identical(other.navigationTarget, navigationTarget) ||
                other.navigationTarget == navigationTarget));
  }

  @override
  int get hashCode => Object.hash(runtimeType, navigationTarget);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OnboardingNotNeededImplCopyWith<_$OnboardingNotNeededImpl> get copyWith =>
      __$$OnboardingNotNeededImplCopyWithImpl<_$OnboardingNotNeededImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) {
    return onboardingNotNeeded(navigationTarget);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) {
    return onboardingNotNeeded?.call(navigationTarget);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (onboardingNotNeeded != null) {
      return onboardingNotNeeded(navigationTarget);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) {
    return onboardingNotNeeded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) {
    return onboardingNotNeeded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (onboardingNotNeeded != null) {
      return onboardingNotNeeded(this);
    }
    return orElse();
  }
}

abstract class _OnboardingNotNeeded implements FeatureOnboardingState {
  const factory _OnboardingNotNeeded({final String? navigationTarget}) =
      _$OnboardingNotNeededImpl;

  String? get navigationTarget;

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OnboardingNotNeededImplCopyWith<_$OnboardingNotNeededImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$FeatureOnboardingStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message});

  @override
  final String message;

  @override
  String toString() {
    return 'FeatureOnboardingState.error(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<OnboardingSlide> slides) onboardingNeeded,
    required TResult Function(String? navigationTarget) onboardingNotNeeded,
    required TResult Function(String message) error,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult? Function(String? navigationTarget)? onboardingNotNeeded,
    TResult? Function(String message)? error,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<OnboardingSlide> slides)? onboardingNeeded,
    TResult Function(String? navigationTarget)? onboardingNotNeeded,
    TResult Function(String message)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_OnboardingNeeded value) onboardingNeeded,
    required TResult Function(_OnboardingNotNeeded value) onboardingNotNeeded,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult? Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_OnboardingNeeded value)? onboardingNeeded,
    TResult Function(_OnboardingNotNeeded value)? onboardingNotNeeded,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements FeatureOnboardingState {
  const factory _Error({required final String message}) = _$ErrorImpl;

  String get message;

  /// Create a copy of FeatureOnboardingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
