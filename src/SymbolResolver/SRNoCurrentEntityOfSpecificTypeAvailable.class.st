Class {
	#name : 'SRNoCurrentEntityOfSpecificTypeAvailable',
	#superclass : 'Error',
	#instVars : [
		'referencesResolver',
		'type'
	],
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'signalling' }
SRNoCurrentEntityOfSpecificTypeAvailable class >> signalForType: aType ReferencesResolver: anObject [
	self new
		type: aType;
		referencesResolver: anObject;
		signal
]

{ #category : 'accessing' }
SRNoCurrentEntityOfSpecificTypeAvailable >> referencesResolver [
	^ referencesResolver
]

{ #category : 'accessing' }
SRNoCurrentEntityOfSpecificTypeAvailable >> referencesResolver: anObject [
	referencesResolver := anObject
]

{ #category : 'accessing' }
SRNoCurrentEntityOfSpecificTypeAvailable >> type [
	^ type
]

{ #category : 'accessing' }
SRNoCurrentEntityOfSpecificTypeAvailable >> type: anObject [
	type := anObject
]
