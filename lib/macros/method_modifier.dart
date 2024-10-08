import 'dart:async';

import 'package:macros/macros.dart';

macro class MethodModifier implements MethodDefinitionMacro {
  const MethodModifier();

  @override
  FutureOr<void> buildDefinitionForMethod(MethodDeclaration method,
      FunctionDefinitionBuilder builder) async {
    // TODO: implement buildDefinitionForMethod
    throw UnimplementedError();
  }

}