class MyssoProfile {
  MyssoProfile({
    this.custId,
    this.name,
    this.surname,
    this.cookie,
    this.memberOf,
    this.pass,
    this.college,
    this.grade,
    this.sno,
  });

  String custId;
  String name;
  String surname;
  String cookie;
  String memberOf;
  String pass;
  String college;
  int grade;
  String sno;

  bool get isUndergraduate {
    return memberOf?.contains('BZKS') == true;
  }

  @override
  String toString() {
    return 'MyssoProfile<$custId, $name>';
  }
}
