"
I am a resolvable only identified by an identifier (like an instance variable or a property)
"
Class {
	#name : 'SRIdentifierWithNode',
	#superclass : 'SRResolvable',
	#instVars : [
		'entity',
		'identifier'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRIdentifierWithNode class >> identifier: anIdentifierString [
	^ self new
		identifier: anIdentifierString;
		yourself
]

{ #category : 'hooks' }
SRIdentifierWithNode >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	self
		entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
SRIdentifierWithNode >> entity [
	^ entity
]

{ #category : 'accessing' }
SRIdentifierWithNode >> entity: anObject [
	entity := anObject
]

{ #category : 'accessing' }
SRIdentifierWithNode >> identifier [
	^ identifier
]

{ #category : 'accessing' }
SRIdentifierWithNode >> identifier: anObject [
	identifier := anObject
]

{ #category : 'resolution' }
SRIdentifierWithNode >> resolveInScope: aScope currentEntity: currentEntity [
	self entity: ((aScope reachableEntitiesNamed: self identifier ofKinds: self expectedKinds) ifEmpty: [ NotFound signal ] ifNotEmpty: #anyOne)
]
