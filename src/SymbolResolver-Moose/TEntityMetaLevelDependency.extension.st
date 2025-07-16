Extension { #name : 'TEntityMetaLevelDependency' }

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> childOfType: aType named: aString [
	"This can be often useful in parser writtings in order to find if we already created some entities or not."

	^ (self query descendants ofType: aType)
		  detect: [ :child | child name = aString ]
		  ifNone: [ nil ]
]

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> definedEntitiesNamed: aString ofKinds: aCollection [
	"In this version we do not check the imports because we want to check imports only at 1 level"

	| possibleKinds result |
	possibleKinds := aCollection copyWithout: self class. "If we have my class in the list I'll not check the children..."
	result := self query descendants ofAnyType: possibleKinds.
	(aCollection includes: self class) ifTrue: [
		result add: self.
		result addAll: (self children select: [ :child | child isOfType: self class ]) ].
	^ result select: [ :child | child name = aString ]
]
