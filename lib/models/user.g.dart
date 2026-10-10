// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  username: json['username'] as String,
  role: $enumDecode(_$RoleEnumMap, json['role']),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'username': instance.username,
  'role': _$RoleEnumMap[instance.role]!,
};

const _$RoleEnumMap = {Role.cleaner: 'cleaner', Role.supervisor: 'supervisor'};
