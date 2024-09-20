"
I am a class that contains all stuffs unresolved. I am used to ensure the visitor can be destroy for each AST and i guarantee no one is lost.
"
Class {
	#name : 'SRResolvablesContainer',
	#superclass : 'Object',
	#instVars : [
		'unresolvedElements'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'adding' }
SRResolvablesContainer >> addLast: aSRReferenceToResolve [ 
	^ self unresolvedElements addLast: aSRReferenceToResolve 
]

{ #category : 'initialization' }
SRResolvablesContainer >> initialize [
	super initialize.
	unresolvedElements := OrderedCollection new
]

{ #category : 'resolution' }
SRResolvablesContainer >> resolveAll [
	self unresolvedElements do: #resolve
]

{ #category : 'accessing' }
SRResolvablesContainer >> unresolvedElements [
	^ unresolvedElements
]

{ #category : 'accessing' }
SRResolvablesContainer >> unresolvedElements: anObject [
	unresolvedElements := anObject
]
