"
I am an error that occurs when the solver do not find the reference
"
Class {
	#name : 'SRReferenceNotFound',
	#superclass : 'Error',
	#instVars : [
		'identifier'
	],
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'exceptioninstantiator' }
SRReferenceNotFound class >> signal: anIdentifier [
	^ self new
		identifier: anIdentifier;
		signal
]

{ #category : 'accessing' }
SRReferenceNotFound >> identifier [
	^ identifier
]

{ #category : 'accessing' }
SRReferenceNotFound >> identifier: anObject [
	identifier := anObject
]

{ #category : 'printing' }
SRReferenceNotFound >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	self identifier printOn: aStream.
	aStream << $)
]
