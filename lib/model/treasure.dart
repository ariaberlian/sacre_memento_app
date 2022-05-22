class Treasure {
  final int id;
  final String name;
  final String thumbnail;
  final String type;
  final String extention;
  final String path;
  final String softpath;
  final String whichmem;
  final int size;
  // ignore: non_constant_identifier_names
  final String? time_added;

  const Treasure({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.type,
    required this.extention,
    required this.path,
    required this.softpath,
    required this.whichmem,
    required this.size,
    // ignore: non_constant_identifier_names
    this.time_added
  });

  factory Treasure.fromMap(Map<String, dynamic> json) => Treasure(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
      type: json['type'],
      extention: json['extention'],
      path: json['path'],
      softpath: json['softpath'],
      whichmem: json['whichmem'],
      size: json['size'],
      time_added: json['time_added']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'thumbnail' : thumbnail,
      'type': type,
      'extention': extention,
      'path': path,
      'softpath': softpath,
      'whichmem': whichmem,
      'size': size,
      'time_added': time_added
    };
  }
}
