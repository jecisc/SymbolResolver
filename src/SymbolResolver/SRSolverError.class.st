"
I am an abstract error for errors raised by a solver.
"
Class {
	#name : 'SRSolverError',
	#superclass : 'Error',
	#instVars : [
		'referencesResolver'
	],
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'accessing' }
SRSolverError >> referencesResolver [
	^ referencesResolver
]

{ #category : 'accessing' }
SRSolverError >> referencesResolver: anObject [
	referencesResolver := anObject
]
