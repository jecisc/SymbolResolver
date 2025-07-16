Extension { #name : 'MooseEntity' }

{ #category : '*SymbolResolver-Moose' }
MooseEntity >> reachableEntitiesNamed: aString ofKinds: aCollection [
	"Ideally this method should be on TEntityMetaLevelDependency. But we want people to be able to override it to add specificities for their language, for example import management."

	^ self definedEntitiesNamed: aString ofKinds: aCollection
]
