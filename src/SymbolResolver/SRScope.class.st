Class {
	#name : 'SRScope',
	#superclass : 'Object',
	#instVars : [
		'aliases'
	],
	#category : 'SymbolResolver-Scopes',
	#package : 'SymbolResolver',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
SRScope >> aliases [
	^ aliases ifNil: [ aliases := OrderedCollection new ]
]

{ #category : 'accessing' }
SRScope >> aliases: anObject [
	aliases := anObject
]

{ #category : 'testing' }
SRScope >> canContainsEntitiesOfType: aClass [ 
	^ true
]

{ #category : 'helpers' }
SRScope >> createReferenceEntityFrom: aFmxEntity [ 
	"I am a convenient function that do nothing because an identifier pointed this scope (because of an aliasing)"
]

{ #category : 'iterator' }
SRScope >> detect: aBlockClosure [ 
	^ self reachableEntitiesOwned detect: aBlockClosure
]

{ #category : 'accessing' }
SRScope >> hasAliases [
	^ aliases isNotNil and: [ aliases isNotEmpty ]
]

{ #category : 'testing' }
SRScope >> hasCurrentEntity [
	^ false
]

{ #category : 'testing' }
SRScope >> isEntityScope [
	^ false
]

{ #category : 'accessing' }
SRScope >> reachableEntities [
	^ self hasAliases
		ifTrue: [ self aliases , self reachableEntitiesOwned ]
		ifFalse: [ self reachableEntitiesOwned ]
]

{ #category : 'accessing' }
SRScope >> reachableEntitiesOwned [
	^ self subclassResponsibility 
]

{ #category : 'iterator' }
SRScope >> select: aBlockClosure [
	^ self reachableEntitiesOwned select: aBlockClosure
]
