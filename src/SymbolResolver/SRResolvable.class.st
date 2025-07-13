"
I am a resolvable thing, i have an identifier and the solver will try to resolve me to fill the real entity (or candidates if multiple are possible).
"
Class {
	#name : 'SRResolvable',
	#superclass : 'Object',
	#instVars : [
		'expectedKind',
		'notFoundReplacementEntity'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'hooks' }
SRResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	self subclassResponsibility 
]

{ #category : 'accessing' }
SRResolvable >> entity [
	^ self subclassResponsibility  
]

{ #category : 'accessing' }
SRResolvable >> expectedKind [
	^ expectedKind
]

{ #category : 'accessing' }
SRResolvable >> expectedKind: anObject [
	expectedKind := anObject
]

{ #category : 'accessing' }
SRResolvable >> expectedKinds [
	^ self expectedKind isCollection
		ifTrue: [ self expectedKind ]
		ifFalse: [ {self expectedKind} ]
]

{ #category : 'accessing' }
SRResolvable >> expectedKinds: anObject [
	expectedKind := anObject
]

{ #category : 'testing' }
SRResolvable >> hasReplacementStrategy [
	^ self notFoundReplacementEntity isNotNil
]

{ #category : 'accessing' }
SRResolvable >> identifier [
	^ self subclassResponsibility
]

{ #category : 'testing' }
SRResolvable >> isResolvable [
	^ true
]

{ #category : 'testing' }
SRResolvable >> isResolved [
	^ self entity notNil
]

{ #category : 'accessing' }
SRResolvable >> notFoundReplacementEntity [
	^ notFoundReplacementEntity
]

{ #category : 'accessing' }
SRResolvable >> notFoundReplacementEntity: anObject [
	notFoundReplacementEntity := anObject
]

{ #category : 'printing' }
SRResolvable >> printIdentifierPath: aStream [
	aStream nextPutAll: self identifier
]

{ #category : 'printing' }
SRResolvable >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	self printIdentifierPath: aStream.
	aStream nextPut: $)
]

{ #category : 'printing' }
SRResolvable >> representationString [
	^ String streamContents: [ :s | self printIdentifierPath: s ]
]

{ #category : 'resolution' }
SRResolvable >> resolveInScope: aScope currentEntity: currentEntity [ 
	^ self subclassResponsibility  
]

{ #category : 'accessing' }
SRResolvable >> targetEntity [
	^ self isLast
		ifFalse: [ self next targetEntity ]
		ifTrue: [ self entity ]
]
