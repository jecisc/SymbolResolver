Extension { #name : 'MooseEntity' }

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> childOfType: aType named: aString [
	"This can be often useful in parser writtings in order to find if we already created some entities or not."

	^ (self query descendants ofType: aType)
		  detect: [ :child | child matchesName: aString ]
		  ifNone: [ nil ]
]

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> definedEntities [
	"Returns the list of entities I define. I will return my children. Be ceraful, this is only for one level. I do not check my children recusively because this should be managed by the scope lookup. If you miss entities, you probably miss a scope."

	"In this version we do not check the imports because we want to check imports only at 1 level"

	^ self query descendants ofAnyType
]

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> definedEntitiesNamed: aString ofKinds: aCollection [
	"I will return the entities I define with a certain name and a certain type.  I will check my children. Be careful, this is only for one level. I do not check my children recusively because this should be managed by the scope lookup. If you miss entities, you probably miss a scope."

	"In this version we do not check the imports because we want to check imports only at 1 level"

	| possibleKinds result |
	possibleKinds := aCollection copyWithout: self class. "If we have my class in the list I'll not check the children..."
	result := self query descendants ofAnyType: possibleKinds.
	(aCollection includes: self class) ifTrue: [
			result add: self.
			result addAll: (self children select: [ :child | child isOfType: self class ]) ].
	^ result select: [ :child | child matchesName: aString ]
]

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> reachableEntities [
	"Returns the list of entities I can reach. I will return my children. Be ceraful, this is only for one level. I do not check my children recusively because this should be managed by the scope lookup. If you miss entities, you probably miss a scope.
	
	By default it is the entities I define, but this can depend on the language. Override me if it is the case."

	"Ideally this method should be on TEntityMetaLevelDependency. But we want people to be able to override it to add specificities for their language, for example import management."

	^ self definedEntities
]

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> reachableEntitiesNamed: aString ofKinds: aCollection [
	"I will return the entities I I can reach with a certain name and a certain type.  I will check my children. Be careful, this is only for one level. I do not check my children recusively because this should be managed by the scope lookup. If you miss entities, you probably miss a scope.
		
	By default it is the entities I define, but this can depend on the language. Override me if it is the case."

	"Ideally this method should be on TEntityMetaLevelDependency. But we want people to be able to override it to add specificities for their language, for example import management."

	^ self definedEntitiesNamed: aString ofKinds: aCollection
]
