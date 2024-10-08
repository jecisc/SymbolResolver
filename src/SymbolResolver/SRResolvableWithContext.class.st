"
I represent a reference that will be resolved in the future. I contain everything required for that (scopes, identifiers, actions).

"
Class {
	#name : 'SRResolvableWithContext',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'resolvable',
		'foundAction'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'instance creation' }
SRResolvableWithContext class >> newFromScopes: aCollectionOfScopes identifiers: aResolvable foundAction: aBlockClosure [
	^ self new
		scopes: aCollectionOfScopes;
		resolvable: aResolvable;
		foundAction: aBlockClosure;
		yourself
]

{ #category : 'accessing' }
SRResolvableWithContext >> currentEntity [
	^ (self scopes
		detect: #hasCurrentEntity
		ifNone: [ SRNoCurrentEntityAvailable signalReferencesResolver: self ])
		currentEntity
]

{ #category : 'accessing' }
SRResolvableWithContext >> foundAction [
	^ foundAction
]

{ #category : 'accessing' }
SRResolvableWithContext >> foundAction: anObject [
	foundAction := anObject
]

{ #category : 'printing' }
SRResolvableWithContext >> printOn: aStream [
	super printOn: aStream.

	aStream
		nextPutAll: ' (';
		print: resolvable;
		nextPut: $)
]

{ #category : 'accessing' }
SRResolvableWithContext >> resolvable [
	^ resolvable
]

{ #category : 'accessing' }
SRResolvableWithContext >> resolvable: anObject [
	resolvable := anObject
]

{ #category : 'resolution' }
SRResolvableWithContext >> resolve [
	"first we try to resolve the resolvable in each scope"
	self tryToResolveInScopes.
	self resolvable isResolved ifFalse: [ self tryToApplyReplacementStrategy ].
	self triggerFoundActionWithCurrentEntity.
]

{ #category : 'accessing' }
SRResolvableWithContext >> resolve: aResolvable inScope: aScope [
	^ aResolvable resolveInScope: aScope currentEntity: self currentEntity 
]

{ #category : 'accessing' }
SRResolvableWithContext >> scopes [
	^ scopes
]

{ #category : 'accessing' }
SRResolvableWithContext >> scopes: anObject [
	"Scopes are poped and pushed during the visit but the mechanism ensure that you can point a collection of scopes because a copy is done each time. This way its limitate the memory usage"
	scopes := anObject
]

{ #category : 'resolution' }
SRResolvableWithContext >> triggerFoundActionWithCurrentEntity [
	self assert: self foundAction notNil description: 'Found action must be set (otherwise no interest to resolve stuff)'.
	self foundAction cull: self resolvable entity cull: self currentEntity
]

{ #category : 'resolution' }
SRResolvableWithContext >> tryToApplyReplacementStrategy [
	self resolvable hasReplacementStrategy
		ifTrue: [ self resolvable  applyReplacementStrategyWithCurrentEntity: self currentEntity.
			self assert: self resolvable isResolved description: 'We should always have a resolved element at this time, even if this entity is a stub' ]
		ifFalse: [ SRReferencesNotFound signalIdentifiers: self resolvable ]
]

{ #category : 'resolution' }
SRResolvableWithContext >> tryToResolveInScopes [
	self scopes
		do: [ :aScope | 
			[ ^ self resolve: self resolvable inScope: aScope ]
				on: NotFound
				do: [ "do nothing to try superior scope" ] ].

]
