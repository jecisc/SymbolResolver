"
I hold all the errors that were raised during parsing so they are not just ignored and lost while the model is built.

With my help, it is possible to create incomplete models to work with til the importer works entirely.

I have a world menu entry allowing the user to actually raise the errors instead of catching them if they want. (In the Debug menu)
"
Class {
	#name : 'SRParsingReport',
	#superclass : 'Object',
	#instVars : [
		'errors',
		'warnings'
	],
	#classVars : [
		'IsInDebugMode'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRParsingReport class >> isInDebugMode [

	^ IsInDebugMode ifNil: [ IsInDebugMode := false ]
]

{ #category : 'accessing' }
SRParsingReport class >> isInDebugMode: aBoolean [

	IsInDebugMode := aBoolean
]

{ #category : 'world menu' }
SRParsingReport class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Toggle Symbol Resolver Debug mode')
		parent: #Debug;
		action: [ self isInDebugMode: self isInDebugMode not ];
		order: 99999;
		withSeparatorAfter;
		help: 'If this is enabled, errors will not be caught in the symbol resolution but passed.';
		icon: (self iconNamed: #configuration)
]

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

	aBlock
		on: exceptionOrExceptionSet
		do: [ :exception |
			(isWarningConditionBlock value: exception)
				ifTrue: [
					self addWarning: exception.
					exception resume ]
				ifFalse: [
					self class isInDebugMode ifTrue: [ exception pass ].
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
