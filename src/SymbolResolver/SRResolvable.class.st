"
I am a resolvable thing, i have an identifier and the solver will try to resolve me to fill the real entity (or candidates if multiple are possible).

Optionaly I can have a priority in case some resolvables need to be resolved before others. 
For example, in C you need to resolve the aliases (typedef) before resolving the declared types. In that case, we can set a higher priority to the alias.
"
Class {
	#name : 'SRResolvable',
	#superclass : 'Object',
	#instVars : [
		'expectedKind',
		'notFoundReplacementEntity',
		'priority',
		'result'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'hooks' }
SRResolvable >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [

	self result: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
SRResolvable >> entity [

	self deprecated: 'Use #result instead' transformWith: '`@rcv entity' -> '`@rcv result'.
	^ self result
]

{ #category : 'accessing' }
SRResolvable >> entity: arg [

	self deprecated: 'Use #result: instead' transformWith: '`@rcv entity: `@arg' -> '`@rcv result: `@arg'.
	^ self result: arg
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

{ #category : 'initialization' }
SRResolvable >> initialize [

	super initialize.
	priority := 10
]

{ #category : 'testing' }
SRResolvable >> isResolvable [
	^ true
]

{ #category : 'testing' }
SRResolvable >> isResolved [

	^ self result isNotNil
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

{ #category : 'accessing' }
SRResolvable >> priority [

	^ priority
]

{ #category : 'accessing' }
SRResolvable >> priority: anObject [

	priority := anObject
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
SRResolvable >> result [

	^ result
]

{ #category : 'accessing' }
SRResolvable >> result: anObject [

	result := anObject
]

{ #category : 'accessing' }
SRResolvable >> targetEntity [
	^ self isLast
		ifFalse: [ self next targetEntity ]
		ifTrue: [ self entity ]
]
