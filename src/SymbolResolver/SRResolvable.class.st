"
I am a resolvable thing, i have an identifier and the solver will try to resolve me to fill the real entity (or candidates if multiple are possible).
"
Class {
	#name : 'SRResolvable',
	#superclass : 'Object',
	#instVars : [
		'node',
		'expectedKind',
		'notFoundReplacementEntity'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'instance creation' }
SRResolvable class >> identifier: anIdentifier expectedKind: aKind node: aNode [ 
	^ (self identifier: anIdentifier node: aNode)
		expectedKind: aKind;
		yourself
]

{ #category : 'instance creation' }
SRResolvable class >> identifier: aString expectedKind: aClass node: aPGTASTIdentifier notFoundReplacementEntity: aBlockClosure [ 
	^ (self identifier: aString expectedKind: aClass node: aPGTASTIdentifier) notFoundReplacementEntity: aBlockClosure ; yourself
]

{ #category : 'instance creation' }
SRResolvable class >> identifier: aStringIdentifier node: aPSQLASTIdentifier [
	^ self new
		identifier: aStringIdentifier;
		node: aPSQLASTIdentifier;
		yourself
]

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
SRResolvable >> node [
	^ node
]

{ #category : 'accessing' }
SRResolvable >> node: anObject [
	node := anObject
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
