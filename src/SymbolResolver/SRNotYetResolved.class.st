Class {
	#name : 'SRNotYetResolved',
	#superclass : 'Error',
	#instVars : [
		'resolvable'
	],
	#category : 'SymbolResolver-Errors',
	#package : 'SymbolResolver',
	#tag : 'Errors'
}

{ #category : 'accessing' }
SRNotYetResolved >> resolvable [
	^ resolvable
]

{ #category : 'accessing' }
SRNotYetResolved >> resolvable: anObject [
	resolvable := anObject
]
