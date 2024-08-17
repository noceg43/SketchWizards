class SWPlayer {
  final int id;
  final String name;
  SWPlayer({
    required this.id,
    required this.name,
  });

  SWPlayer copyWith({
    int? id,
    String? name,
  }) {
    return SWPlayer(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  String toString() => 'SWPlayer(id: $id, name: $name)';

  @override
  bool operator ==(covariant SWPlayer other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
