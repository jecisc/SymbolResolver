"
I am a resolvable only identified by an identifier (like an instance variable or a property)
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

	(self repondsTo: #deprecatedAliases:) ifTrue: [ self deprecatedAliases: { #SRIdentifierWithNode } ]
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
