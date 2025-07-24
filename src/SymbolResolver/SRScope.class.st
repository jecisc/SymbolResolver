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

{ #category : 'iterator' }
SRScope >> detect: aBlockClosure [ 
	^ self reachableEntities detect: aBlockClosure
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

	^ self subclassResponsibility
]

{ #category : 'iterator' }
SRScope >> select: aBlockClosure [
	^ self reachableEntities select: aBlockClosure
]
