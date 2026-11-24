import 'package:flame/components.dart';
import '../components/environment/construction_backdrop.dart';
import '../components/environment/ground_component.dart';
import '../components/excavator/excavator_placeholder.dart';

/// The 2D side-view game world for Construction Simulator.
///
/// Contains environmental terrain, backdrops, and interactive construction machinery.
class ConstructionWorld extends World {
  late final ConstructionBackdrop backdrop;
  late final GroundComponent ground;
  late final ExcavatorPlaceholder excavator;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Add background environment placeholder
    backdrop = ConstructionBackdrop();
    await add(backdrop);

    // 2. Add ground surface and subterranean strata
    ground = GroundComponent();
    await add(ground);

    // 3. Add excavator placeholder on the ground surface
    excavator = ExcavatorPlaceholder();
    await add(excavator);
  }
}
