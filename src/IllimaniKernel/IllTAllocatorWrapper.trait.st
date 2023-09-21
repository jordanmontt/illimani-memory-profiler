"
I am a trait that contains the basic behavior to wrap and intercept the allocator methods of Pharo. I am used by the specific profilers
"
Trait {
	#name : 'IllTAllocatorWrapper',
	#instVars : [
		'proxyBasicNew',
		'proxyBasicNewKeyword',
		'proxyArrobas',
		'proxyArrayClass',
		'beginningOfProfilingTime',
		'incrementalGCCount',
		'fullGCCount',
		'totalGCTime',
		'endOfProfilingTime'
	],
	#category : 'IllimaniKernel',
	#package : 'IllimaniKernel'
}

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> beginningOfProfilingTime [

	^ beginningOfProfilingTime
]

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> endOfProfilingTime [

	^ endOfProfilingTime
]

{ #category : 'api' }
IllTAllocatorWrapper >> forceUninstall [
	"Warning, do not use unless you cannot start the profiler because you have the
	MpCannotInstall exception"

	MpMethodProxy allInstances do: #uninstall
]

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> fullGCCount [

	^ fullGCCount
]

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> incrementalGCCount [

	^ incrementalGCCount
]

{ #category : 'initialization' }
IllTAllocatorWrapper >> initializeMethodProxies: aHandler [

	proxyBasicNew := MpMethodProxy onMethod: Behavior >> #basicNew handler: aHandler.
	proxyBasicNewKeyword := MpMethodProxy onMethod: Behavior >> #basicNew: handler: aHandler.

	"Not wrapping the method Number>>#@ because is always by far the must allocator method and
	it pollutes the results."
	proxyArrobas := MpNullMethodProxy onMethod: Number >> #@ handler: aHandler.

	proxyArrayClass := MpMethodProxy onMethod: Array class >> #new: handler: aHandler
]

{ #category : 'profiling' }
IllTAllocatorWrapper >> initializeProfilingBasicStats [

	beginningOfProfilingTime := Time microsecondClockValue.
	incrementalGCCount := Smalltalk vm incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount.
	totalGCTime := Duration milliSeconds: Smalltalk vm totalGCTime
]

{ #category : 'profiling' }
IllTAllocatorWrapper >> installMethodProxies [

	proxyBasicNew install.
	proxyBasicNewKeyword install.
	proxyArrobas install.
	proxyArrayClass install
]

{ #category : 'testing' }
IllTAllocatorWrapper >> isProfilingFinished [

	^ endOfProfilingTime isNotNil
]

{ #category : 'testing' }
IllTAllocatorWrapper >> isProfilingStarted [

	^ beginningOfProfilingTime isNotNil
]

{ #category : 'api' }
IllTAllocatorWrapper >> profileFor: aDuration [
	"Done with a fork because we don't want to block the ui thread since it allocates objects. "

	self startProfiling.
	[
	(Delay forDuration: aDuration) wait.
	self stopProfiling ] fork
]

{ #category : 'api' }
IllTAllocatorWrapper >> profileOn: aBlock [

	self startProfiling.
	"The nil at the end is necessary because else the value of the block is referenced inside
	the ensure: method. We don't want to keep the reference because it avoids the object from
	being garbage collected"
	[
	aBlock value.
	nil ] ensure: [ self stopProfiling ]
]

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> totalGCTime [

	^ totalGCTime
]

{ #category : 'accessing - statistics' }
IllTAllocatorWrapper >> totalProfiledTime [

	^ endOfProfilingTime - beginningOfProfilingTime
]

{ #category : 'profiling' }
IllTAllocatorWrapper >> uninstallMethodProxies [

	proxyBasicNew uninstall.
	proxyBasicNewKeyword uninstall.
	proxyArrobas uninstall.
	proxyArrayClass uninstall
]

{ #category : 'profiling' }
IllTAllocatorWrapper >> updateStatsWhenFinishingProfiling [

	endOfProfilingTime := Time microsecondClockValue.
	incrementalGCCount := Smalltalk vm incrementalGCCount - incrementalGCCount.
	fullGCCount := Smalltalk vm fullGCCount - fullGCCount.
	totalGCTime := (Duration milliSeconds: Smalltalk vm totalGCTime) - totalGCTime
]
