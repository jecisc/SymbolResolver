"
I am a trait for visitors that are using a solver
"
Trait {
	#name : 'SRTSolverUserVisitor',
	#instVars : [
		'solver'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRTSolverUserVisitor >> currentEntity [
	^ self solver currentEntity
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> currentEntity: anEntity [
	^ self solver pushScope: (SREntityScope currentEntity: anEntity)
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> currentEntityOfType: anEntityType [
	^ self solver currentEntityOfType: anEntityType
]

{ #category : 'alias' }
SRTSolverUserVisitor >> defineAliasInCurrentScope: anAlias for: aBlockClosure [
	^ self solver defineAliasInCurrentScope: anAlias for: aBlockClosure
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> errorReport [

	^ self solver errorReport
]

{ #category : 'initialization' }
SRTSolverUserVisitor >> initialiseSolver [
	solver := SRSymbolsSolver new
]

{ #category : 'scope' }
SRTSolverUserVisitor >> popScope [
	^ self solver popScope
]

{ #category : 'scope' }
SRTSolverUserVisitor >> pushEntitiesAsScope: aCollectionOfEntities [
	self solver pushEntitiesAsScope: aCollectionOfEntities
]

{ #category : 'scope' }
SRTSolverUserVisitor >> pushEntityAsScope: anEntity [
	self solver pushEntityAsScope: anEntity
]

{ #category : 'resolution' }
SRTSolverUserVisitor >> resolve: aResolvable [
	self solver resolve: aResolvable
]

{ #category : 'resolution' }
SRTSolverUserVisitor >> resolve: aSRResolvable foundAction: aBlockClosure [ 
	^ self solver resolve: aSRResolvable foundAction: aBlockClosure .
]

{ #category : 'resolution' }
SRTSolverUserVisitor >> resolve: identifiers onNotFoundDo: aBlock [
	^ [ self solver resolve: identifiers ]
		on: SRReferencesNotFound
		do: [ aBlock value: identifiers ]
]

{ #category : 'resolution' }
SRTSolverUserVisitor >> resolveSilently: identifiers [

	self errorReport catch: SRReferencesNotFound during: [ self resolve: identifiers ]
]

{ #category : 'resolution' }
SRTSolverUserVisitor >> resolveUnresolvedSymbols [

	^ self solver resolveUnresolvedSymbols
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> solver [
	^ solver ifNil: [ self error: 'The solver has not been initialized. Call #initializeSolver or #initializeFutureSolver in the #initialize method.' ]
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> topScopeReachableEntities [
	^ self solver topScopeReachableEntities
]

{ #category : 'scope' }
SRTSolverUserVisitor >> useCurrentEntity: anEntity during: aBlock [
	"Here we are not testing that we remove the right scope but if it's not the case, it's probably a bug"

	| entityScope |
	entityScope := self currentEntity: anEntity.
	aBlock cull: anEntity.
	self assert: self solver topScope = entityScope description: 'This assert is to check that the good scope is poped'.
	self popScope.
	^ anEntity
]

{ #category : 'stack' }
SRTSolverUserVisitor >> useMainEntity: anEntity during: aBlockClosure [ 
	"Here we are not testing that we remove the right scope but if it's not the case, it's probably a bug"

	| entityScope |
	entityScope := self currentEntity: anEntity.
	entityScope isMainEntity: true.
	aBlockClosure cull: anEntity.
	self assert: self solver topScope = entityScope description: 'This assert is to check that the good scope is poped'.
	self popScope.
	^ anEntity
]

{ #category : 'versions' }
SRTSolverUserVisitor >> version [
	self explicitRequirement
]

{ #category : 'accessing' }
SRTSolverUserVisitor >> withCurrentEntityDo: aBlock [

	self solver scopeIsEmpty ifTrue: [ ^ self ].

	aBlock value: self currentEntity
]
