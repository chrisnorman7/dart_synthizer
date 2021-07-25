/// Provides the [BufferCache] class.
import 'dart:io';

import 'buffer.dart';
import 'synthizer.dart';

/// A class to get and hold buffers.
///
/// This class implements an LRU cache.
class BufferCache {
  /// Create a cache.
  BufferCache(this.synthizer, this.maxSize)
      : buffers = {},
        _files = [];

  /// The synthizer instance to use.
  final Synthizer synthizer;

  /// The maximum size of this cache.
  ///
  /// Note:
  /// * `1024` is 1 KB.
  /// * `1024 ** 2` is 1 MB.
  /// * `1024 ** 3` is 1 GB.
  final int maxSize;

  /// The map which holds buffers.
  final Map<String, Buffer> buffers;

  /// The most recently-accessed buffers.
  final List<String> _files;

  /// The size of this cache so far.
  int _size = 0;

  /// The current size of the cache.
  int get size => _size;

  /// Get a buffer.
  Buffer getBuffer(File file) {
    var buffer = buffers[file.path];
    if (buffer == null) {
      buffer = Buffer.fromFile(synthizer, file);
      _size += buffer.size;
      while (size > maxSize && _files.isNotEmpty) {
        final f = _files.removeAt(0);
        final b = buffers.remove(f);
        if (b == null) {
          throw Exception('No clue what happened there.');
        }
        _size -= b.size;
        b.destroy();
      }
      _files.add(file.path);
      buffers[file.path] = buffer;
    }
    return buffer;
  }
}
