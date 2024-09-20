Class {
	#name : 'SRThisWithNode',
	#superclass : 'SRResolvable',
	#instVars : [
		'entity',
		'validationAsTypeBlock'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRThisWithNode class >> node: aNode [
	^ self new node: aNode
]

{ #category : 'accessing' }
SRThisWithNode class >> node: aNode validationAsTypeBlock: validationAsTypeBlock [
	^ self new
		node: aNode;
		validationAsTypeBlock: validationAsTypeBlock;
		yourself
]

{ #category : 'accessing' }
SRThisWithNode >> entity [
	^ entity
]

{ #category : 'accessing' }
SRThisWithNode >> entity: anObject [
	entity := anObject
]

{ #category : 'resolution' }
SRThisWithNode >> resolveInScope: aSRScope currentEntity: currentEntity [
	(aSRScope isEntityScope and: [ self validateAsType: aSRScope entity ])
		ifFalse: [ NotFound signal ]
		ifTrue: [ self entity: aSRScope entity. ]
]

{ #category : 'validation' }
SRThisWithNode >> validateAsType: aFamixEntity [
	^ self validationAsTypeBlock value: aFamixEntity
]

{ #category : 'accessing' }
SRThisWithNode >> validationAsTypeBlock [
	^ validationAsTypeBlock
]

{ #category : 'accessing' }
SRThisWithNode >> validationAsTypeBlock: anObject [
	validationAsTypeBlock := anObject
]
