Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reachableEntitiesNamed: aString ofKinds: aCollection [

	^ (self query descendants ofAnyType: aCollection) select: [ :child | child name = aString ]
]

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reacheableEntities [

	^ self children
]
