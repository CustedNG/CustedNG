class TeachBuilding {
  dynamic bz;
  String jxlbh;
  dynamic bdxqxxid;
  bool jybj;
  dynamic zzclBlob;
  dynamic ywmc;
  dynamic bdjxlxxid;
  dynamic jzwlx;
  dynamic roomInfos;
  String jxlmc;
  dynamic logCreate;
  dynamic cs;
  dynamic logUpdate;
  dynamic schoolInfo;
  dynamic dz;
  String id;
  dynamic logAudit;
  dynamic jj;
  bool zybz;
  dynamic jzwzk;
  dynamic pyszm;
  dynamic jc;

  TeachBuilding({
    this.bz,
    this.jxlbh,
    this.bdxqxxid,
    this.jybj,
    this.zzclBlob,
    this.ywmc,
    this.bdjxlxxid,
    this.jzwlx,
    this.roomInfos,
    this.jxlmc,
    this.logCreate,
    this.cs,
    this.logUpdate,
    this.schoolInfo,
    this.dz,
    this.id,
    this.logAudit,
    this.jj,
    this.zybz,
    this.jzwzk,
    this.pyszm,
    this.jc,
  });

  factory TeachBuilding.fromJson(Map<String, dynamic> json) {
    return TeachBuilding(
      bz: json['BZ'],
      jxlbh: json['JXLBH'] as String,
      bdxqxxid: json['BDXQXXID'],
      jybj: json['JYBJ'] as bool,
      zzclBlob: json['ZZCLBlob'],
      ywmc: json['YWMC'],
      bdjxlxxid: json['BDJXLXXID'],
      jzwlx: json['JZWLX'],
      roomInfos: json['RoomInfos'],
      jxlmc: json['JXLMC'] as String,
      logCreate: json['_LogCreate'],
      cs: json['CS'],
      logUpdate: json['_LogUpdate'],
      schoolInfo: json['SchoolInfo'],
      dz: json['DZ'],
      id: json['ID'] as String,
      logAudit: json['_LogAudit'],
      jj: json['JJ'],
      zybz: json['ZYBZ'] as bool,
      jzwzk: json['JZWZK'],
      pyszm: json['PYSZM'],
      jc: json['JC'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BZ': bz,
      'JXLBH': jxlbh,
      'BDXQXXID': bdxqxxid,
      'JYBJ': jybj,
      'ZZCLBlob': zzclBlob,
      'YWMC': ywmc,
      'BDJXLXXID': bdjxlxxid,
      'JZWLX': jzwlx,
      'RoomInfos': roomInfos,
      'JXLMC': jxlmc,
      '_LogCreate': logCreate,
      'CS': cs,
      '_LogUpdate': logUpdate,
      'SchoolInfo': schoolInfo,
      'DZ': dz,
      'ID': id,
      '_LogAudit': logAudit,
      'JJ': jj,
      'ZYBZ': zybz,
      'JZWZK': jzwzk,
      'PYSZM': pyszm,
      'JC': jc,
    };
  }
}
