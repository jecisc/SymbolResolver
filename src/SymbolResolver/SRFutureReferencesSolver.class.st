"
I am a reference solver that does not directly resolve stuff but store all the resolution it will have to do and then resolve everything when #resolveStoredCases is called
"
Class {
	#name : 'SRFutureReferencesSolver',
	#superclass : 'SRReferencesSolver',
	#instVars : [
		'toResolve'
	],
	#category : 'SymbolResolver-Solver',
	#package : 'SymbolResolver',
	#tag : 'Solver'
}

{ #category : 'initialization' }
SRFutureReferencesSolver >> initialize [ 
	super initialize.
	self toResolve: OrderedCollection new
]

{ #category : 'accessing' }
SRFutureReferencesSolver >> resolve: aResolvable foundAction: aBlockClosure [
	^ self toResolve
		addLast:
			(SRResolvableWithContext
				newFromScopes: self scopes
				identifiers: aResolvable
				foundAction: aBlockClosure)
]

{ #category : 'accessing' }
SRFutureReferencesSolver >> resolveImmediately: aResolvable [
	^ super resolve: aResolvable 
]

{ #category : 'resolution' }
SRFutureReferencesSolver >> resolveUnresolvedReferences [
	self toResolve
		do: #resolve
		displayingProgress: 'References resolution'
]

{ #category : 'accessing' }
SRFutureReferencesSolver >> toResolve [
	^ toResolve
]

{ #category : 'accessing' }
SRFutureReferencesSolver >> toResolve: anObject [
	toResolve := anObject
]
