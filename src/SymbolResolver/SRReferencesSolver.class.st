"
I am a class that can solve referencies and is able to give you the current entity for your visit
"
Class {
	#name : 'SRReferencesSolver',
	#superclass : 'Object',
	#instVars : [
		'scopes'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'scopes management' }
SRReferencesSolver >> copyScopes [
	^ scopes := scopes copy
]

{ #category : 'manager' }
SRReferencesSolver >> createScopeManager [
	^ SRScopeManager newAssociatedToSolver: self
]

{ #category : 'accessing' }
SRReferencesSolver >> currentEntity [
	^ (self scopes
		detect: #hasCurrentEntity
		ifNone: [ SRNoCurrentEntityAvailable signalReferencesResolver: self ]) currentEntity
]

{ #category : 'accessing' }
SRReferencesSolver >> currentEntityOfType: anEntityType [
	^ (self scopes
		detect: [:aScope | aScope hasCurrentEntity and: [aScope currentEntity class = anEntityType]]
		ifNone: [ SRNoCurrentEntityOfSpecificTypeAvailable signalForType: anEntityType ReferencesResolver:  self ]) currentEntity
]

{ #category : 'alias' }
SRReferencesSolver >> defineAliasInCurrentScope: aString for: aBlockClosure [
	self topScope addAlias: aString forEntity: aBlockClosure value
]

{ #category : 'accessing' }
SRReferencesSolver >> detect: aBlock [
	"Detects the scope for which aBlock evaluates to true."
	^ self scopes detect: aBlock
]

{ #category : 'initialization' }
SRReferencesSolver >> initialize [
	super initialize.
	self scopes: Stack new
]

{ #category : 'accessing' }
SRReferencesSolver >> mainEntity [
	^ (self scopes
		detect: #isMainEntity 
		ifNone: [ SRNoMainEntityAvailable signalReferencesResolver: self ]) currentEntity
]

{ #category : 'accessing' }
SRReferencesSolver >> peekScopeAtIndex: anInteger [
	"DISCLAIMER:
	 Returns the scope at index anInteger (index 1 is the top of the stack).
	 This method is really specific and should usually NOT BE USED.
	 Beware, if you use it you're problably doing it wrongly.
	 However there are some special cases where you need to do it."
	^ self scopes at: anInteger
]

{ #category : 'scopes management' }
SRReferencesSolver >> popScope [
	^ self copyScopes pop
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushEntitiesAsScope: aCollectionOfEntities [
	self pushScope: (SRCollectionScope reachableEntities: aCollectionOfEntities)
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushEntityAsScope: anEntity [
	self pushScope: (SREntityScope entity: anEntity)
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushResolvableAsScopeBeforeCurrentScope: aResolvable foundAction: aBlockClosure [
	self assert: aResolvable isResolvable description: 'Only SRResolvable can be provided as scope this way'.
	"we push the resolvable in the stuff to resolve"
	self resolve: aResolvable foundAction: aBlockClosure.
	"then we add a scope around it"
	^ self pushScopeBeforeCurrentScope: (SRResolvableEntityScope resolvable: aResolvable).
	"we should never have a stock stack containing this stuff before it is resolved"
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushResolvableAsScopeBeforeMainEntityScope: aResolvable foundAction: aBlockClosure [
	self assert: aResolvable isResolvable description: 'Only SRResolvable can be provided as scope this way'.
	"we push the resolvable in the stuff to resolve"
	self resolve: aResolvable foundAction: aBlockClosure.
	"then we add a scope around it"
	^ self pushScopeBeforeMainEntityScope: (SRResolvableEntityScope resolvable: aResolvable).
	"we should never have a stock stack containing this stuff before it is resolved"
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushScope: aScope [
	"we do a copy to avoid changing previous scope that need to be resolved later"
	^ self copyScopes push: aScope
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushScopeBeforeCurrentScope: aScope [
	| topScope |
	topScope := self popScope.
	self scopes
		push: aScope;
		push: topScope.
	^ aScope 
]

{ #category : 'scopes management' }
SRReferencesSolver >> pushScopeBeforeMainEntityScope: aScope [
	| scopeStack |
	scopeStack := Stack new.
	[[ (scopeStack push: self popScope) isMainEntity ] whileFalse] on: CollectionIsEmpty do: [SRNoMainEntityAvailable signalReferencesResolver: self "Careful, the stack has been modified, everything is in the scope stack local variable"].
	"we pop the scope stack until we find the main entity scope"
	self scopes push: aScope.
	"then we push the parameter scope"
	[ self scopes push: scopeStack pop. scopeStack isEmpty ] whileFalse.
	"then we push all popped scopes in the scopes stack"
	^ aScope 
]

{ #category : 'detect' }
SRReferencesSolver >> reachableEntitiesFor: aScope detect: aBlockClosure ifFound: aBlockClosureAction [
	"optimisation to avoid recreate collection"

	aScope reachableEntities
		detect: aBlockClosure
		ifFound: [ :f | ^ aBlockClosureAction value: f ]
		ifNone: [ "continue" ].
	NotFound signal
]

{ #category : 'removing' }
SRReferencesSolver >> removeScope: aPSQLScope [
	self copyScopes remove: aPSQLScope
]

{ #category : 'solving' }
SRReferencesSolver >> resolve: aSRIdentifierWithNode foundAction: aBlockClosure [ 
	self shouldBeImplemented.
]

{ #category : 'resolution' }
SRReferencesSolver >> resolve: aResolvable inScope: aScope [
	^ aResolvable resolveInScope: aScope currentEntity: self currentEntity 
]

{ #category : 'testing' }
SRReferencesSolver >> scopeIsEmpty [

	^ self scopes allSatisfy: [ :scope | scope hasCurrentEntity not ]
]

{ #category : 'accessing' }
SRReferencesSolver >> scopes [
	^ scopes
]

{ #category : 'accessing' }
SRReferencesSolver >> scopes: anObject [
	scopes := anObject
]

{ #category : 'accessing' }
SRReferencesSolver >> topScope [
	^ self scopes top
]

{ #category : 'accessing' }
SRReferencesSolver >> topScopeReachableEntities [
	^ self topScope reachableEntities
]
