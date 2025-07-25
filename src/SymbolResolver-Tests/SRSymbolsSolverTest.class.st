Class {
	#name : 'SRSymbolsSolverTest',
	#superclass : 'TestCase',
	#instVars : [
		'referencesSolver'
	],
	#category : 'SymbolResolver-Tests',
	#package : 'SymbolResolver-Tests'
}

{ #category : 'running' }
SRSymbolsSolverTest >> setUp [
	super setUp.
	referencesSolver := SRSymbolsSolver new
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testCurrentEntity [
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
SRSymbolsSolverTest >> testEnsureScopesAreCopied [
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
SRSymbolsSolverTest >> testPopScope [
	| sizeBefore scope |
	sizeBefore := referencesSolver scopes size.
	scope := SRScope new.
	referencesSolver pushScope: scope.
	self assert: referencesSolver scopes size equals: sizeBefore + 1.
	
	referencesSolver popScope.
	self assert: referencesSolver scopes size equals: sizeBefore
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testPushEntitiesAsScope [
	| entities |
	entities := { Object new. Object new. Object new }.
	
	referencesSolver pushEntitiesAsScope: entities.
	
	self assert: referencesSolver scopes first class equals: SRCollectionScope.
	self assert: referencesSolver scopes first reachableEntities equals: entities.
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testPushEntityAsScope [
	| entity |
	entity := Object new.
	
	referencesSolver pushEntityAsScope: entity.
	
	self assert: referencesSolver scopes first class equals: SREntityScope.
	self assert: referencesSolver scopes first entity equals: entity.
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testPushEntityBlockAsScope [
	| entity computer isFoundActionTriggered |
	isFoundActionTriggered := false.
	entity := Mock named: #Cyril.
	computer := Mock named: #computer.
	(entity stub reachableEntitiesNamed: #computer ofKinds: {nil}) willReturn: {computer}.
	computer stub name willReturn: #computer.
	referencesSolver pushScope: (SREntityScope currentEntity: entity).
	referencesSolver pushResolvableAsScopeBeforeCurrentScope: (SRIdentifierResolvable identifier: 'computer') foundAction: [ isFoundActionTriggered := true ].
	self assert: referencesSolver scopes pop entity equals: entity.
	self assert: referencesSolver scopes top class equals: SRResolvableEntityScope.
	self deny: referencesSolver scopes top isResolved.
	referencesSolver resolveUnresolvedSymbols.
	self assert: referencesSolver scopes top entity equals: computer.
	self assert: referencesSolver scopes top isResolved.
	self assert: isFoundActionTriggered
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testPushScope [
	| scope |
	scope := SRScope new.
	referencesSolver pushScope: scope.
	
	self assert: referencesSolver scopes first equals: scope
]

{ #category : 'tests' }
SRSymbolsSolverTest >> testRemoveScope [
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
SRSymbolsSolverTest >> testResolve [
	| cyril fibao isFoundActionTriggered |
	isFoundActionTriggered := false.
	cyril := Mock named: #Cyril.
	fibao := Mock named: #Fibao.
	referencesSolver pushScope: (SREntityScope currentEntity: cyril).
	referencesSolver
		resolve: (SRIdentifierResolvable identifier: #fibao)
		foundAction: [ :foundEntity :currentEntity | 
			self assert: foundEntity equals: fibao.
			self assert: currentEntity equals: cyril.
			isFoundActionTriggered := true ].
	(cyril stub reachableEntitiesNamed: 'fibao' ofKinds: {nil}) willReturn: {fibao}.
	fibao stub name willReturn: 'fibao'.
	referencesSolver resolveUnresolvedSymbols.
	self assert: isFoundActionTriggered
]
