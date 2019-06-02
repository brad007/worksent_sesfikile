abstract class Model{
  String id;
  int dateCreated;
  int dateUpdated;

  Model.map(dynamic obj);
  Map<String, dynamic> toMap();
  Model.fromMap(Map<String, dynamic> map);

  Model(this.id, this.dateCreated, this.dateUpdated);
}