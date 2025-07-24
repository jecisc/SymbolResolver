Extension { #name : 'FamixTNamedEntity' }

{ #category : '*SymbolResolver-Moose' }
FamixTNamedEntity >> matchesName: aString [
	"I am used by the symbol resolver to find an entity by a name. I should be redefined by some entities for some tricky cases such as aliases."

	^ self name = aString
]
