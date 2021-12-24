class Person
{
  int? id;
  double? popularity;
  String? name;
  String? title;
  String? profileImg;
  String? known;

  Person(this.id,
      this.popularity,
      this.name,
      this.title,
      this.known,
      this.profileImg
      );

  Person.fromjson(Map<String, dynamic> json)
  {
    id = json['id'];
    popularity = json['popularity'];
    name = json['name'];
    title = json['title'];
    known = json['known_for_department'];
    profileImg = json['profile_path'];
  }
}