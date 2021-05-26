import 'area_info.dart';
import 'school_info.dart';
import 'teach_building.dart';

class Rows {
  int qz;
  int rnbs;
  bool zygdbj;
  dynamic departments;
  bool zybz;
  dynamic jsyh;
  AreaInfo areaInfo;
  dynamic zzclBlob;
  int rnksrs;
  dynamic jj;
  TeachBuilding teachBuilding;
  dynamic ywmc;
  dynamic bdfqxxid;
  String bdjsxxid;
  SchoolInfo schoolInfo;
  dynamic szlc;
  dynamic logUpdate;
  dynamic classInfos;
  bool iskjscx;
  String jsmc;
  dynamic bz;
  dynamic logAudit;
  dynamic bdjxlxxid;
  bool jybj;
  int rnrs;
  dynamic roomDepartments;
  dynamic roomDepartmentNames;
  String id;
  dynamic bdxqxxid;
  dynamic roomInfoSetLessonInfos;
  String jsbh;
  dynamic pyszm;
  dynamic logCreate;
  dynamic emptyWSeciton;
  bool ksbsbj;
  String jslx;
  bool ktbj;

  Rows({
    this.qz,
    this.rnbs,
    this.zygdbj,
    this.departments,
    this.zybz,
    this.jsyh,
    this.areaInfo,
    this.zzclBlob,
    this.rnksrs,
    this.jj,
    this.teachBuilding,
    this.ywmc,
    this.bdfqxxid,
    this.bdjsxxid,
    this.schoolInfo,
    this.szlc,
    this.logUpdate,
    this.classInfos,
    this.iskjscx,
    this.jsmc,
    this.bz,
    this.logAudit,
    this.bdjxlxxid,
    this.jybj,
    this.rnrs,
    this.roomDepartments,
    this.roomDepartmentNames,
    this.id,
    this.bdxqxxid,
    this.roomInfoSetLessonInfos,
    this.jsbh,
    this.pyszm,
    this.logCreate,
    this.emptyWSeciton,
    this.ksbsbj,
    this.jslx,
    this.ktbj,
  });

  factory Rows.fromJson(Map<String, dynamic> json) {
    return Rows(
      qz: json['QZ'] as int,
      rnbs: json['RNBS'] as int,
      zygdbj: json['ZYGDBJ'] as bool,
      departments: json['Departments'],
      zybz: json['ZYBZ'] as bool,
      jsyh: json['JSYH'],
      areaInfo: json['AreaInfo'] == null
          ? null
          : AreaInfo.fromJson(json['AreaInfo'] as Map<String, dynamic>),
      zzclBlob: json['ZZCLBlob'],
      rnksrs: json['RNKSRS'] as int,
      jj: json['JJ'],
      teachBuilding: json['TeachBuilding'] == null
          ? null
          : TeachBuilding.fromJson(
              json['TeachBuilding'] as Map<String, dynamic>),
      ywmc: json['YWMC'],
      bdfqxxid: json['BDFQXXID'],
      bdjsxxid: json['BDJSXXID'] as String,
      schoolInfo: json['SchoolInfo'] == null
          ? null
          : SchoolInfo.fromJson(json['SchoolInfo'] as Map<String, dynamic>),
      szlc: json['SZLC'],
      logUpdate: json['_LogUpdate'],
      classInfos: json['ClassInfos'],
      iskjscx: json['ISKJSCX'] as bool,
      jsmc: json['JSMC'] as String,
      bz: json['BZ'],
      logAudit: json['_LogAudit'],
      bdjxlxxid: json['BDJXLXXID'],
      jybj: json['JYBJ'] as bool,
      rnrs: json['RNRS'] as int,
      roomDepartments: json['RoomDepartments'],
      roomDepartmentNames: json['RoomDepartmentNames'],
      id: json['ID'] as String,
      bdxqxxid: json['BDXQXXID'],
      roomInfoSetLessonInfos: json['RoomInfoSetLessonInfos'],
      jsbh: json['JSBH'] as String,
      pyszm: json['PYSZM'],
      logCreate: json['_LogCreate'],
      emptyWSeciton: json['EmptyWSeciton'],
      ksbsbj: json['KSBSBJ'] as bool,
      jslx: json['JSLX'] as String,
      ktbj: json['KTBJ'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'QZ': qz,
      'RNBS': rnbs,
      'ZYGDBJ': zygdbj,
      'Departments': departments,
      'ZYBZ': zybz,
      'JSYH': jsyh,
      'AreaInfo': areaInfo?.toJson(),
      'ZZCLBlob': zzclBlob,
      'RNKSRS': rnksrs,
      'JJ': jj,
      'TeachBuilding': teachBuilding?.toJson(),
      'YWMC': ywmc,
      'BDFQXXID': bdfqxxid,
      'BDJSXXID': bdjsxxid,
      'SchoolInfo': schoolInfo?.toJson(),
      'SZLC': szlc,
      '_LogUpdate': logUpdate,
      'ClassInfos': classInfos,
      'ISKJSCX': iskjscx,
      'JSMC': jsmc,
      'BZ': bz,
      '_LogAudit': logAudit,
      'BDJXLXXID': bdjxlxxid,
      'JYBJ': jybj,
      'RNRS': rnrs,
      'RoomDepartments': roomDepartments,
      'RoomDepartmentNames': roomDepartmentNames,
      'ID': id,
      'BDXQXXID': bdxqxxid,
      'RoomInfoSetLessonInfos': roomInfoSetLessonInfos,
      'JSBH': jsbh,
      'PYSZM': pyszm,
      '_LogCreate': logCreate,
      'EmptyWSeciton': emptyWSeciton,
      'KSBSBJ': ksbsbj,
      'JSLX': jslx,
      'KTBJ': ktbj,
    };
  }
}
