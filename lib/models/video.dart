class Video
{
  String? id;
  String? key;
  String? name;
  String? site;
  String? type;

  Video(this.name,this.id,this.key,this.site,this.type);

  Video.fromjson(Map<String , dynamic> json)
  {
    id = json['id'];
    key = json['key'];
    name = json['name'];
    site = json['site'];
    type = json['type'];
  }
}