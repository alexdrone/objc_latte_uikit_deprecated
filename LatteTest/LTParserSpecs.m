SPEC_BEGIN(LTParserSpecs)

describe(@"LTParser parses JSONs", ^{
    
    it(@"should parse a valid json file", ^{

        LTNode *node = [[LTParser sharedInstance] parseFile:@"Test"];
        [[node should] beNonNil];
    });
    
});


SPEC_END

