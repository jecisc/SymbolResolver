"
I am an error that occurs when the solver start to find the reference but then failed to follow the next identifier.

For example, in foo.bar, the resolver was able to resolve foo but not bar.
"
Class {
	#name : 'SRReferencesInconsistencies',
	#superclass : 'SRReferencesError',
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'exceptioninstantiator' }
SRReferencesInconsistencies class >> signal: anIdentifier [
	^ self new
		identifier: anIdentifier;
		signal
]
