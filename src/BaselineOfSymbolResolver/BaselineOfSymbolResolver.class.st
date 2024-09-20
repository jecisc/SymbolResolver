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
	spec for: #common do: [ "Packages"
		spec
			package: 'SymbolResolver';
			package: 'SymbolResolver-Tests' with: [ spec requires: #( 'SymbolResolver' ) ].

		"Groups"
		spec
			group: 'Core' with: #( 'SymbolResolver' );
			group: 'Tests' with: #( 'SymbolResolver-Tests' ) ]
]

{ #category : 'accessing' }
BaselineOfSymbolResolver >> projectClass [
	^ MetacelloCypressBaselineProject
]
