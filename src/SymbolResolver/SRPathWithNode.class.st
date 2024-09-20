"
I am a path to resolve. I can be used to resolve inclusion (#include ""MyPackage.c"" or #import com.codaxis.SymbolResolver)
"
Class {
	#name : 'SRPathWithNode',
	#superclass : 'SRResolvable',
	#instVars : [
		'entity',
		'rootFolder',
		'path'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'accessing' }
SRPathWithNode class >> path: aStringPath [
	^ self new path: aStringPath; yourself
]

{ #category : 'accessing' }
SRPathWithNode class >> rootFolder: anIMFolder path: aStringPath [
	^ self new
		rootFolder: anIMFolder;
		path: aStringPath;
		yourself
]

{ #category : 'hooks' }
SRPathWithNode >> applyReplacementStrategyWithCurrentEntity: aCurrentEntity [
	self entity: (self notFoundReplacementEntity cull: self cull: aCurrentEntity)
]

{ #category : 'accessing' }
SRPathWithNode >> entity [
	^ entity
]

{ #category : 'accessing' }
SRPathWithNode >> entity: anObject [
	entity := anObject
]

{ #category : 'accessing' }
SRPathWithNode >> identifier [
	^ self path
]

{ #category : 'accessing' }
SRPathWithNode >> path [
	^ path
]

{ #category : 'accessing' }
SRPathWithNode >> path: anObject [
	path := anObject
]

{ #category : 'resolution' }
SRPathWithNode >> resolveInScope: aScope currentEntity: currentEntity [

	"We try to find the right folder and file."

	| folder pathToResolve |
	self flag: #todo. "Adapt to moose."
	folder := self rootFolder.
	self flag: #todo. "Check for Windows?"
	pathToResolve := self identifier splitOn: $/.

	[ pathToResolve size = 1 ] whileFalse: [ 
		folder := pathToResolve first = '..'
			          ifTrue: [ "We need to go up in the hierarchy" folder parentFolder ]
			          ifFalse: [ 
				          [ folder folders named: pathToResolve first ]
					          on: IMNoEntityNamed
					          do: [ NotFound signal ] ].
		pathToResolve := pathToResolve allButFirst.
		folder ifNil: [ NotFound signal ] ].

	self flag: #todo. "Manage case where we don't find it. For example if it's a system import"
	[ 
	entity := [ (folder files named: pathToResolve first) package ]
		          on: IMNoEntityNamed
		          do: [ 
			          self flag: #TODO. "This is to improve, we occult that many files can have the same name"
			          ('File import global search for path: ' , self identifier) record.
			          (currentEntity systemVersion files named: pathToResolve first) package ] ]
		on: IMNoEntityNamed
		do: [ NotFound signal ]
]

{ #category : 'accessing' }
SRPathWithNode >> rootFolder [
	^ rootFolder
]

{ #category : 'accessing' }
SRPathWithNode >> rootFolder: anObject [
	rootFolder := anObject
]
