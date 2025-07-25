# SymbolResolver
A parsing helper to manage symbol resolution by handling scope resolution and finding the right entity from symbols in parsers

<!-- TOC -->

- [SymbolResolver](#symbolresolver)
  - [Installation](#installation)
  - [Quick start](#quick-start)
  - [Documentation](#documentation)
  - [Version management](#version-management)
  - [Smalltalk versions compatibility](#smalltalk-versions-compatibility)
  - [Contact](#contact)

## Installation

To install SymbolResolver on your Pharo image, execute the following script: 

```Smalltalk
Metacello new
	githubUser: 'jecisc' project: 'SymbolResolver' commitish: '1.x.x' path: 'src';
	baseline: 'SymbolResolver';
	load
```

To add TinyLogger to your baseline:

```Smalltalk
spec
	baseline: 'SymbolResolver'
	with: [ spec repository: 'github://jecisc/SymbolResolver:1.x.x/src' ]
```

Note you can replace the #master by another branch such as #development or a tag such as #1.0.0, #1.0.x.

## Quick start

To start to use the symbol resolver you'll need to use the trait `SRTSolverUserVisitor` in your importer. 

Then you need to call #initializeSolver at the class initialization.

You can not add entities on your scope stack using `#useCurrentEntity:during:` like this:

```st
visitClassDefinition: aClassDef

	^ self
            useCurrentEntity: (self ensureClass: aClassDef)
            during: [
                super visitClassDefinition: aClassDef.
```

This will help you build the context stack.

Now that this is done you can start registering symbols to resolve. Here is a simple example:

```st
manageInheritanceDeclaredBy: superclassNode

	| inheritance |
	"The next line will create a FamixPythonInheritance with its source anchor and the subclass already set"
	inheritance := self createInheritanceFrom: superclassNode.

	self
		resolve: ((SRIdentifierResolvable identifier: superclassNode sourceText) "This gives the name of the superclass"
				 expectedKind: FamixPythonClass; "Here I difine that the entity I can find should be a class"
				 notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ]; "If I don't find the entity, I create a stub"
				 yourself)
		foundAction: [ :entity :currentEntity | inheritance superclass: entity ] "And now that I have the entity, stub or not, I can set the superclass in my association"
```

And when you finished to register everything to resolve, you can launch the resolution execution doing:

```st
  self resolveUnresolvedSymbols
```

For more details, check the full documentation provided next section.

## Documentation

You can find the full documentation here: [User documentation](resources/docs/UserDocumentation.md)

## Version management 

This project use semantic versioning to define the releases. This means that each stable release of the project will be assigned a version number of the form `vX.Y.Z`. 

- **X** defines the major version number
- **Y** defines the minor version number 
- **Z** defines the patch version number

When a release contains only bug fixes, the patch number increases. When the release contains new features that are backward compatible, the minor version increases. When the release contains breaking changes, the major version increases. 

Thus, it should be safe to depend on a fixed major version and moving minor version of this project.

## Smalltalk versions compatibility

| Version 	| Compatible Pharo versions    |
|-------------	|------------------------------|
| 1.x.x       	| Pharo 70, 80, 90, 10, 11, 12, 13, 14 |

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.fr