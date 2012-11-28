#import "TestData.h"

SPEC_BEGIN(LTParserSpecs)

describe(@"LTParser parses valid JSON", ^{
    
	__block LTNode *_node;
	
	beforeEach(^{
		_node = [[LTParser sharedInstance] parseMarkup:kTestJSONMarkup];
	});
	
	it(@"should parse some valid latte json markup", ^{
		[[_node should] beNonNil];
	});
	
	it(@"should cache the parsed markups", ^{
		[[LTParser sharedInstance] replaceCacheForFile:@"TestData" withNode:_node];
		NSCache *cache = [[LTParser sharedInstance] valueForKey:@"cache"];
		
		[[cache should] beNonNil];
		[[[cache objectForKey:@"TestData"] should] beNonNil];
		
		[[[[LTParser sharedInstance] parseFile:@"TestData"] should] equal:_node];
	});
	
	it(@"should create a node with the correct structure", ^{
		
		[[theValue(_node.children) should] beNonNil];
		[[theValue(_node.children.count) should] equal:theValue(2)];
		
		//makes sure that the hierarchy is respected
		LTNode *child = _node.children[0];
		[[child.data[kLTTagId] should] equal:@"l1"];
		
		child = child.children[0];
		[[child.data[kLTTagId] should] equal:@"image1"];
		
		[[theValue(child.children.count) should] equal:theValue(0)];

		child = _node.children[1];
		[[child.data[kLTTagId] should] equal:@"l2"];
		
		[[theValue(child.children.count) should] equal:theValue(0)];
	});
	
	it(@"should parse the constraints", ^{
		
		//the constraints are parse and added only to the root node
		[[_node.constraints should] beNonNil];
		[[theValue(_node.constraints.count) should] equal:theValue(3)];

		//the children nodes should not have any constraints
		LTNode *child = _node.children[0];
		[[theValue(child.constraints.count) should] equal:theValue(0)];
	});

	it(@"should parse the bindings", ^{
		
		//l1
		LTNode *child = _node.children[0];
		
		//the text is "the value is #{@bind(object.foo)}."
		[[child.data[@"text"] should] beKindOfClass:NSClassFromString(@"LTKVOTemplate")];

		//inspecting the LTKVOTemplate
		NSString *template = [child.data[@"text"] valueForKey:@"template"];
		NSArray *keypaths = [child.data[@"text"] valueForKey:@"keypaths"];
		NSArray *flags = [child.data[@"text"] valueForKey:@"flags"];
		
		[[template should] equal:@"the value is %@."];
		[[theValue(keypaths.count) should] equal:theValue(1)];
		[[theValue(flags.count) should] equal:theValue(1)];
		
		[[keypaths[0] should] equal:@"object.foo"];
		
		[[flags[0] should] equal:theValue(LTBindOptionBound)];
		
		//l2
		child = _node.children[1];
		
		//the text is "Hello #{object.foo} and #{@bind(object.bar)}"
		[[child.data[@"text"] should] beKindOfClass:NSClassFromString(@"LTKVOTemplate")];
		
		//inspecting the LTKVOTemplate
		template = [child.data[@"text"] valueForKey:@"template"];
		keypaths = [child.data[@"text"] valueForKey:@"keypaths"];
		flags = [child.data[@"text"] valueForKey:@"flags"];
		
		[[template should] equal:@"Hello %@ and %@"];
		[[theValue(keypaths.count) should] equal:theValue(2)];
		[[theValue(flags.count) should] equal:theValue(2)];
		
		[[keypaths[0] should] equal:@"object.foo"];
		[[keypaths[1] should] equal:@"object.bar"];

		[[flags[0] should] equal:theValue(LTBindOptionNone)];
		[[flags[1] should] equal:theValue(LTBindOptionBound)];
		
		//image1
		child = [_node.children[0] children][0];
		
		//no bindings here
		for (NSString *key in child.data)
			[[child.data[key] shouldNot] beKindOfClass:NSClassFromString(@"LTKVOTemplate")];

	});

	it(@"should parse the context evaluations", ^{
	
		//l1
		LTNode *child = _node.children[0];
		
		//the property hidden is "@context-value(hide)"
		[[child.data[@"hidden"] should] beKindOfClass:NSClassFromString(@"LTContextValueTemplate")];
		[[[child.data[@"hidden"] valueForKey:@"keypath"] should] equal:@"hide"];
	});
	
	it(@"should parses colors, fonts and images", ^{
		
		//l1
		LTNode *child = _node.children[0];
		
		//@color-hex:00abb0
		[[child.data[@"backgroundColor"] should] equal:LTHexUIColor(0x00abb0)];
		
		//@color:white
		[[child.data[@"textColor"] should] equal:[UIColor whiteColor]];
	});
	
    
});


SPEC_END

