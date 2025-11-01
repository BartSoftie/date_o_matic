import 'dart:async';
import 'dart:collection';

/// A set that automatically cleans up entries after a certain duration.
class AutoCleanupSet<T> {
  final HashSet<T> _discoveredIds = HashSet();
  final Queue<(DateTime, T)> _discoveredItemsQueue = Queue();
  final Duration _cleanupInterval;
  final Duration _removeOlderThan;

  /// Creates an instance of this class. This class stores unique entries of
  /// type [T].
  /// [removeOlderThan] specifies the duration after which entries are removed.
  /// [cleanupInterval] specifies how often the cleanup process runs. If set to
  /// [Duration.zero], cleanup will be triggered with each add operation.
  AutoCleanupSet(
      {Duration removeOlderThan = const Duration(minutes: 10),
      Duration cleanupInterval = Duration.zero})
      : _removeOlderThan = removeOlderThan,
        _cleanupInterval = cleanupInterval {
    if (_cleanupInterval != Duration.zero) {
      Timer.periodic(_cleanupInterval, (timer) {
        _cleanup();
      });
    }
  }

  /// Returns an unmodifiable view of the items in the set.
  UnmodifiableSetView<T> get items => UnmodifiableSetView(_discoveredIds);

  /// Adds the given [entry] to the set. Returns `true` if the entry was added,
  /// else `false`.
  bool add(T entry) {
    bool itemAdded = _discoveredIds.add(entry);
    if (itemAdded) {
      _discoveredItemsQueue.addLast((DateTime.now(), entry));
      if (_cleanupInterval == Duration.zero) {
        _cleanup();
      }
    }
    return itemAdded;
  }

  void _cleanup() {
    DateTime threshold = DateTime.now().subtract(_removeOlderThan);
    while (_discoveredItemsQueue.isNotEmpty &&
        _discoveredItemsQueue.first.$1.isBefore(threshold)) {
      var removed = _discoveredItemsQueue.removeFirst();
      _discoveredIds.remove(removed.$2);
    }
  }
}
