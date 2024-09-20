"
I am a scope that contains and returns all the reachable entities. I am ignored considering the current entity level.
"
Class {
	#name : 'SRCollectionScope',
	#superclass : 'SRScope',
	#instVars : [
		'reachableEntitiesOwned'
	],
	#category : 'SymbolResolver-Scopes',
	#package : 'SymbolResolver',
	#tag : 'Scopes'
}

{ #category : 'instance creation' }
SRCollectionScope class >> reachableEntities: aCollection [
	^ self new
		reachableEntitiesOwned: aCollection;
		yourself
]

{ #category : 'accessing' }
SRCollectionScope >> reachableEntitiesOwned [
	^ reachableEntitiesOwned
]

{ #category : 'accessing' }
SRCollectionScope >> reachableEntitiesOwned: anObject [
	reachableEntitiesOwned := anObject
]
