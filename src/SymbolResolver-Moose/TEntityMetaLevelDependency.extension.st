Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> childOfType: aType named: aString [
	"This can be often useful in parser writtings in order to find if we already created some entities or not."

	^ (self query descendants ofType: aType)
		  detect: [ :child | child name = aString ]
		  ifNone: [ nil ]
]

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reachableEntitiesNamed: aString ofKinds: aCollection [

	^ (self query descendants ofAnyType: aCollection) select: [ :child | child name = aString ]
]

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reacheableEntities [

	^ self children
]
