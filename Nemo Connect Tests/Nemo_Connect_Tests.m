//
//  Nemo_Connect_Tests.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import <XCTest/XCTest.h>
#import "NCWebService+Test.h"

@interface Nemo_Connect_Tests : XCTestCase

@end

@implementation Nemo_Connect_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testURLParsing
{
    NCWebService *webService = [[NCWebService alloc] initWithBaseURL:[NSURL URLWithString:@"http://test.test"]];
    XCTestExpectation *expectation = [self expectationWithDescription:@"test URL Parsing"];

    webService.serviceName = @"Test";
    NSOperation *operation = [webService testCallWithParameter:@(1) completionBlock:^(id data, NSError *const error, NSHTTPURLResponse *httpURLResponse) {
        NSLog(@"%@", httpURLResponse);
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:60 handler:^(NSError *error) {
        if (error != nil)
        {
            NSLog(@"Error: %@", error.localizedDescription);
        }
        [operation cancel];
    }];
}

@end
