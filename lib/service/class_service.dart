class ClassService {
  int id, status;
  String content;

  ClassService({
    required this.id,
    required this.status,
    required this.content,
  });

  factory ClassService.fromJson({required Map<String, dynamic> mapData}) {
    return ClassService(
      id: mapData['id'],
      status: mapData['status'],
      content: mapData['content'],
    );
  }
}
