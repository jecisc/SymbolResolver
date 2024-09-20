"
I am the error signaled by SRReferencesResolver if #mainEntity is called and not main entity has been set previously.
"
Class {
	#name : 'SRNoMainEntityAvailable',
	#superclass : 'Error',
	#instVars : [
		'referencesResolver'
	],
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

{ #category : 'accessing' }
SRNoMainEntityAvailable >> referencesResolver [
	^ referencesResolver
]

{ #category : 'accessing' }
SRNoMainEntityAvailable >> referencesResolver: anObject [
	referencesResolver := anObject
]
