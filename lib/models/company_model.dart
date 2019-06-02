class CompanyModel {
  String id;
  String name;
  String phoneNumber;
  String address;
  String email;
  String company;


  CompanyModel(this.id, this.name, this.phoneNumber, this.address, this.email,
      this.company);

  CompanyModel.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.phoneNumber = obj['phoneNumber'];
    this.address = obj['address'];
    this.email = obj['email'];
    this.company = obj['company'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = this.id;
    map['name'] = this.name;
    map['phoneNumber'] = this.phoneNumber;
    map['address'] = this.address;
    map['email'] = this.email;
    map['company'] = this.company;
    return map;
  }

  CompanyModel.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.phoneNumber = map['phoneNumber'];
    this.address = map['address'];
    this.email = map['email'];
    this.company = map['company'];
  }
}
