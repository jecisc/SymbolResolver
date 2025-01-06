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

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reachableEntitiesNamed: aString ofKinds: aCollection [

	| entities |
	entities := Set new.

	self outgoingImports do: [ :import | "It is possible for the imported entity to be nil in case it was not yet resolved.
		Imagine you reference something and later in the file there is an import. We resolve things in the order they appear, so the import might not yet be resolved. But in that case we can just ignore it."
		import importedEntity ifNotNil: [ :entity | "In case the import has an alias, we add the imported entity. "
			import alias = aString
				ifTrue: [ entities add: import importedEntity ]
				ifFalse: [ entities addAll: (entity definedEntitiesNamed: aString ofKinds: aCollection) ] ] ].

	entities addAll: (self definedEntitiesNamed: aString ofKinds: aCollection).

	^ entities
]

{ #category : '*SymbolResolver-Moose' }
TEntityMetaLevelDependency >> reacheableEntities [

	^ self children
]
