class MyssoProfile {
  MyssoProfile({
    this.custId,
    this.name,
    this.surname,
    this.cookie,
    this.memberOf,
    this.pass,
  });

  String custId;
  String name;
  String surname;
  String cookie;
  String memberOf;
  String pass;

  @override
  String toString() {
    return 'MyssoProfile<$custId, $name>';
  }
}
