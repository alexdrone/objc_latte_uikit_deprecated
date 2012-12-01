#import "TestData.h"

SPEC_BEGIN(LTViewSpecs)

describe(@"LTView is well constructed from a valid json markup", ^{
	
	__block LTNode *_node;
	
	beforeEach(^{
		_node = [[LTParser sharedInstance] parseMarkup:kLTViewSpecsData];
		[[LTParser sharedInstance] replaceCacheForFile:@"LTViewSpecs" withNode:_node];
		NSCache *cache = [[LTParser sharedInstance] valueForKey:@"cache"];
		
		[[cache should] beNonNil];
		[[[cache objectForKey:@"LTViewSpecs"] should] beNonNil];
		
		[[[[LTParser sharedInstance] parseFile:@"LTViewSpecs"] should] equal:_node];
	});
	
		
	it(@"should create a non-nil view", ^{
		LTView *view = [[LTView alloc] initWithLatteFile:@"LTViewSpecs"];
		[[view shouldNot] beNil];
	});
	
});







SPEC_END