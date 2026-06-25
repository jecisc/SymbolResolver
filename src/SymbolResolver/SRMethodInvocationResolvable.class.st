"
I resolve invocations or instantiations in the form of `y.x()` when I'm sure  `y` is an instance.

To be used, my stack of scopes needs to contain a class (answering true to #isClass).
"
Class {
	#name : 'SRMethodInvocationResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier'
	],
	#category : 'SymbolResolver-Core',
	#package : 'SymbolResolver',
	#tag : 'Core'
}

{ #category : 'instance creation' }
SRMethodInvocationResolvable class >> identifier: anIdentifierString [

	^ self new
		  identifier: anIdentifierString;
		  yourself
]

{ #category : 'accessing' }
SRMethodInvocationResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
SRMethodInvocationResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'resolution' }
SRMethodInvocationResolvable >> resolveInScope: aScope currentEntity: currentEntity [

	| reacheableClasses candidates |
	reacheableClasses := aScope entity withAllContainers flatCollect: [ :entity | entity reachableEntities select: #isClass ].
	candidates := OrderedCollection new.

	reacheableClasses do: [ :class |
			self flag: #todo. "Should be #allMethods"
			class methods
				detect: [ :method | method name = identifier ]
				ifFound: [ :method | candidates add: method ] ].

	candidates ifNotEmpty: [ ^ self result: candidates ].

	SRNoResolutionPossible signal
]
