//
//  NSData+CatchContainer.h
//  Mindvallytest
//
//  Created by Cipher on 15/07/16.
//  Copyright (c) 2016 test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (CatchContainer)

+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block;

+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block
             needCache:(BOOL)needCache;
@end
