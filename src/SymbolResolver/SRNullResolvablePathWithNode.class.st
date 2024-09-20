"
I am a path out of analysis that will lead to a stub (#include <stdio.h>)
"
Class {
	#name : 'SRNullResolvablePathWithNode',
	#superclass : 'SRResolvable',
	#instVars : [
		'entity'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRNullResolvablePathWithNode class >> path: aStringPath [
	^ self new path: aStringPath; yourself
]

{ #category : 'accessing' }
SRNullResolvablePathWithNode >> path [
	^ self identifier
]

{ #category : 'accessing' }
SRNullResolvablePathWithNode >> path: anObject [
	self identifier: anObject
]
