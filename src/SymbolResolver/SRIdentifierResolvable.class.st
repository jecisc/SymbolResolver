"
I am a resolvable only identified by an identifier (like an instance variable or a property).

Let's check how to use this solver with a simple case: let's resolve a simple inheretance in Python. I have an `IdentifierNode` that just represent the name of the class I inherit from. I can do:

```st
FamixPythonImporterVisitor>>manageInheritanceDeclaredBy: superclassNode

	| inheritance |
	""The next line will create a FamixPythonInheritance with its source anchor and the subclass already set""
	inheritance := self createInheritanceFrom: superclassNode.

	self
		resolve: ((SRIdentifierResolvable identifier: superclassNode sourceText) ""This gives the name of the superclass""
				 expectedKind: FamixPythonClass; ""Here I difine that the entity I can find should be a class""
				 notFoundReplacementEntity: [ :unresolvedSuperclass :currentEntity | self ensureStubClassNamed: unresolvedSuperclass identifier ]; ""If I don't find the entity, I create a stub""
				 yourself)
		foundAction: [ :entity :currentEntity | inheritance superclass: entity ] ""And now that I have the entity, stub or not, I can set the superclass in my association""
``````
"
Class {
	#name : 'SRIdentifierResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRIdentifierResolvable class >> identifier: anIdentifierString [
	^ self new
		identifier: anIdentifierString;
		yourself
]

{ #category : 'class initialization' }
SRIdentifierResolvable class >> initialize [
	"Guard for old pharo version"

	(self respondsTo: #deprecatedAliases:) ifTrue: [ self deprecatedAliases: { #SRIdentifierWithNode } ]
]

{ #category : 'accessing' }
SRIdentifierResolvable >> identifier [
	^ identifier
]

{ #category : 'accessing' }
SRIdentifierResolvable >> identifier: anObject [
	identifier := anObject
]

{ #category : 'resolution' }
SRIdentifierResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	self result: ((aScope reachableEntitiesNamed: self identifier ofKinds: self expectedKinds) ifEmpty: [ NotFound signal ] ifNotEmpty: #anyOne)
]
