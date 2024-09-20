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
		"Dependencies"
		self mocketry: spec.
		
		 "Packages"
		spec
			package: 'SymbolResolver';
			package: 'SymbolResolver-Tests' with: [ spec requires: #( 'SymbolResolver' 'Mocketry' ) ].

		"Groups"
		spec
			group: 'Core' with: #( 'SymbolResolver' );
			group: 'Tests' with: #( 'SymbolResolver-Tests' ) ]
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
