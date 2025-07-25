"
I am a solver used to find local entities in a class. 

Typically, I'll be used to find methods or attributes invoked or accessed via a `this` or `self`. 

For example in Python:

```python
class AClass:
	def method(self):
		return 1
		
	def method2(self):
		return self.method() + 1
```

The `self.method()` invoke a local method to the AClass class. 

I can be used like this:

```st
receiver = 'self' ifTrue: [
	^ self
		resolve: (SRLocalClassEntityResolvable identifier: aName expectedKind: FamixTMethod)
		foundAction: [ :method :currentEntity | self createInvocationOf: method from: currentEntity node: aCallNode ] ].
```
"
Class {
	#name : 'SRLocalClassEntityResolvable',
	#superclass : 'SRResolvable',
	#instVars : [
		'identifier'
	],
	#category : 'SymbolResolver',
	#package : 'SymbolResolver'
}

{ #category : 'instance creation' }
SRLocalClassEntityResolvable class >> identifier: anIdentifierString expectedKind: aClassOrCollection [

	^ self new
		  identifier: anIdentifierString;
		  expectedKind: aClassOrCollection;
		  yourself
]

{ #category : 'accessing' }
SRLocalClassEntityResolvable >> identifier [

	^ identifier
]

{ #category : 'accessing' }
SRLocalClassEntityResolvable >> identifier: anObject [

	identifier := anObject
]

{ #category : 'resolution' }
SRLocalClassEntityResolvable >> resolveInScope: aScope currentEntity: currentEntity [
	"We just need to check the methods of the class."

	aScope entity isClass ifFalse: [ NotFound signal ].

	(aScope reachableEntitiesNamed: identifier ofKinds: self expectedKinds) ifNotEmpty: [ :entities | "I don't think we can have multiple results here."
			self assert: entities size = 1.
			^ self result: entities anyOne ].

	SRNoResolutionPossible signal
]
