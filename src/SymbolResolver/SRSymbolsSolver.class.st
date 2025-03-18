"
I am a class used to do symbol resolution for a parser. I'll store the scopes of the parsing and my users can ask me to resolve symbols (accesses, imports, references...) after the first pass of a parsing.

In order to do that I'll save a collection of `SRResolvable` with a copy of the scopes stack to be able to resolve them.
"
Class {
	#name : 'SRSymbolsSolver',
	#superclass : 'Object',
	#instVars : [
		'toResolve',
		'scopes',
		'errorReport'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'scopes management' }
SRSymbolsSolver >> copyScopes [
	^ scopes := scopes copy
]

{ #category : 'manager' }
SRSymbolsSolver >> createScopeManager [
	^ SRScopeManager newAssociatedToSolver: self
]

{ #category : 'accessing' }
SRSymbolsSolver >> currentEntity [
	^ (self scopes
		detect: #hasCurrentEntity
		ifNone: [ SRNoCurrentEntityAvailable signalReferencesResolver: self ]) currentEntity
]

{ #category : 'accessing' }
SRSymbolsSolver >> currentEntityOfType: anEntityType [
	^ (self scopes
		detect: [:aScope | aScope hasCurrentEntity and: [aScope currentEntity class = anEntityType]]
		ifNone: [ SRNoCurrentEntityOfSpecificTypeAvailable signalForType: anEntityType ReferencesResolver:  self ]) currentEntity
]

{ #category : 'alias' }
SRSymbolsSolver >> defineAliasInCurrentScope: aString for: aBlockClosure [
	self topScope addAlias: aString forEntity: aBlockClosure value
]

{ #category : 'accessing' }
SRSymbolsSolver >> detect: aBlock [
	"Detects the scope for which aBlock evaluates to true."
	^ self scopes detect: aBlock
]

{ #category : 'accessing' }
SRSymbolsSolver >> errorReport [

	^ errorReport ifNil: [ errorReport := SRParsingReport new ]
]

{ #category : 'accessing' }
SRSymbolsSolver >> hasCurrentEntity [

	^ self scopes
		  detect: #hasCurrentEntity
		  ifFound: [ :scope | true ]
		  ifNone: [ false ]
]

{ #category : 'initialization' }
SRSymbolsSolver >> initialize [

	super initialize.
	self scopes: Stack new.
	self toResolve: OrderedCollection new
]

{ #category : 'accessing' }
SRSymbolsSolver >> mainEntity [
	^ (self scopes
		detect: #isMainEntity 
		ifNone: [ SRNoMainEntityAvailable signalReferencesResolver: self ]) currentEntity
]

{ #category : 'accessing' }
SRSymbolsSolver >> peekScopeAtIndex: anInteger [
	"DISCLAIMER:
	 Returns the scope at index anInteger (index 1 is the top of the stack).
	 This method is really specific and should usually NOT BE USED.
	 Beware, if you use it you're problably doing it wrongly.
	 However there are some special cases where you need to do it."
	^ self scopes at: anInteger
]

{ #category : 'scopes management' }
SRSymbolsSolver >> popScope [
	^ self copyScopes pop
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushEntitiesAsScope: aCollectionOfEntities [
	self pushScope: (SRCollectionScope reachableEntities: aCollectionOfEntities)
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushEntityAsScope: anEntity [
	self pushScope: (SREntityScope entity: anEntity)
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushResolvableAsScopeBeforeCurrentScope: aResolvable foundAction: aBlockClosure [
	self assert: aResolvable isResolvable description: 'Only SRResolvable can be provided as scope this way'.
	"we push the resolvable in the stuff to resolve"
	self resolve: aResolvable foundAction: aBlockClosure.
	"then we add a scope around it"
	^ self pushScopeBeforeCurrentScope: (SRResolvableEntityScope resolvable: aResolvable).
	"we should never have a stock stack containing this stuff before it is resolved"
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushResolvableAsScopeBeforeMainEntityScope: aResolvable foundAction: aBlockClosure [
	self assert: aResolvable isResolvable description: 'Only SRResolvable can be provided as scope this way'.
	"we push the resolvable in the stuff to resolve"
	self resolve: aResolvable foundAction: aBlockClosure.
	"then we add a scope around it"
	^ self pushScopeBeforeMainEntityScope: (SRResolvableEntityScope resolvable: aResolvable).
	"we should never have a stock stack containing this stuff before it is resolved"
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushScope: aScope [
	"we do a copy to avoid changing previous scope that need to be resolved later"
	^ self copyScopes push: aScope
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushScopeBeforeCurrentScope: aScope [
	| topScope |
	topScope := self popScope.
	self scopes
		push: aScope;
		push: topScope.
	^ aScope 
]

{ #category : 'scopes management' }
SRSymbolsSolver >> pushScopeBeforeMainEntityScope: aScope [
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
SRSymbolsSolver >> reachableEntitiesFor: aScope detect: aBlockClosure ifFound: aBlockClosureAction [
	"optimisation to avoid recreate collection"

	aScope reachableEntities
		detect: aBlockClosure
		ifFound: [ :f | ^ aBlockClosureAction value: f ]
		ifNone: [ "continue" ].
	NotFound signal
]

{ #category : 'removing' }
SRSymbolsSolver >> removeScope: aPSQLScope [
	self copyScopes remove: aPSQLScope
]

{ #category : 'accessing' }
SRSymbolsSolver >> resolve: aResolvable foundAction: aBlockClosure [

	^ self resolve: aResolvable foundAction: aBlockClosure ifNone: nil
]

{ #category : 'accessing' }
SRSymbolsSolver >> resolve: aResolvable foundAction: aBlockClosure ifNone: anotherBlock [

	^ self toResolve addLast: (SRResolvableWithContext
			   newFromScopes: self scopes
			   resolvable: aResolvable
			   foundAction: aBlockClosure
			   ifNone: anotherBlock)
]

{ #category : 'resolution' }
SRSymbolsSolver >> resolve: aResolvable inScope: aScope [
	^ aResolvable resolveInScope: aScope currentEntity: self currentEntity 
]

{ #category : 'resolution' }
SRSymbolsSolver >> resolveUnresolvedSymbols [

	self toResolve do: [ :resolvable | self errorReport catch: Exception during: [ resolvable resolve ] ] displayingProgress: 'References resolution'
]

{ #category : 'testing' }
SRSymbolsSolver >> scopeIsEmpty [

	^ self scopes allSatisfy: [ :scope | scope hasCurrentEntity not ]
]

{ #category : 'accessing' }
SRSymbolsSolver >> scopes [
	^ scopes
]

{ #category : 'accessing' }
SRSymbolsSolver >> scopes: anObject [
	scopes := anObject
]

{ #category : 'accessing' }
SRSymbolsSolver >> toResolve [
	^ toResolve
]

{ #category : 'accessing' }
SRSymbolsSolver >> toResolve: anObject [
	toResolve := anObject
]

{ #category : 'accessing' }
SRSymbolsSolver >> topScope [
	^ self scopes top
]

{ #category : 'accessing' }
SRSymbolsSolver >> topScopeReachableEntities [
	^ self topScope reachableEntities
]
