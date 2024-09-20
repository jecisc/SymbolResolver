"
I am a scope that need a resolution, typically an import. Once the resolution is done, i am like a regular entity scope.
"
Class {
	#name : 'SRResolvableEntityScope',
	#superclass : 'SREntityScope',
	#instVars : [
		'resolvable'
	],
	#category : 'SymbolResolver-Scopes',
	#package : 'SymbolResolver',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
SRResolvableEntityScope class >> resolvable: aSRResolvable [
	^ self new
		resolvable: aSRResolvable;
		yourself
]

{ #category : 'as yet unclassified' }
SRResolvableEntityScope >> entity [
	self assert:  self resolvable entity notNil description: 'We should always have resolved it before needing it'.
	^ self resolvable entity
]

{ #category : 'resolvable API' }
SRResolvableEntityScope >> foundAction: aBlockClosure [ 
	self resolvable foundAction: aBlockClosure
]

{ #category : 'testing' }
SRResolvableEntityScope >> isResolved [
	^  self resolvable entity isNotNil 
]

{ #category : 'resolvable API' }
SRResolvableEntityScope >> notFoundReplacementEntity: aBlockClosure [ 
	self resolvable notFoundReplacementEntity: aBlockClosure 
]

{ #category : 'accessing' }
SRResolvableEntityScope >> resolvable [
	^ resolvable
]

{ #category : 'accessing' }
SRResolvableEntityScope >> resolvable: anObject [
	resolvable := anObject
]
