import 'rows.dart';

class PagingResult {
  int total;
  dynamic verifyRelationsList;
  List<Rows> rows;

  PagingResult({
    this.total,
    this.verifyRelationsList,
    this.rows,
  });

  factory PagingResult.fromJson(Map<String, dynamic> json) {
    return PagingResult(
      total: json['Total'] as int,
      verifyRelationsList: json['VerifyRelationsList'],
      rows: (json['Rows'] as List<dynamic>)
          ?.map((e) =>
              e == null ? null : Rows.fromJson(e as Map<String, dynamic>))
          ?.toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Total': total,
      'VerifyRelationsList': verifyRelationsList,
      'Rows': rows?.map((e) => e?.toJson())?.toList(),
    };
  }
}
