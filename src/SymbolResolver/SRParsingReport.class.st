"
I hold all the errors that were raised during parsing so they are not just ignored and lost while the model is built.

With my help, it is possible to create incomplete models to work with til the importer works entirely.
"
Class {
	#name : 'SRParsingReport',
	#superclass : 'Object',
	#instVars : [
		'errors',
		'warnings'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'adding' }
SRParsingReport >> addError: anError [
	^ self errors add: anError
]

{ #category : 'adding' }
SRParsingReport >> addWarning: anObject [
	self warnings add: anObject
]

{ #category : 'catching' }
SRParsingReport >> catch: exceptionOrExceptionSet during: aBlock [
	^ self
		catch: exceptionOrExceptionSet
		during: aBlock
		isWarningIf: [ :e | e class = Warning ]
]

{ #category : 'catching' }
SRParsingReport >> catch: exceptionOrExceptionSet during: aBlock isWarningIf: isWarningConditionBlock [
	"Catches the exception provided as argument or any exception of exception set (if it is an exception set) during th execution of aBlock.
	 If the isWarningConditionBlock evaluates to true with the exception caught, adds it to warning and resume it. Else adds it to errors and stop execution."
	aBlock on: exceptionOrExceptionSet do: [ :exception |
		(isWarningConditionBlock value: exception)
			ifTrue: [
				self addWarning: exception.
				exception resume ]
			ifFalse: [ 
				self addError: exception ] ]
]

{ #category : 'catching' }
SRParsingReport >> catchWarningsDuring: aBlock [
	aBlock
		on: Warning
		do: [ :w |
			self addWarning: w.
			w resume ]
]

{ #category : 'accessing' }
SRParsingReport >> errors [
	^ errors
]

{ #category : 'accessing' }
SRParsingReport >> errors: anObject [
	errors := anObject
]

{ #category : 'testing' }
SRParsingReport >> ifNotEmpty: aBlock [
	self errors ifNotEmpty: aBlock
]

{ #category : 'initialization' }
SRParsingReport >> initialize [
	super initialize.
	self errors: OrderedCollection new.
	self warnings: OrderedCollection new
]

{ #category : 'accessing' }
SRParsingReport >> warnings [
	^ warnings
]

{ #category : 'accessing' }
SRParsingReport >> warnings: anObject [
	warnings := anObject
]
