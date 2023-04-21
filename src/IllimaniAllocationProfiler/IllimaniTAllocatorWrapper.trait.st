Trait {
	#name : #IllimaniTAllocatorWrapper,
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'proxyArrobas',
		'proxyArrayClass'
	],
	#category : #'IllimaniAllocationProfiler-Profiler'
}

{ #category : #initialization }
IllimaniTAllocatorWrapper >> initializeMethodProxies: aHandler [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: aHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: aHandler.
	proxyArrobas := MpMethodProxy onMethod: Number >> #@ handler: aHandler.
	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: aHandler
]

{ #category : #evaluating }
IllimaniTAllocatorWrapper >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install.
	proxyArrayClass install
]

{ #category : #api }
IllimaniTAllocatorWrapper >> profileFor: aDuration [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forDuration: aDuration) wait.
	self stopProfiling ] fork
]

{ #category : #evaluating }
IllimaniTAllocatorWrapper >> profileOn: aBlock [

	self startProfiling.
	"The nil at the end is necessary because else the value of the block is referenced inside
	the ensure: method. We don't want to keep the reference because it avoids the object from
	being garbage collected"
	[
	aBlock value.
	nil ] ensure: [ self stopProfiling ]
]

{ #category : #evaluating }
IllimaniTAllocatorWrapper >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall.
	proxyArrayClass uninstall
]
