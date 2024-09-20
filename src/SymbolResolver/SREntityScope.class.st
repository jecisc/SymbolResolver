"
I am a scope that contains one entity. I will return all the reachable entities from the entity i contain if i am asked to. But i will be ignored concerning current entity
"
Class {
	#name : 'SREntityScope',
	#superclass : 'SRScope',
	#instVars : [
		'entity',
		'isCurrentEntity',
		'isMainEntity'
	],
	#category : 'SymbolResolver-Scopes',
	#package : 'SymbolResolver',
	#tag : 'Scopes'
}

{ #category : 'accessing' }
SREntityScope class >> currentEntity: anEntity [
	^ self new
		entity: anEntity;
		isCurrentEntity: true;
		yourself
]

{ #category : 'accessing' }
SREntityScope class >> entity: anEntity [
	^ self new
		entity: anEntity;
		isCurrentEntity: false;
		yourself
]

{ #category : 'accessing' }
SREntityScope >> currentEntity [
	self assert: self isCurrentEntity description: 'This entity scope should be the current entity when this method is called.'.
	^ self entity
]

{ #category : 'accessing' }
SREntityScope >> entity [
	^ entity
]

{ #category : 'accessing' }
SREntityScope >> entity: anObject [
	entity := anObject
]

{ #category : 'accessing' }
SREntityScope >> hasCurrentEntity [
	^ self isCurrentEntity
]

{ #category : 'initialization' }
SREntityScope >> initialize [
	super initialize.
	self isCurrentEntity: false.
	self isMainEntity: false.
]

{ #category : 'accessing' }
SREntityScope >> isCurrentEntity [
	^ isCurrentEntity
]

{ #category : 'accessing' }
SREntityScope >> isCurrentEntity: anObject [
	isCurrentEntity := anObject
]

{ #category : 'accessing' }
SREntityScope >> isEntityScope [
	^ true
]

{ #category : 'accessing' }
SREntityScope >> isMainEntity [
	^ isMainEntity
]

{ #category : 'accessing' }
SREntityScope >> isMainEntity: anObject [
	isMainEntity := anObject
]

{ #category : 'printing' }
SREntityScope >> printOn: aStream [
	super printOn: aStream.
	aStream << $(.
	aStream << $".
	entity
		ifNil: [ aStream << 'No Entity' ]
		ifNotNil: [ entity name printOn: aStream.
			aStream << '":'.
			entity class printOn: aStream ].
	aStream << $)
]

{ #category : 'accessing' }
SREntityScope >> reachableEntitiesNamed: aString ofKinds: aCollection [
	^ self entity reachableEntitiesNamed: aString ofKinds: aCollection
]

{ #category : 'accessing' }
SREntityScope >> reachableEntitiesOwned [
	^ self entity reachableEntities
]
