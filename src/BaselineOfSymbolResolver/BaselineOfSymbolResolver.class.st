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
	spec for: #common do: [
			"Packages"
			spec
				package: 'SymbolResolver';
				package: 'SymbolResolver-Tests' with: [ spec requires: #( 'SymbolResolver' ) ];
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

{ #category : 'accessing' }
BaselineOfSymbolResolver >> projectClass [
	^ MetacelloCypressBaselineProject
]
