
import 'package:json_annotation/json_annotation.dart';

enum Genre {
  @JsonValue('pop')
  pop,
  @JsonValue('rock')
  rock,
  @JsonValue('hiphop')
  hiphop,
  @JsonValue('rnb')
  rnb,
  @JsonValue('country')
  country,
  @JsonValue('edm')
  edm,
  @JsonValue('jazz')
  jazz,
  @JsonValue('latin')
  latin,
  @JsonValue('classical')
  classical,
  @JsonValue('reggae')
  reggae,
  @JsonValue('blues')
  blues,
  @JsonValue('soul')
  soul,
  @JsonValue('funk')
  funk,
  @JsonValue('metal')
  metal,
  @JsonValue('punk')
  punk,
  @JsonValue('indie')
  indie,
  @JsonValue('folk')
  folk,
  @JsonValue('other')
  other,
}
