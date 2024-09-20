"
I represent the arguments only by their numbers (will permit to reject mismatching invocable by number of arguments)
"
Class {
	#name : 'SRArgumentsOnlyNumber',
	#superclass : 'SRArguments',
	#instVars : [
		'numberOfArguments'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRArgumentsOnlyNumber class >> numberOfArguments: numberOfArguments [
	^ self new
		numberOfArguments: numberOfArguments;
		yourself
]

{ #category : 'accessing' }
SRArgumentsOnlyNumber >> numberOfArguments [
	^ numberOfArguments
]

{ #category : 'accessing' }
SRArgumentsOnlyNumber >> numberOfArguments: anObject [
	numberOfArguments := anObject
]

{ #category : 'printing' }
SRArgumentsOnlyNumber >> printOn: stream [
	super printOn: stream.
	stream nextPut: $(.
	stream nextPutAll: self numberOfArguments asString.
	stream nextPut: $)
]
