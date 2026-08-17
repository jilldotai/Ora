import 'dart:math';
import 'package:flutter/material.dart';

/// A signal-processing filter that reduces jitter in noisy tracking data
/// while maintaining low latency for fast movements.
/// Based on the One Euro Filter algorithm.
class OneEuroFilter {
  final double freq;
  final double mincutoff;
  final double beta;
  final double dcutoff;

  double? _xPrev;
  double? _dxPrev;
  int? _lastTime;

  OneEuroFilter({
    this.freq = 60.0,      // Assume 60fps internal update
    this.mincutoff = 1.0,  // Decrease to reduce jitter at rest
    this.beta = 0.007,     // Increase to reduce lag during fast motion
    this.dcutoff = 1.0,
  });

  double filter(double x, {int? timestamp}) {
    double te;
    if (_lastTime != null && timestamp != null) {
      te = (timestamp - _lastTime!) / 1000.0;
    } else {
      te = 1.0 / freq;
    }
    _lastTime = timestamp;

    double edx;
    if (_xPrev == null) {
      edx = 0.0;
    } else {
      edx = (x - _xPrev!) / te;
    }

    double dx = _lowPassFilter(edx, _dxPrev ?? 0.0, _alpha(te, dcutoff));
    _dxPrev = dx;

    double cutoff = mincutoff + beta * dx.abs();
    double rx = _lowPassFilter(x, _xPrev ?? x, _alpha(te, cutoff));
    _xPrev = rx;

    return rx;
  }

  double _alpha(double te, double cutoff) {
    double tau = 1.0 / (2.0 * pi * cutoff);
    return 1.0 / (1.0 + tau / te);
  }

  double _lowPassFilter(double x, double yPrev, double alpha) {
    return alpha * x + (1.0 - alpha) * yPrev;
  }

  void reset() {
    _xPrev = null;
    _dxPrev = null;
    _lastTime = null;
  }
}

/// A helper to filter 2D [Offset] points (e.g. eye or mouth landmarks)
class OffsetFilter {
  late final OneEuroFilter _xFilter;
  late final OneEuroFilter _yFilter;

  OffsetFilter({double mincutoff = 1.0, double beta = 0.007}) {
    _xFilter = OneEuroFilter(mincutoff: mincutoff, beta: beta);
    _yFilter = OneEuroFilter(mincutoff: mincutoff, beta: beta);
  }

  Offset filter(Offset input, {int? timestamp}) {
    return Offset(
      _xFilter.filter(input.dx, timestamp: timestamp),
      _yFilter.filter(input.dy, timestamp: timestamp),
    );
  }

  void reset() {
    _xFilter.reset();
    _yFilter.reset();
  }
}
