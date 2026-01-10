import 'package:flutter/widgets.dart';

extension ContainerToBoxExtension on Container {
  /// Converts a [Container] to a [SliverToBoxAdapter] with the same width and height.
  SliverToBoxAdapter toSliverBox() {
    return SliverToBoxAdapter(child: this);
  }
}