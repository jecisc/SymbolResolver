"
I am a scope that contains and returns all the reachable entities. I am ignored considering the current entity level.
"
Class {
	#name : 'SRCollectionScope',
	#superclass : 'SRScope',
	#instVars : [
		'reachableEntities'
	],
	#category : 'SymbolResolver-Scopes',
	#package : 'SymbolResolver',
	#tag : 'Scopes'
}

{ #category : 'instance creation' }
SRCollectionScope class >> reachableEntities: aCollection [
	^ self new
		reachableEntities: aCollection;
		yourself
]

{ #category : 'accessing' }
SRCollectionScope >> reachableEntities [
	^ reachableEntities
]

{ #category : 'accessing' }
SRCollectionScope >> reachableEntities: anObject [
	reachableEntities := anObject
]
