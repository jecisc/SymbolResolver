"
I am an error that occurs when the solver do not find the reference
"
Class {
	#name : 'SRReferencesNotFound',
	#superclass : 'Error',
	#instVars : [
		'identifiers'
	],
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

{ #category : 'accessing' }
SRReferencesNotFound >> identifiers [
	^ identifiers
]

{ #category : 'accessing' }
SRReferencesNotFound >> identifiers: anObject [
	identifiers := anObject
]

{ #category : 'printing' }
SRReferencesNotFound >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	self identifiers printOn: aStream.
	aStream << $)
]
