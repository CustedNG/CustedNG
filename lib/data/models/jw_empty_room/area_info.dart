class AreaInfo {
  dynamic pyszm;
  bool zybz;
  dynamic bz;
  dynamic logCreate;
  dynamic logAudit;
  dynamic bdxqxxid;
  bool jybj;
  String id;
  dynamic schoolInfo;
  dynamic jj;
  dynamic logUpdate;
  dynamic roomInfos;
  dynamic ywmc;
  String fqmc;
  dynamic zzclBlob;
  bool tycbj;
  dynamic bdfqxxid;
  String fqbh;

  AreaInfo({
    this.pyszm,
    this.zybz,
    this.bz,
    this.logCreate,
    this.logAudit,
    this.bdxqxxid,
    this.jybj,
    this.id,
    this.schoolInfo,
    this.jj,
    this.logUpdate,
    this.roomInfos,
    this.ywmc,
    this.fqmc,
    this.zzclBlob,
    this.tycbj,
    this.bdfqxxid,
    this.fqbh,
  });

  factory AreaInfo.fromJson(Map<String, dynamic> json) {
    return AreaInfo(
      pyszm: json['PYSZM'],
      zybz: json['ZYBZ'] as bool,
      bz: json['BZ'],
      logCreate: json['_LogCreate'],
      logAudit: json['_LogAudit'],
      bdxqxxid: json['BDXQXXID'],
      jybj: json['JYBJ'] as bool,
      id: json['ID'] as String,
      schoolInfo: json['SchoolInfo'],
      jj: json['JJ'],
      logUpdate: json['_LogUpdate'],
      roomInfos: json['RoomInfos'],
      ywmc: json['YWMC'],
      fqmc: json['FQMC'] as String,
      zzclBlob: json['ZZCLBlob'],
      tycbj: json['TYCBJ'] as bool,
      bdfqxxid: json['BDFQXXID'],
      fqbh: json['FQBH'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'PYSZM': pyszm,
      'ZYBZ': zybz,
      'BZ': bz,
      '_LogCreate': logCreate,
      '_LogAudit': logAudit,
      'BDXQXXID': bdxqxxid,
      'JYBJ': jybj,
      'ID': id,
      'SchoolInfo': schoolInfo,
      'JJ': jj,
      '_LogUpdate': logUpdate,
      'RoomInfos': roomInfos,
      'YWMC': ywmc,
      'FQMC': fqmc,
      'ZZCLBlob': zzclBlob,
      'TYCBJ': tycbj,
      'BDFQXXID': bdfqxxid,
      'FQBH': fqbh,
    };
  }
}
