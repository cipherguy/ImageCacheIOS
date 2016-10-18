//
//  MindvallytestTests.m
//  MindvallytestTests
//
//  Created by Cipher on 15/07/16.
//  Copyright (c) 2016 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CacheContainer.h"

@interface MindvallytestTests : XCTestCase

@end

@implementation MindvallytestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testAddition {
    // This is an example of a functional test case.
    
    CacheContainer *cache = [[CacheContainer alloc] initWithName:@"catchcontainer" Size:3];//setsize and name of catach
    
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image1"];
    
    NSData * object = [cache objectForKey:@"image1"];

    
    XCTAssert(object, @"Pass");
}


- (void)testEvecuate{
    // This is an example of a functional test case.
    
    CacheContainer *cache = [[CacheContainer alloc] initWithName:@"catchcontainer" Size:2];//setsize and name of catach
    
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image1"];
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image2"];
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image3"];

    NSData * object = [cache objectForKey:@"image1"];
    if(!object)
        NSLog(@"%@",@"Fail");
    
    
    XCTAssert(object, @"Pass");
}

- (void)testClearAllData{
    // This is an example of a functional test case.
    
    CacheContainer *cache = [[CacheContainer alloc] initWithName:@"catchcontainer" Size:2];//setsize and name of catach
    
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image1"];
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image2"];
    [cache setObject:UIImageJPEGRepresentation([UIImage imageNamed:@"mail-loading"], 3.0f) forKey:@"image3"];
    
    [cache removeAllObjects];
    
    
  XCTAssert(YES, @"Pass");
}


@end
