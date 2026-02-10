Extension { #name : 'IllMethodWithOffset' }

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllMethodWithOffset >> inspector: aBuilder [

    <inspectorPresentationOrder: 0 title: 'Method code'>
    | codePresenter |
    codePresenter := self inspectorPresenter: aBuilder.
    ^ aBuilder newPresenter
          layout: (SpBoxLayout newTopToBottom
                   spacing: 3;
                   add: (aBuilder newText
                       text: (self name, ' with offset: ', self offset asString);
                       beNotEditable;
                       yourself)
                   expand: false;
                   add: codePresenter;
                   yourself);
          yourself
]

{ #category : '*Illimani-FrameworkProfiler-UI' }
IllMethodWithOffset >> inspectorPresenter: aBuilder [

	| interval codePresenter |
	interval := (compiledMethodOrBlock sourceNode sourceNodeForPC: offset) sourceInterval.
	codePresenter := aBuilder newCode
		  beForBehavior: compiledMethodOrBlock methodClass;
		  text: compiledMethodOrBlock sourceCode;
		  addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
				   interval: (interval first to: interval last + 1);
				   yourself);
		  beNotEditable;
		  yourself.
	^ codePresenter
]
