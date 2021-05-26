import 'paging_result.dart';

class Data {
  dynamic codes;
  dynamic operationResult;
  dynamic dto;
  PagingResult pagingResult;
  dynamic permissionResult;
  dynamic id;
  dynamic dtos;

  Data({
    this.codes,
    this.operationResult,
    this.dto,
    this.pagingResult,
    this.permissionResult,
    this.id,
    this.dtos,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      codes: json['Codes'],
      operationResult: json['OperationResult'],
      dto: json['Dto'],
      pagingResult: json['PagingResult'] == null
          ? null
          : PagingResult.fromJson(json['PagingResult'] as Map<String, dynamic>),
      permissionResult: json['PermissionResult'],
      id: json['ID'],
      dtos: json['Dtos'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Codes': codes,
      'OperationResult': operationResult,
      'Dto': dto,
      'PagingResult': pagingResult?.toJson(),
      'PermissionResult': permissionResult,
      'ID': id,
      'Dtos': dtos,
    };
  }
}
