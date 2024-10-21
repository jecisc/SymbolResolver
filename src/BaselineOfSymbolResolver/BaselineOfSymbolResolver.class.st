"
I am a baseline to define the structure and dependencies of the SymbolResolver project.
"
Class {
	#name : 'BaselineOfSymbolResolver',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfSymbolResolver',
	#package : 'BaselineOfSymbolResolver'
}

{ #category : 'baselines' }
BaselineOfSymbolResolver >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Dependencies"
		self mocketry: spec.

		"Packages"
		spec
			package: 'SymbolResolver';
			package: 'SymbolResolver-Tests' with: [ spec requires: #( 'SymbolResolver' 'Mocketry' ) ];
			package: 'SymbolResolver-Moose'.

		"Groups"
		spec
			group: 'Core' with: #( 'SymbolResolver' );
			group: 'Moose' with: #( 'SymbolResolver-Moose' );
			group: 'Tests' with: #( 'SymbolResolver-Tests' ) ].

	spec for: #NoFamix do: [
		self famix: spec.
		spec package: 'SymbolResolver-Moose' with: [ spec requires: #( 'Famix' ) ] ]
]

{ #category : 'accessing' }
BaselineOfSymbolResolver >> customProjectAttributes [

	'BaselineOfFamix' asPackageIfAbsent: [ ^ #( #NoFamix ) ].
	^ #( #WithFamix )
]

{ #category : 'dependencies' }
BaselineOfSymbolResolver >> famix: spec [

	spec baseline: 'Famix' with: [ spec repository: 'github://moosetechnology/Famix:development/src' ]
]

{ #category : 'dependencies' }
BaselineOfSymbolResolver >> mocketry: spec [

	spec baseline: 'Mocketry' with: [
		spec
			loads: #( 'Core' );
			repository: 'github://dionisiydk/Mocketry:v7.0.2' ]
]

{ #category : 'accessing' }
BaselineOfSymbolResolver >> projectClass [
	^ MetacelloCypressBaselineProject
]
