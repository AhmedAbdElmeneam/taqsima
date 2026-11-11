class BlockedSlot {
  const BlockedSlot({
    required this.id,
    required this.pitchId,
    required this.startAt,
    required this.endAt,
    this.reason,
  });

  final String id;
  final String pitchId;
  final DateTime startAt;
  final DateTime endAt;
  final String? reason;

  bool overlaps(DateTime start, DateTime end) =>
      startAt.isBefore(end) && endAt.isAfter(start);
}
