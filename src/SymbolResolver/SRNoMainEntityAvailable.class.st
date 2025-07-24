"
I am the error signaled by SRReferencesResolver if #mainEntity is called and not main entity has been set previously.
"
Class {
	#name : 'SRNoMainEntityAvailable',
	#superclass : 'SRSolverError',
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'signalling' }
SRNoMainEntityAvailable class >> signalReferencesResolver: anObject [
	self new
		referencesResolver: anObject;
		signal
]
