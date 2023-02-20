"
I am a presenter for alternating one presenter with another
"
Class {
	#name : #AlternatorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'toggleChartButton',
		'activePresenter',
		'presenterTwo',
		'presenterOne',
		'isForPresenterOne',
		'presenterOneName',
		'presenterTwoName'
	],
	#category : #'AllocationProfiler-UI-Widgets'
}

{ #category : #api }
AlternatorPresenter >> beForPresenterOne [

	isForPresenterOne := true
]

{ #category : #api }
AlternatorPresenter >> beForPresenterTwo [

	isForPresenterOne := false
]

{ #category : #initialization }
AlternatorPresenter >> connectPresenters [

	toggleChartButton action: [ self switchActivePresenter ]
]

{ #category : #layout }
AlternatorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 5;
		  add: (SpBoxLayout newLeftToRight
				   add: toggleChartButton;
				   yourself)
		  expand: false;
		  add: activePresenter expand: true;
		  yourself
]

{ #category : #initialization }
AlternatorPresenter >> initialize [

	isForPresenterOne := true.
	super initialize
]

{ #category : #initialization }
AlternatorPresenter >> initializePresenters [

	toggleChartButton := self newButton
		label: self labelForToggleButton;
		iconName: #glamorousOver;
		yourself.
	activePresenter := self newPresenter
]

{ #category : #accessing }
AlternatorPresenter >> labelForToggleButton [

	^ isForPresenterOne ifTrue: [ 'Switch to ' , self presenterTwoName ]
		  ifFalse: [ 'Switch to ', self presenterOneName  ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterOne: aPresenter [

	presenterOne := aPresenter.
	isForPresenterOne ifTrue: [ activePresenter := presenterOne ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterOne: aPresenter withName: aName [

	presenterOne := aPresenter.
	presenterOneName := aName.
	isForPresenterOne ifTrue: [ activePresenter := presenterOne ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterOneName [

	^ presenterOneName ifNil: [ 'Presenter 1' ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterOneName: aString [

	presenterOneName := aString.
	self updateButtonLabel
]

{ #category : #accessing }
AlternatorPresenter >> presenterTwo: aPresenter [

	presenterTwo := aPresenter.
	isForPresenterOne ifFalse: [ activePresenter := presenterTwo ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterTwo: aPresenter withName: aName [

	presenterTwo := aPresenter.
	presenterTwoName := aName.
	isForPresenterOne ifFalse: [ activePresenter := presenterTwo ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterTwoName [

	^ presenterTwoName ifNil: [ 'Presenter 2' ]
]

{ #category : #accessing }
AlternatorPresenter >> presenterTwoName: aString [

	presenterTwoName := aString.
	self updateButtonLabel
]

{ #category : #actions }
AlternatorPresenter >> switchActivePresenter [

	isForPresenterOne := isForPresenterOne not.
	activePresenter := isForPresenterOne ifTrue: [ presenterOne ]
		                   ifFalse: [ presenterTwo ].
	self updateButtonLabel.
	self layout: self defaultLayout
]

{ #category : #actions }
AlternatorPresenter >> updateButtonLabel [

	toggleChartButton label: self labelForToggleButton
]
