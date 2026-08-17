/// A simplified physics engine for 2D VTubers.
/// Simulates a pendulum-like sway for hair and clothes.
class AvatarPhysics {
  final double mass;
  final double gravity;
  final double friction;
  final double stiffness;

  double _position = 0.0;
  double _velocity = 0.0;
  double _acceleration = 0.0;
  int? _lastTimestamp;

  AvatarPhysics({
    this.mass = 1.0,
    this.gravity = 9.8,
    this.friction = 0.95,
    this.stiffness = 0.1,
  });

  /// Updates the physics state based on an external force (e.g. head movement)
  /// [force] is usually derived from the head yaw/pitch change.
  double update(double externalForce, {int? timestamp}) {
    final int now = timestamp ?? DateTime.now().millisecondsSinceEpoch;
    if (_lastTimestamp == null) {
      _lastTimestamp = now;
      return _position;
    }

    final double dt = (now - _lastTimestamp!) / 1000.0;
    if (dt <= 0) return _position;
    _lastTimestamp = now;

    // F = ma -> a = F/m
    // We add a "restoring force" to pull it back to center (stiffness)
    final double restoringForce = -_position * stiffness;
    _acceleration = (externalForce + restoringForce) / mass;

    // Update velocity and position
    _velocity = (_velocity + _acceleration * dt) * friction;
    _position += _velocity * dt;

    // Clamp to avoid extreme values
    _position = _position.clamp(-1.0, 1.0);

    return _position;
  }

  void reset() {
    _position = 0.0;
    _velocity = 0.0;
    _acceleration = 0.0;
    _lastTimestamp = null;
  }
}

/// Manages multiple physics groups (e.g. Front Hair, Back Hair)
class PhysicsManager {
  final Map<String, AvatarPhysics> _groups = {};

  void addGroup(String name, {double stiffness = 0.1, double friction = 0.95}) {
    _groups[name] = AvatarPhysics(stiffness: stiffness, friction: friction);
  }

  double updateGroup(String name, double force, {int? timestamp}) {
    return _groups[name]?.update(force, timestamp: timestamp) ?? 0.0;
  }

  void reset() {
    for (var group in _groups.values) {
      group.reset();
    }
  }
}
