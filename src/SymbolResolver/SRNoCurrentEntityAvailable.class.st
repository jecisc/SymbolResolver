"
I am the error signaled by SRReferencesResolver if #currentEntity is called and not current entity has been set previously.
"
Class {
	#name : 'SRNoCurrentEntityAvailable',
	#superclass : 'SRSolverError',
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'signalling' }
SRNoCurrentEntityAvailable class >> signalReferencesResolver: anObject [
	self new
		referencesResolver: anObject;
		signal
]
