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
		
		LTNode *child = _node.children[0];
		[[child.data[kLTTagId] should] equal:@"l1"];
		


		
		
	});

    
});


SPEC_END

