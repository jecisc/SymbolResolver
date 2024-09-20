Class {
	#name : 'SRScopeManager',
	#superclass : 'Object',
	#instVars : [
		'associatedSolver',
		'addedScopes'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'instance creation' }
SRScopeManager class >> newAssociatedToSolver: aPSQLReferenciesSolver [
	^ self new
		associatedSolver: aPSQLReferenciesSolver;
		yourself
]

{ #category : 'accessing' }
SRScopeManager >> addedScopes [
	^ addedScopes
]

{ #category : 'accessing' }
SRScopeManager >> addedScopes: anObject [
	addedScopes := anObject
]

{ #category : 'accessing' }
SRScopeManager >> associatedSolver [
	^ associatedSolver
]

{ #category : 'accessing' }
SRScopeManager >> associatedSolver: anObject [
	associatedSolver := anObject
]

{ #category : 'clearing' }
SRScopeManager >> clear [
	self addedScopes do: [ :aScope | self associatedSolver removeScope: aScope ]
]

{ #category : 'initialization' }
SRScopeManager >> initialize [
	super initialize.
	self addedScopes: OrderedCollection new
]

{ #category : 'scope creation' }
SRScopeManager >> pushScope: aPSQLScope [
	^ self pushScope: aPSQLScope andDoAsCurrentEntity: [  ]
]

{ #category : 'scope creation' }
SRScopeManager >> pushScope: aPSQLScope andDoAsCurrentEntity: aBlock [
	self associatedSolver pushScope: aPSQLScope.
	aBlock value.
	self addedScopes add: aPSQLScope.
	aPSQLScope isCurrentEntity: false. "It can never be the current entity because the scope manager is designed to add this scope to upper current entity."
	^ aPSQLScope
]
