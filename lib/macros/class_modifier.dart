library;

import 'dart:async';

import 'package:collection/collection.dart';
import 'package:macros/macros.dart';

macro class FlutterBaseMacro
    implements ClassDeclarationsMacro, ClassDefinitionMacro {
  const FlutterBaseMacro();

  @override
  FutureOr<void> buildDeclarationsForClass(ClassDeclaration clazz,
      MemberDeclarationBuilder builder,) async {
    await Future.wait([
      const AutoConstructor().buildDeclarationsForClass(clazz, builder)
    ]);
  }

  @override
  FutureOr<void> buildDefinitionForClass(ClassDeclaration clazz,
      TypeDefinitionBuilder builder) {

  }
}

macro class AutoConstructor implements ClassDeclarationsMacro {
  const AutoConstructor();

  @override
  Future<void> buildDeclarationsForClass(ClassDeclaration clazz,
      MemberDeclarationBuilder builder) async {
    final constructors = await builder.constructorsOf(clazz);
    if (constructors.any((c) => c.identifier.name == '')) {
      throw ArgumentError(
          'Cannot generate an unnamed constructor because one already exists');
    }

    final params = <Object>[];
    // Add all the fields of `declaration` as named parameters.
    final fields = await builder.fieldsOf(clazz);
    if (fields.isNotEmpty) {
      for (final field in fields) {
        final requiredKeyword = field.type.isNullable ? '' : 'required ';
        params.addAll(['\n$requiredKeyword', field.identifier, ',']);
      }
    }

    // The object type from dart:core.
    final objectType = await builder.resolve(NamedTypeAnnotationCode(
        name:
        // ignore: deprecated_member_use
        await builder.resolveIdentifier(Uri.parse('dart:core'), 'Object')));

    // Add all super constructor parameters as named parameters.
    final superclass = clazz.superclass == null
        ? null
        : await builder.typeDeclarationOf(clazz.superclass!.identifier);
    final superType = superclass == null
        ? null
        : await builder
        .resolve(NamedTypeAnnotationCode(name: superclass.identifier));
    MethodDeclaration? superconstructor;
    if (superType != null && (await superType.isExactly(objectType)) == false) {
      superconstructor = (await builder.constructorsOf(superclass!))
          .firstWhereOrNull((c) => c.identifier.name == '');
      if (superconstructor == null) {
        throw ArgumentError(
            'Super class $superclass of $clazz does not have an unnamed '
                'constructor');
      }
      // We convert positional parameters in the super constructor to named
      // parameters in this constructor.
      for (final param in superconstructor.positionalParameters) {
        final requiredKeyword = param.isRequired ? 'required' : '';
        params.addAll([
          '\n$requiredKeyword',
          param.type.code,
          ' ${param.identifier.name},',
        ]);
      }
      for (final param in superconstructor.namedParameters) {
        final requiredKeyword = param.isRequired ? '' : 'required ';
        params.addAll([
          '\n$requiredKeyword',
          param.type.code,
          ' ${param.identifier.name},',
        ]);
      }
    }

    final hasParams = params.isNotEmpty;
    final parts = <Object>[
      // Don't use the identifier here because it should just be the raw name.
      clazz.identifier.name,
      '(',
      if (hasParams) '{',
      ...params,
      if (hasParams) '}',
      ')',
    ];
    if (superconstructor != null) {
      parts.addAll([' : super(']);
      for (final param in superconstructor.positionalParameters) {
        parts.add('\n${param.identifier.name},');
      }
      if (superconstructor.namedParameters.isNotEmpty) {
        for (final param in superconstructor.namedParameters) {
          parts.add('\n${param.identifier.name}: ${param.identifier.name},');
        }
      }
      parts.add(')');
    }
    parts.add(';');
    builder.declareInType(DeclarationCode.fromParts(parts));
  }
}