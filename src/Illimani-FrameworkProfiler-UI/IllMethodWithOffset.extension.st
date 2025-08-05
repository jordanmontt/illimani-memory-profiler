Extension { #name : 'IllMethodWithOffset' }

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllMethodWithOffset >> inspector: aBuilder [

	<inspectorPresentationOrder: 0 title: 'Method code'>
	^ self inspectorPresenter
]

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllMethodWithOffset >> inspectorPresenter [

	| interval codePresenter |
	interval := (compiledMethodOrBlock sourceNode sourceNodeForPC: offset) sourceInterval.
	codePresenter := SpCodePresenter new
		  beForBehavior: compiledMethodOrBlock methodClass;
		  text: compiledMethodOrBlock sourceCode;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (interval first to: interval last + 1);
				   yourself);
		  beNotEditable;
		  yourself.
	^ SpPresenter new
			layout: (SpBoxLayout newTopToBottom
				spacing: 3;
				add: (SpTextPresenter new
					text: self name;
					beNotEditable;
					yourself)
				expand: false;
				add: codePresenter;
				yourself);
		yourself.
]
