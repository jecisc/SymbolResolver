# User Documentation of the Symbol Resolver

A parsing helper to manage symbol resolution by handling scope resolution and finding the right entity from symbols in parsers

<!-- TOC -->

- [User Documentation of the Symbol Resolver](#user-documentation-of-the-symbol-resolver)
	- [Getting started](#getting-started)
	- [Getting strated with SymbolResolver](#getting-strated-with-symbolresolver)
	- [Manage your scopes](#manage-your-scopes)
		- [Understanding the importance of scopes](#understanding-the-importance-of-scopes)
		- [Manage your scopes with the `SymbolResolver`](#manage-your-scopes-with-the-symbolresolver)
	- [Register symbols to resolve](#register-symbols-to-resolve)
		- [Resolution priority](#resolution-priority)
	- [Solvers](#solvers)
		- [Existing solvers](#existing-solvers)
			- [SRIdentifierResovable](#sridentifierresovable)
			- [SRLocalClassEntityResolvable](#srlocalclassentityresolvable)
		- [Add you own solver](#add-you-own-solver)
	- [Model integration](#model-integration)
		- [Moose integration](#moose-integration)
			- [Import management](#import-management)
			- [Aliases management](#aliases-management)
	- [Error repport](#error-repport)
	- [Advance cases](#advance-cases)
		- [Concept of Main Entity](#concept-of-main-entity)
		- [Use the result of a symbol resolution as a scope for another resolution](#use-the-result-of-a-symbol-resolution-as-a-scope-for-another-resolution)
		- [Reacheable entities as scope](#reacheable-entities-as-scope)
		- [Tree Sitter Famix Integration](#tree-sitter-famix-integration)

<!-- /TOC -->

## Getting started

The main goal of the symbol resolver is to simplify the symbol resolution during the development of a parser/importer. 

A classic architecture for the development of a parser to build a model is to:
- Define a grammar and a paser for this grammar 
- Generate a pseudo AST matching the grammar and produce it via the parser
- Visit a first time this AST to build all entities of the model
- Visit a second time this AST to build all relations between entities of the model (We need a second pass because we need to ensure that all entities are created before we resolve links between them)

![Schema of parsing flow](parsing.png)

> [!NOTE]
> Since this is a documentation of `Symbol Resolver`, lets defined what is a `Symbol`. A `Symbol` in the scope of this documentation is a dependency to resolve during the parsing. We call that a symbol because before the resolution we only have the name of the entity we depend on (this name or path is what we call a `Symbol`) and then the resolver is using this name and the context in which this symbols is defined to find the real entity related to this name.

This project aims to simplify this last step. With this project you need only one visitor. Instead of doing a second visit, we can register symbols to resolve during the first visit, `SRSymbolsResolver` will register them with a copy of the scopes and we are able to resolve all of them at the end when all entities to resolve are created.

## Getting strated with SymbolResolver

> [!NOTE]
> In the following documentation I'll use the [Moose Python Importer](https://github.com/moosetechnology/MoosePy) to give examples of usage of SymbolResolver

The first step to get started is to make the visitor use the trait `SRTSolverUserVisitor`:

```st
FamixPythonImporterVisitor << #FamixPythonImporterVisitor
	traits: {SRTSolverUserVisitor};
	slots: { #model . #rootFilePath };
	tag: 'Visitors';
	package: 'Famix-Python-Importer'
```

Then we need to call `#initializeSolver` in the initialization of the visitor:

```st
FamixPythonImporterVisitor>>initialize

	super initialize.
	model := FamixPythonModel named: 'Default Python Model'. "This will be updated later"
	self initialiseSolver 
```

Once this is done, we are be able to build a scope stack during the visit (See [Manage your scopes](#manage-your-scopes)) and we can register symbols to resolve (See section [Register symbols to resolve](#register-symbols-to-resolve)).

Then at the end of the visit you can call `#resolveUnresolvedSymbols` in order to launch the resolution of all registered symbols.

```st
visitor resolveUnresolvedSymbols
```

> [!TIP]
> The symbol resolution comes by default with a safe guard against errors to not make the full symbol resolution fail. For more info check section [Error repport](#error-repport)

## Manage your scopes

One important part of the symbol resolution is to know the scope on the symbol to resolve. In order to manage this, we are saving a stack of the scopes. 

### Understanding the importance of scopes

To make it easier to understand the principles, let's take an example with some Pharo code:

![Scope examples with Pharo](scopes.png)

We can see in this example that we are parsing the method `#myExampleMethod` that is in a protocol `generation`, in a class named `MyExampleClass` in a package named `MyExamplePackage`.

The class has an instance variable named `instanceVar`. The method has a temporary named `temp` and a block with a temporary named `blockTemp`.

Now lets imagine we want to resolve the accesses 1, 2 and 3 on this example. In order to do that, we need to know the context of those accesses because it is possible that we do not have only one variable named `blockTemp` or `temp` or `instanceVar` in our project to parse and we need to find the right ones. This context is the stack on the left. We know that we are in a block, that is in `myExampleMethod` that is in the `generation` protocol, that is in the `MyExampleClass` class, that is en the `MyExamplePackage` package. From this, we have all the informations we need to resolve our 3 variables.

![Scope variables](scopes2.png)

1. Variable `blockTemp`

This variable is easy to resolve since it is defined in the top scope that is the block in which it is currently. We just have to ask the variables of this block and we have our real variable.

2. Variable `temp`

For this one, we start to look for the variables in our top scope: the block. We do not have any variable of this name defined here. So we will go lower in our stack and check the second scope: `#myExampleMethod`. Here we find a temporary variable named `temp`. Our second symbol is resolved.

3. Variable `instanceVar`

As for `temp` we start to look in the variables of the block but none match. We go down in the stack but we don't have any variable of this name in `#myExampleMethod`. Same for the 3rd element of the stack, the `generation` protocol since protocols do not have variables. We then get to the `MyExampleClass` class and here we find an instance variable of the right name. We can end our visit since we found the entity corresponding to our symbol.

### Manage your scopes with the `SymbolResolver`

It is important to build the scopes stack while visiting your AST in order to have a right symbol resolution. For this, `SRTSolverUserVisitor` and `SRSymbolsResolver` provides some API:

- `#currentEntity:` Pushes the parameter as top of the stack in the scopes and consider this entity as the current entity of the resolution
- `#pushEntityAsScope:` Pushes the parameter as top of the stack in the scopes but does not consider it as the current entity of the resolution
- `#currentEntity` Gets the current entity of the resolution (will return the first entity of the stack consider as a current entity)
- `#topScope` Gets the top of the scopes stack
- `#popScope` Pops the top of the scopes stack

Here is an example:

```st
visitClassDefinition: aClassDef

	| class |
	class := self ensureClass: aClassDef.

	self currentEntity: class.

	super visitClassDefinition: aClassDef.
	class methods do: [ :method | method parentType: self currentEntity ].

	self popScope.
	^ class
```

Some suggar is provided to manage most of the cases:
- `#useCurrentEntity:during:` allow to set the current entity for the execution of a block
- `#withCurrentEntityDo:` execute a block taking the current entity as a parameter. In case there is no entity in the scopes, do nothing
- `#currentEntity` gets the first current entity of the scope stack
- `#currentEntityOfType:` gets the first current entity of a given type


Let's rewrite our previous example with this:

```st
visitClassDefinition: aClassDef

	^ self
            useCurrentEntity: (self ensureClass: aClassDef)
            during: [
                super visitClassDefinition: aClassDef.
                self currentEntity methods do: [ :method | method parentType: self currentEntity ] ]
```

Now imagine we want to check if the current entity we have has already a module of a certain name. But it is possible we have no current entity. We can use this piece of code:

```st
ensureModuleNamed: moduleName fromNode: aModuleNode

	self withCurrentEntityDo: [ :entity |
		(entity query descendants ofType: FamixTModule)
			detect: [ :module | module name = moduleName ]
			ifFound: [ :module | ^ module ] ].

	^ self createModule: aModuleNode named: moduleName
```

This should let you build your scopes stack easily. The stack is useful for the symbol resolution but can also be useful during the visit to query the parents of the entities we are building.

## Register symbols to resolve

In order to launch a symbol resolution we need to register it. To do this we first need to instantiate a subclass of `SRResolveable`. The subclass will depend on how the symbol should be resolved. It can be a subclass provided by the project or a subclass implemented by yourself in case the symbol resolution is specific to your project. For more info check the section [Solvers](#solvers).

Then we can use `#resolve:foundAction:` in order to register the resolution:

```st
createImport: anImport ofName: aName from: fromName alias: alias

	| import |
	import := model newImport
		          alias: alias;
		          yourself.

	self setSourceAnchor: import from: anImport.

	self currentEntity addOutgoingImport: import.

	self solver
		resolve: (FamixPythonImportResolvable path: aName)
		foundAction: [ :entity :currentEntity | entity addIncomingImport: import ].

	^ import
```

In this example `FamixPythonImportResolvable path: aName` is the Resolvable.

It is also possible to register in any `SRResolvable` a replacement block. In case an entity is not resolved, it allows one to provide an alternative. For example, a stubed entity.

```st
createImport: anImport ofName: aName from: fromName alias: alias

	| import |
	import := model newImport
		          alias: alias;
		          yourself.

	self setSourceAnchor: import from: anImport.

	self currentEntity addOutgoingImport: import.

	self solver
		resolve: ((FamixPythonImportResolvable path: aName)
				 notFoundReplacementEntity: [ :unresolvedImport :currentEntity | self ensureStubPackagesFromPath: unresolvedImport path ];
				 yourself)
		foundAction: [ :entity :currentEntity | entity addIncomingImport: import ].

	^ import
```

In this version the found action will be executed with a stub package in case we cannot resolve the import.

A last option is to use `#resolve:foundAction:ifNone:` in order to deal with not found entities. It happens sometimes that we want to try to resolve something but it is possible that there is nothing to find and we don't want to generate a stub. For example:

```st
(aMethodNode name beginsWith: 'get_') ifTrue: [
		self
			resolve: ((SRIdentifierResolvable identifier: (aMethodNode name withoutPrefix: 'get_'))
					 expectedKind: FamixPythonAttribute;
					 yourself)
			foundAction: [ :entity :currentEntity | entity beGetter ]
			ifNone: [ "We do nothing" ] ].
```

In this case, we want to check if the method is a getter by checking if we have an instance variable of this name. But if there is no attribute of this name, then we want to do nothing.

### Resolution priority

In some cases, it is possible that we want to ensure that some symbols are resolved before others. For example, in C, we want to resolve the type aliases (typeDef) before resolving the defined types because we can point an alias. 

In that case, it is possible to give a priority to a resolvable. The higher the priority is, the faster it will be resolved. The base priority value is 10.

To resolve something faster you can do:

```st
(aMethodNode name beginsWith: 'get_') ifTrue: [
		self
			resolve: ((SRIdentifierResolvable identifier: (aMethodNode name withoutPrefix: 'get_'))
					 expectedKind: FamixPythonAttribute;
					 priority: 20; "Base priority is 10, so this will be resolved before the other things to resolve"
					 yourself)
			foundAction: [ :entity :currentEntity | entity beGetter ]
			ifNone: [ "We do nothing" ] ].
```

## Solvers 

As said previously, the actual resolution is happening in the subclasses of `SRResolvable`. In this section we will present the existing solvers and how to implement your own.

### Existing solvers 

Currently the project only have two provided solvers: `SRIdentifierResolvable` and `SRLocalClassEntityResolvable`.

#### SRIdentifierResovable

The goal of this resolvable is to provide a name and the kind of entity it can be, and the resovable will look if the element at the top of the stack has a child of this kind and name. Else, it will go to the next scope.

> [!Note] 
> In order for this solver to work, we need some integration with the model been used with the symbol resolver. A simple one is provided by default with Moose.
> See section [Model integration](#model-integration).

Let's check how to use this solver with a simple case: let's resolve a simple inheretance in Python. I have an `IdentifierNode` that just represent the name of the class I inherit from. I can do:

```st
FamixPythonImporterVisitor>>manageInheritanceDeclaredBy: superclassNode

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

#### SRLocalClassEntityResolvable

The goal of this resolvable is to find local entities in a class. 

Typically, I'll be used to find methods or attributes invoked or accessed via a `this` or `self`. 

For example in Python:

```python
class AClass:
	def method(self):
		return 1
		
	def method2(self):
		return self.method() + 1
```

The `self.method()` invoke a local method to the AClass class. 

I can be used like this:

```st
receiver = 'self' ifTrue: [
	^ self
		resolve: (SRLocalClassEntityResolvable identifier: aName expectedKind: FamixTMethod)
		foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ] ].
```

If in your language you don't know if the entity is a method or an attribute, you can provide a collection for the kinds like this:

```st
	self
		resolve: (SRLocalClassEntityResolvable identifier: aName expectedKind: {FamixTMethod. FamixTAttribute})
		foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ]
```

You can also create a stub entity in case the method comes from a stub superclass:

```st
	self
		resolve: 
			((SRLocalClassEntityResolvable identifier: aName expectedKind: FamixTMethod)
				notFoundReplacementEntity: [ :unresolved | self ensureStubMethodNamed: unresolved identifier ];
				yourself)
		foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ]
```

In the future, we might add other generic resolvable.

### Add you own solver

It is highly possible that for some cases it is required to implement a solver that is not yet present in SymbolResolver. For example, depending on the language, the import system might differ and you need one with specificities.

In that case, you will need to subclass `SRResovable`. Let's illustrate this with two simple cases in the python importer. 

Case 1: Resolution of local method invocation

> [!Note]
> This solver we will explain is now the `SRLocalClassEntityResolvable` but this documentation was written when it was not yet in the SymbolResolver, but it was a class of the PythonImporter. But at least we will explore its implementation

Imagine we have this code:

```python
class AClass:
	def __init__(self, a):
		self.a = a

	def method_to_invoke(self):
		return self.a + 3

	def method_calling_other_method(self):
		return self.method_to_invoke() + 4
```

We want to resolve `self.method_to_invoke()`. We know this is a a local method call. In that case I'll create a resolvable for this:

```st
SRResolvable << #FamixPythonLocalClassEntityResolvable
	slots: { #identifier };
	tag: 'Resolvables';
	package: 'Famix-Python-Importer'
```

When we create a resolvable, we need to override the method `identifier` that is used to print the symbol to resolve when we inspect the resovable. In our case, it will just be an accessor:

```st
identifier
	^ identifier
```

Now we can use our resolvable like this:

```st
receiver = 'self' ifTrue: [
	^ self
		resolve:
			(FamixPythonLocalClassEntityResolvable new
				identifier: aName;
				expectedKind: FamixTMethod;
				notFoundReplacementEntity: [ :unresolved | self ensureStubMethodNamed: unresolved identifier ];
				yourself)
		foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ] ].
```

> [!Note]
> All resolvable can be configured with expected kinds using `#expectedKind:` or `#expectedKinds:`. You need to be careful to use them if necessary in your resolution.

Now the last step is to implement the resolution in itself by overriding `SRResolvable>>#resolveInScope:currentEntity:`. 

The actual resolution should be implemented in the method `MyResolvable>>#resolveInScope:currentEntity:`. This method takes the current scope and the current entity as a parameter. 
The method will be called first in the top scope. In case the entity is not found, you should throw a `NotFound` error. In that case, the solver will catch this error and try in the next scope until there is no scope left to look into. If that's happening, then the replacement strategy will be triggered. 
In some cases it is also possible that we know that an entity will not be found in any scope left to search. In that case, it is possible to raise a `SRNoResolutionPossible` error instead of a `NotFound`. This will stop the resolution right away and delegate the resolution to the replacement strategy. This is an optimization.
Last thing to know is that we need to use the method `result:` to set a result we find during the resolution.

In this case the implementation looks like this:

```st
resolveInScope: aScope currentEntity: currentEntity

	"We just need to check the methods of the class. If it's not a class, skip to the next scope"
	aScope entity isClass ifFalse: [ NotFound signal ].

	(aScope reachableEntitiesNamed: identifier ofKinds: self expectedKinds) ifNotEmpty: [ :entities |
		"I don't think we can have multiple results here."
		self assert: entities size = 1.
		^ self result: entities anyOne ]. "We save the result we found here"

	"If I did not find anything in the first class I found, cut the resolution.
	SRNoResolutionPossible signal
```

Case 2: Resolution of imported entities in Python

Imagine this code:

```python
	import moduleAtRoot

	print(moduleAtRoot.moduleAtRootVariable)
```

We will implement a solver to find imported entities like this. 

We begin by creating the class:

```st
SRResolvable << #FamixPythonImportedEntityResolvable
	slots: { #import . #identifier };
	tag: 'SymbolResolution';
	package: 'Famix-Python-Importer'
```

We generate the accessors for the two instance variables and then we can implement the resolution like this:

```st
resolveInScope: aScope currentEntity: currentEntity

	"If the name is directly the imported entity, we save it as the result."
	import importedEntity name = identifier ifTrue: [ ^ self result: import importedEntity ].

	"else we check the entities inside the imported entity"
	^ (import importedEntity definedEntitiesNamed: identifier ofKinds: self expectedKinds)
		  ifEmpty: [ SRNoResolutionPossible signal ]
		  ifNotEmpty: [ :entities | self result: entities anyOne ]
```

Now we can use this on like this:

```st
manageImportedInheritanceDeclaredBy: anAttributeNode

	| inheritance importName className |
	inheritance := self createInheritanceFrom: anAttributeNode.
	importName := self visit: anAttributeNode _receiver.
	className := self visit: anAttributeNode _value.

	self findImportMatchingSource: importName ifFound: [ :import |
			self
				resolve: ((FamixPythonImportedEntityResolvable identifier: className import: import)
						 expectedKind: FamixPythonClass;
						 notFoundReplacementEntity: [ :unresolved :currentEntity |
								 (self ensureStubClassNamed: unresolved identifier)
									 typeContainer: (self ensureStubPackagesFromPath: unresolved import);
									 yourself ];
						 yourself)
				foundAction: [ :entity :currentEntity | inheritance superclass: entity ].
			^ inheritance ].

	inheritance superclass: ((self ensureStubClassNamed: className)
			 typeContainer: (self ensureStubPackagesFromPath: importName);
			 yourself)
```

This concludes the documentation on resolvables implementation.

## Model integration

The symbol resolver should be able to work with multiple kind of models even if it currently only includes a Moose integration.

Some solvers are provided but they cannot know how to get the informations needed from the model you're using. This part needs a little bridge to work.

Here are a few methods we need for the current solvers to work:
- `#reachableEntities` : This methods should return all possible children of the entity. This should not be recursive! The recursion will be managed by visiting the different scopes of the resolution. Like this we can find the most precise entity
- `#reachableEntitiesNamed:ofKinds:` : This methods should return the possible direct children of the entity of a certain type that matches the name provided

With those two methods, all the solvers present in SymbolResolver should work. But maybe you will need more for you own solvers.

### Moose integration

This section will go over the Moose integration done in SymbolResolver and how to specialize it for your language.

The Moose integration of SymbolResolver is currently loaded by default. If you do not need it, you'll need to load a specific group.

Ideally, we should implement the methods to get the reacheable entities on `TEntityMEtaLevelDependency`. But doing this, it would be hard to specialize this Moose integration to add some specificities of your own language. So the methods got added on `MooseEntity`. Like this, each languages can specialize them in their `FamixXXXEntity` class. This mecanism also allows to have multiple importers using `SymbolResolver` without clashing with each other.

Also, those methods were thought to have hooks in order to easily specialize them for the language you are managing.

For example:

```st
reachableEntitiesNamed: aString ofKinds: aCollection
	"I will return the entities I I can reach with a certain name and a certain type.  I will check my children. Be careful, this is only for one level. I do not check my children recusively because this should be managed by the scope lookup. If you miss entities, you probably miss a scope.
		
	By default it is the entities I define, but this can depend on the language. Override me if it is the case."

	"Ideally this method should be on TEntityMetaLevelDependency. But we want people to be able to override it to add specificities for their language, for example import management."

	^ self definedEntitiesNamed: aString ofKinds: aCollection
```

In this method, we return the result of `definedEntitiesNamed:ofKinds:` because if your language has imports or inclusion of entities, maybe you'll need to override it in order to access the defined entities of the imported entity. In that case, this decomposition can be useful.

Some example of customization will be provided in the next subsections about imports or aliases.

I also provide a little helper: `MooseEntity>>#childOfType:named:`. This returns for an entity a direct child of the type and name provided. I added it here because I often used this in the development of importers and this can probably help you too.

#### Import management

Imports can work differently in each language, so it is not possible to offer one generic way to manage them. But here is an example of how imports can be managed for Python in the symbol resolution!

In order to do this, we will override some methods in `FamixPythonEntity` to make them more specific.

First, I'll need to distinguish entities that can have imports from those that cannot. I'll do it like this:

```st
FamixPythonEntity>>#canHaveImports

	^ false
```

```st
FamixTWithImports>>#canHaveImports

	^ true
```

And now I can manage the imports and the aliases in the python lookup:

```st
FamixPythonEntity>>#reachableEntitiesNamed: aString ofKinds: aCollection

	| entities |
	entities := Set new.

	self canHaveImports ifTrue: [
			"If we can have imports, we should check if we can reach an entity of the right name and kind in those imports."
			
			self imports do: [ :import |
					"It is possible for the imported entity to be nil in case it was not yet resolved. Imagine you reference something and later in the file there is an import. We resolve things in the order they appear, so the import might not yet be resolved. But in that case we can just ignore it because we cannot use something we did not import yet."
					import importedEntity ifNotNil: [ :entity |
							"In case the import has an alias matching, we add the imported entity, else we add the matching children of the imported entity."
							import alias = aString
								ifTrue: [ entities add: import importedEntity ]
								ifFalse: [ entities addAll: (entity definedEntitiesNamed: aString ofKinds: aCollection) ] ] ] ].

	entities addAll: (super reachableEntitiesNamed: aString ofKinds: aCollection).

	^ entities
```

#### Aliases management 

The management of aliases will depend on how the aliases are working in your language. Let's see it in this section. 

In the Moose integration, we have methods looking for entities with a specific name. In the code directly present in the Symbol Resolver, the comparison of the name of the entities and the name provided by the user is done in `FamixTNamedEntity>>#matchesName:`. With this, it is possible to redefine it on some entities. For exemple:

```st
FamixEntityHoldingAliases>>matchesName: aString
	self name = aString ifTrue: [ ^true ].

	^ self aliases includes: aString

```

Like this, all aliases will be taken into consideration.

Or if the entity does not hold the aliases itself but the alias is an association between the entity creating the alias and the entity been aliased:

```st
FamixEntityThatCanBeAliased>>matchesName: aString
	self name = aString ifTrue: [ ^true ].

	^ self aliases source aliasedName = aString

```

Those are just examples of how it can be done. The specifics will change for each languages.

## Error repport

In the development of a parser it is common to have edge cases that are hard to handle and to have crashes. This project provides a little utility to help handling such cases.

`SRParsingReport` is instanciated by the `SRSymbolsSolver` in the `errorReport` instance variable during its initialization. It can be used to add a safeguard during the execution of some code to catch errors or warnings without interruptiong the parsing.

For example it can be used during the visit of an AST with a visitor using `SRTSolverUserVisitor` like this:

```st
acceptNode: aNode

	^ self errorReport catch: Error during: [ super acceptNode: aNode ]
```

Or

```st
visit: aNode
	
	^ self errorReport catch: Error during: [ aNode acceptVisitor: self ]
```

This error report is also used during the symbol resolution directly in the method `SRSymbolsSolver>>#resolveUnresolvedSymbols`.

At the end of the pasring, we can inspect this error report to find the errors that happened during the parsing.

API:
- `SRParsingReport>>#catch:during:` allow to catch some errors or error set during the execution of a block
- `SRParsingReport>>#catch:during:isWarningIf:` same as above but wiht a way to configure what should be considered as a warning
- `SRParsingReport>>#catchWarningsDuring:` allow to catch and proceed on warnings during the execution of a block, but still raises errors

> [!TIP]
> While developping a parser it might be interesting to have an actual debugger instead of catching all the errors. It is possible to go in development mode via the world menu: `Debug > Toggle Symbol Resolver Debug mode`

## Advance cases

### Concept of Main Entity

In some languages, scopes can be managed in a weird way that do not match the way most languages are doing. For example, in SQL it can happen that some scope are not resolved in order during the resolution. 

I order to help with such cases, some concepts were added in the tooling such as the concept of "main entities".

On top of defining an entity as the "current entity", you can also mark some as a "main entity" and get the first main entity from the stack.

```st

	self useMainEntity: aClass during: [
		"some code"
		self solver mainEntity addChild: anEntity ]

```

### Use the result of a symbol resolution as a scope for another resolution

Another utility to help with some weird resolution cases is the ability to push a resolvable as a scope, and this scope will be based on the result of this resolution.

In order to do this you can use:
- `SRSymbolsSolver>>#pushResolvableAsScopeBeforeCurrentScope:foundAction:`
- `SRSymbolsSolver>>#pushResolvableAsScopeBeforeMainEntityScope:foundAction:`

So what will happen is that:
- We register the resolvable with its found action
- We push it in the scope before the current entity or before the main entity
- We resolve this first resolvable
- We resolve the next resolvables, and if we need to access this scope, we return the result we found during the previous step and the entity of the scope

### Reacheable entities as scope

Another utility provided is the ability to not add an entity in the scope, but directly give a collection of entities that can be reached.

For example:

```st
visitClassDefinition: aNode
	| class |
	class := self ensureClass: aNode.
	
	self useCurrentEntity: class during: [
		| attributes |
		attributes := self getAttributes from: aNode attributes.
		self pushEntitiesAsScope: attributes.
		self visit: aNode methods
	]
```

Then

```st
visitMethodDefinition: aNode
	| method |
	method := self ensureMethod: aNode.

	(method name beginsWith: 'get_') ifTrue: [
			self
				resolve: ((SRIdentifierResolvable identifier: (method name withoutPrefix: 'get_'))
						 expectedKind: FamixPythonAttribute;
						 yourself)
				foundAction: [ :entity :currentEntity | method beGetter ]
				ifNone: [ "We do nothing" ] ].
```

Here the first scope the solver will go over is the collection of attributes we pushed as scope.

### Tree Sitter Famix Integration

This project is part of the Famix integration with TreeSitter to write importers faster. The documentation can be found there: [Documenation](https://github.com/moosetechnology/TreeSitterFamixIntegration/blob/main/resources/docs/UserDocumentation.md)