class KBProSchedule {
  String kSJC;
  String jXBMC;
  String sKZC;
  String xM;
  String wEEK;
  String kBLX;
  String jSXM;
  String jSMC;
  String sKZCTYPE;
  String kCMC;
  String jSJC;
  String xSFL;

  KBProSchedule(
      {this.kSJC,
      this.jXBMC,
      this.sKZC,
      this.xM,
      this.wEEK,
      this.kBLX,
      this.jSXM,
      this.jSMC,
      this.sKZCTYPE,
      this.kCMC,
      this.jSJC,
      this.xSFL});

  KBProSchedule.fromJson(Map<String, dynamic> json) {
    kSJC = json['KSJC'];
    jXBMC = json['JXBMC'];
    sKZC = json['SKZC'];
    xM = json['XM'];
    wEEK = json['WEEK'];
    kBLX = json['KBLX'];
    jSXM = json['JSXM'];
    jSMC = json['JSMC'];
    sKZCTYPE = json['SKZCTYPE'];
    kCMC = json['KCMC'];
    jSJC = json['JSJC'];
    xSFL = json['XSFL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['KSJC'] = this.kSJC;
    data['JXBMC'] = this.jXBMC;
    data['SKZC'] = this.sKZC;
    data['XM'] = this.xM;
    data['WEEK'] = this.wEEK;
    data['KBLX'] = this.kBLX;
    data['JSXM'] = this.jSXM;
    data['JSMC'] = this.jSMC;
    data['SKZCTYPE'] = this.sKZCTYPE;
    data['KCMC'] = this.kCMC;
    data['JSJC'] = this.jSJC;
    data['XSFL'] = this.xSFL;
    return data;
  }
}
