class Genre
{
  int? id;
  String? name;

  Genre(this.id , this.name);

  Genre.fromjson(Map<String , dynamic>json)
  {
    id = json['id'];
    name = json['name'];
  }
}