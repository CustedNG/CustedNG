class SchoolInfo {
  dynamic pyszm;
  dynamic userDataPowerSchools;
  dynamic logCreate;
  dynamic logAudit;
  dynamic bdxqxxid;
  String xqmc;
  bool jybj;
  dynamic areaInfos;
  dynamic jj;
  String xqbh;
  dynamic roomInfos;
  dynamic ywmc;
  String id;
  dynamic logUpdate;
  dynamic classInfos;
  dynamic zzclBlob;
  dynamic bz;
  dynamic teachBuildings;

  SchoolInfo({
    this.pyszm,
    this.userDataPowerSchools,
    this.logCreate,
    this.logAudit,
    this.bdxqxxid,
    this.xqmc,
    this.jybj,
    this.areaInfos,
    this.jj,
    this.xqbh,
    this.roomInfos,
    this.ywmc,
    this.id,
    this.logUpdate,
    this.classInfos,
    this.zzclBlob,
    this.bz,
    this.teachBuildings,
  });

  factory SchoolInfo.fromJson(Map<String, dynamic> json) {
    return SchoolInfo(
      pyszm: json['PYSZM'],
      userDataPowerSchools: json['UserDataPowerSchools'],
      logCreate: json['_LogCreate'],
      logAudit: json['_LogAudit'],
      bdxqxxid: json['BDXQXXID'],
      xqmc: json['XQMC'] as String,
      jybj: json['JYBJ'] as bool,
      areaInfos: json['AreaInfos'],
      jj: json['JJ'],
      xqbh: json['XQBH'] as String,
      roomInfos: json['RoomInfos'],
      ywmc: json['YWMC'],
      id: json['ID'] as String,
      logUpdate: json['_LogUpdate'],
      classInfos: json['ClassInfos'],
      zzclBlob: json['ZZCLBlob'],
      bz: json['BZ'],
      teachBuildings: json['TeachBuildings'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PYSZM': pyszm,
      'UserDataPowerSchools': userDataPowerSchools,
      '_LogCreate': logCreate,
      '_LogAudit': logAudit,
      'BDXQXXID': bdxqxxid,
      'XQMC': xqmc,
      'JYBJ': jybj,
      'AreaInfos': areaInfos,
      'JJ': jj,
      'XQBH': xqbh,
      'RoomInfos': roomInfos,
      'YWMC': ywmc,
      'ID': id,
      '_LogUpdate': logUpdate,
      'ClassInfos': classInfos,
      'ZZCLBlob': zzclBlob,
      'BZ': bz,
      'TeachBuildings': teachBuildings,
    };
  }
}
