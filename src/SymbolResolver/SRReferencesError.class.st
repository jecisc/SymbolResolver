"
I am an abstract error concerning some identifiers representing references to entities.
"
Class {
	#name : 'SRReferencesError',
	#superclass : 'Error',
	#instVars : [
		'identifiers'
	],
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'signalling' }
SRReferencesError class >> signalIdentifier: anIdentifier [
	^ self signalIdentifiers: { anIdentifier }
]

{ #category : 'signalling' }
SRReferencesError class >> signalIdentifiers: aCollectionOfIdentifiers [
	^ self new
		identifiers: aCollectionOfIdentifiers;
		signal
]

{ #category : 'accessing' }
SRReferencesError >> identifiers [
	^ identifiers
]

{ #category : 'accessing' }
SRReferencesError >> identifiers: anObject [
	identifiers := anObject
]

{ #category : 'printing' }
SRReferencesError >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	self identifiers printOn: aStream.
	aStream << $)
]
