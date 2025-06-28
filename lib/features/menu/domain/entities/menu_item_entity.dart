import 'package:equatable/equatable.dart';

class MenuItemEntity extends Equatable {
  final int id;
  final String label;
  final String? icon;
  final int order;
  final bool isVisible;
  final bool isAvailable;
  final int? badgeCount;
  final String? navigationTarget;

  const MenuItemEntity({
    required this.id,
    required this.label,
    this.icon,
    required this.order,
    required this.isVisible,
    required this.isAvailable,
    this.badgeCount,
    this.navigationTarget,
  });

  @override
  List<Object?> get props => [id, label, icon, order, isVisible, isAvailable, badgeCount, navigationTarget];
}
