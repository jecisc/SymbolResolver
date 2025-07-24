"
I represent a reference that will be resolved in the future. I contain everything required for that (scopes, identifiers, actions).

"
Class {
	#name : 'SRResolvableWithContext',
	#superclass : 'Object',
	#instVars : [
		'scopes',
		'resolvable',
		'foundAction',
		'notFoundAction'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'instance creation' }
SRResolvableWithContext class >> newFromScopes: aCollectionOfScopes resolvable: aResolvable foundAction: aBlockClosure ifNone: anotherBlock [

	^ self new
		  scopes: aCollectionOfScopes;
		  resolvable: aResolvable;
		  foundAction: aBlockClosure;
		  notFoundAction: anotherBlock yourself
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

{ #category : 'testing' }
SRResolvableWithContext >> hasNotFoundAction [

	^ notFoundAction isNotNil
]

{ #category : 'accessing' }
SRResolvableWithContext >> notFoundAction [

	^ notFoundAction
]

{ #category : 'accessing' }
SRResolvableWithContext >> notFoundAction: anObject [

	notFoundAction := anObject
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

	"If we did not find the entity then we try the replacement strategy to have another entity. 
	In case we still do not find anything we either execute the not found action or let the not found error pass to the user."
	[ self resolvable isResolved ifFalse: [ self tryToApplyReplacementStrategy ] ]
		on: SRReferenceNotFound
		do: [ :notFound |
			^ self hasNotFoundAction
				  ifTrue: [ self notFoundAction cull: self resolvable cull: self currentEntity ]
				  ifFalse: [ notFound pass ] ].

	self triggerFoundActionWithCurrentEntity
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
	self foundAction cull: self resolvable result cull: self currentEntity
]

{ #category : 'resolution' }
SRResolvableWithContext >> tryToApplyReplacementStrategy [

	self resolvable hasReplacementStrategy
		ifTrue: [
			self resolvable applyReplacementStrategyWithCurrentEntity: self currentEntity.
			self assert: self resolvable isResolved description: 'We should always have a resolved element at this time, even if this entity is a stub' ]
		ifFalse: [ SRReferenceNotFound signal: self resolvable ]
]

{ #category : 'resolution' }
SRResolvableWithContext >> tryToResolveInScopes [

	[
	self scopes do: [ :aScope |
		[ ^ self resolve: self resolvable inScope: aScope ]
			on: NotFound
			do: [ "do nothing to try superior scope" ] ] ]
		on: SRNoResolutionPossible
		do: [ "Do nothing and do not check the superior scopes because we know that the symbol cannot be resolved" ]
]
