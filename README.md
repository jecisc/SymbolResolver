# SymbolResolver
A parsing helper to manage symbol resolution by handling scope resolution and finding the right entity from symbols in parsers

- [SymbolResolver](#symbolresolver)
  - [Installation](#installation)
  - [Documentation](#documentation)
  - [Version management](#version-management)
  - [Smalltalk versions compatibility](#smalltalk-versions-compatibility)
  - [Contact](#contact)

## Installation

To install SymbolResolver on your Pharo image, execute the following script: 

```Smalltalk
Metacello new
	githubUser: 'jecisc' project: 'SymbolResolver' commitish: 'main' path: 'src';
	baseline: 'SymbolResolver';
	load
```

To add SymbolResolver to your baseline:

```Smalltalk
spec
	baseline: 'SymbolResolver'
	with: [ spec repository: 'github://jecisc/SymbolResolver:main/src' ]
```

Note you can replace the #main by another branch such as #development or a tag such as #v1.0.0, #v1.? or #v1.2.? .

## Documentation

TODO

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
| 1.x.x       	| Pharo 70, 80, 90, 10, 11, 12, 13 |

## Contact

If you have any questions or problems do not hesitate to open an issue or contact cyril (a) ferlicot.fr