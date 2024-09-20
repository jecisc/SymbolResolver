"
I am a resolvable that is invoked (a function call, a message sent...). I have arguments that will be used to be resolved
"
Class {
	#name : 'SRInvocationWithNode',
	#superclass : 'SRResolvable',
	#instVars : [
		'arguments',
		'candidates'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'instance creation' }
SRInvocationWithNode class >> identifier: anIdentifier node: aNode expectedKind: aKind arguments: aCollectionOfArguments [
	^ (self identifier: anIdentifier node: aNode)
		expectedKind: aKind;
		arguments: aCollectionOfArguments;
		yourself
]

{ #category : 'hooks' }
SRInvocationWithNode >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	self
		candidates: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
SRInvocationWithNode >> arguments [
	^ arguments
]

{ #category : 'accessing' }
SRInvocationWithNode >> arguments: anObject [
	arguments := anObject
]

{ #category : 'accessing' }
SRInvocationWithNode >> candidates [
	^ candidates
]

{ #category : 'accessing' }
SRInvocationWithNode >> candidates: anObject [
	candidates := anObject
]

{ #category : 'accessing' }
SRInvocationWithNode >> entity [
	^ self candidates size = 1
		ifTrue: [ self candidates anyOne ]
		ifFalse: [ NotFound signal ]
]

{ #category : 'resolution' }
SRInvocationWithNode >> resolveInScope: aScope currentEntity: currentEntity [
	(self expectedKinds anySatisfy: [ :expectedPossibility | aScope canContainsEntitiesOfType: expectedPossibility ]) ifFalse: [ NotFound signal ].

	^ (aScope reachableEntitiesNamed: self identifier ofKinds: self expectedKinds)
		ifEmpty: [ NotFound signal ]
		ifNotEmpty: [ :entities | self candidates: entities ]
]
