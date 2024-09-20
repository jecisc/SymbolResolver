"
I am an error that occurs when the solver do not find the reference
"
Class {
	#name : 'SRReferencesNotFound',
	#superclass : 'SRReferencesError',
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'exceptioninstantiator' }
SRReferencesNotFound class >> signal: anIdentifier [
	^ self new
		identifier: anIdentifier;
		signal
]
