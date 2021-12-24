class Cast
{
  int? id;
  String? character;
  String? name;
  String? image;

  Cast(this.id,this.name,this.image,this.character);

  Cast.fromjson(Map<String , dynamic> json)
  {
    id = json['cast_id'];
    character = json['character'];
    name = json['name'];
    image = json['profile_path'];
  }
}