Class {
	#name : 'SRReferencesSolverTest',
	#superclass : 'TestCase',
	#instVars : [
		'referencesSolver'
	],
	#category : 'SymbolResolver-Tests',
	#package : 'SymbolResolver-Tests'
}

{ #category : 'running' }
SRReferencesSolverTest >> setUp [
	super setUp.
	referencesSolver := SRFutureReferencesSolver new
]

{ #category : 'tests' }
SRReferencesSolverTest >> testCreateScopeManager [
	| scopeManager |
	scopeManager := referencesSolver createScopeManager.
	
	self assert: scopeManager class equals: SRScopeManager.
	self assert: scopeManager associatedSolver equals: referencesSolver
]

{ #category : 'tests' }
SRReferencesSolverTest >> testCurrentEntity [
	| currentEntity currentEntity2 |
	self should: [ referencesSolver currentEntity ] raise: SRNoCurrentEntityAvailable.
	
	currentEntity := Object new.
	referencesSolver pushScope: (SREntityScope currentEntity: currentEntity).
	self assert: referencesSolver currentEntity equals: currentEntity.
	
	referencesSolver pushScope: (SREntityScope entity: Object new).
	self assert: referencesSolver currentEntity equals: currentEntity.
	
	referencesSolver pushScope: (SRCollectionScope reachableEntities: { Object new }).
	self assert: referencesSolver currentEntity equals: currentEntity.
	
	currentEntity2 := Object new.
	referencesSolver pushScope: (SREntityScope currentEntity: currentEntity2).
	self assert: referencesSolver currentEntity equals: currentEntity2.
	
	referencesSolver popScope.
	self assert: referencesSolver currentEntity equals: currentEntity.
]

{ #category : 'tests' }
SRReferencesSolverTest >> testDefineAliasInCurrentScopeFor [
	self flag: #todo. "Add test."
	self skip.
	self fail
]

{ #category : 'tests' }
SRReferencesSolverTest >> testEnsureScopesAreCopied [
	| firstScope scopesFirstState secondScope scopesSecondState |
	firstScope := SREntityScope new.
	secondScope := SREntityScope new.
	referencesSolver pushScope: firstScope.
	scopesFirstState := referencesSolver scopes.
	self assert: scopesFirstState equals: {firstScope}.
	referencesSolver pushScope: secondScope.
	scopesSecondState := referencesSolver scopes.
	self assert: scopesSecondState equals: {secondScope . firstScope}.
	self deny: scopesFirstState identicalTo: scopesSecondState.
	self assert: scopesFirstState equals: {firstScope}
]

{ #category : 'tests' }
SRReferencesSolverTest >> testPopScope [
	| sizeBefore scope |
	sizeBefore := referencesSolver scopes size.
	scope := SRScope new.
	referencesSolver pushScope: scope.
	self assert: referencesSolver scopes size equals: sizeBefore + 1.
	
	referencesSolver popScope.
	self assert: referencesSolver scopes size equals: sizeBefore
]

{ #category : 'tests' }
SRReferencesSolverTest >> testPushEntitiesAsScope [
	| entities |
	entities := { Object new. Object new. Object new }.
	
	referencesSolver pushEntitiesAsScope: entities.
	
	self assert: referencesSolver scopes first class equals: SRCollectionScope.
	self assert: referencesSolver scopes first reachableEntitiesOwned equals: entities.
]

{ #category : 'tests' }
SRReferencesSolverTest >> testPushEntityAsScope [
	| entity |
	entity := Object new.
	
	referencesSolver pushEntityAsScope: entity.
	
	self assert: referencesSolver scopes first class equals: SREntityScope.
	self assert: referencesSolver scopes first entity equals: entity.
]

{ #category : 'tests' }
SRReferencesSolverTest >> testPushEntityBlockAsScope [
	| entity computer isFoundActionTriggered |
	isFoundActionTriggered := false.
	entity := Mock named: #Cyril.
	computer := Mock named: #computer.
	(entity stub reachableEntitiesNamed: #computer ofKinds: {nil}) willReturn: {computer}.
	computer stub name willReturn: #computer.
	referencesSolver pushScope: (SREntityScope currentEntity: entity).
	referencesSolver pushResolvableAsScopeBeforeCurrentScope: (SRIdentifierWithNode identifier: 'computer') foundAction: [ isFoundActionTriggered := true ].
	self assert: referencesSolver scopes pop entity equals: entity.
	self assert: referencesSolver scopes top class equals: SRResolvableEntityScope.
	self deny: referencesSolver scopes top isResolved.
	referencesSolver resolveUnresolvedReferences.
	self assert: referencesSolver scopes top entity equals: computer.
	self assert: referencesSolver scopes top isResolved.
	self assert: isFoundActionTriggered
]

{ #category : 'tests' }
SRReferencesSolverTest >> testPushScope [
	| scope |
	scope := SRScope new.
	referencesSolver pushScope: scope.
	
	self assert: referencesSolver scopes first equals: scope
]

{ #category : 'tests' }
SRReferencesSolverTest >> testRemoveScope [
	| scopesCount scope1 scope2 scope3 |
	scopesCount := referencesSolver scopes size.
	scope1 := SRScope new.
	scope2 := SRScope new.
	scope3 := SRScope new.
	referencesSolver pushScope: scope1.
	referencesSolver pushScope: scope2.
	referencesSolver pushScope: scope3.
	
	self assert: referencesSolver scopes size equals: scopesCount + 3.
	self assert: referencesSolver scopes first equals: scope3.
	self assert: referencesSolver scopes allButFirst first equals: scope2.
	self assert: (referencesSolver scopes allButFirst: 2) first equals: scope1.
	
	referencesSolver removeScope: scope2.
	
	self assert: referencesSolver scopes size equals: scopesCount + 2.
	self assert: referencesSolver scopes first equals: scope3.
	self assert: referencesSolver scopes allButFirst first equals: scope1
]

{ #category : 'tests' }
SRReferencesSolverTest >> testResolve [
	| cyril guillaume isFoundActionTriggered |
	isFoundActionTriggered := false.
	cyril := Mock named: #Cyril.
	guillaume := Mock named: #Guillaume.
	referencesSolver pushScope: (SREntityScope currentEntity: cyril).
	referencesSolver
		resolve: (SRIdentifierWithNode identifier: #guillaume)
		foundAction: [ :foundEntity :currentEntity | 
			self assert: foundEntity equals: guillaume.
			self assert: currentEntity equals: cyril.
			isFoundActionTriggered := true ].
	(cyril stub reachableEntitiesNamed: 'guillaume' ofKinds: {nil}) willReturn: {guillaume}.
	guillaume stub name willReturn: 'guillaume'.
	referencesSolver resolveUnresolvedReferences.
	self assert: isFoundActionTriggered
]

{ #category : 'tests' }
SRReferencesSolverTest >> testResolveInScope [
	self flag: #todo. "Add test."
	self skip.
	self fail
]

{ #category : 'tests' }
SRReferencesSolverTest >> testTopScopeReachableEntities [
	self flag: #todo. "Add test."
	self skip.
	self fail
]
