// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:injectable/injectable.dart';
// import 'package:oneship_mobile/features/user/data/models/model_province.dart';

// @singleton
// class RegionData {
//   static List<ProvinceData> _provinces = [];
//   static List<ProvinceData> get provinces => _provinces;

//   static List<WardData> _wards = [];
//   static List<WardData> get wards => _wards;

//   @PostConstruct()
//   Future<void> init() async {
//     final resProvinces = await rootBundle.loadString(
//       "assets/json/provinces.json",
//     );
//     final List<dynamic> provinceList = jsonDecode(resProvinces);
//     _provinces = provinceList.map((e) => ProvinceData.fromJson(e)).toList();

//     final resWard = await rootBundle.loadString("assets/json/wards.json");
//     final List<dynamic> wardList = jsonDecode(resWard);
//     _wards = wardList.map((e) => WardData.fromJson(e)).toList();
//   }
// }
