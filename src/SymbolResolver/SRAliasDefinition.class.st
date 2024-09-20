Class {
	#name : 'SRAliasDefinition',
	#superclass : 'Object',
	#instVars : [
		'alias',
		'entity'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRAliasDefinition >> alias [
	^ alias
]

{ #category : 'accessing' }
SRAliasDefinition >> alias: anObject [
	alias := anObject
]

{ #category : 'accessing' }
SRAliasDefinition >> entity [
	^ entity
]

{ #category : 'accessing' }
SRAliasDefinition >> entity: anObject [
	entity := anObject
]

{ #category : 'accessing' }
SRAliasDefinition >> name [
	^ self alias
]

{ #category : 'accessing' }
SRAliasDefinition >> reachableEntities [
	^ self entity reachableEntities 
]

{ #category : 'evaluating' }
SRAliasDefinition >> value [
	^ self entity
]
