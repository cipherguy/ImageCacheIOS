//
//  NSData+CatchContainer.m
//  Mindvallytest
//
//  Created by Cipher on 15/07/16.
//  Copyright (c) 2016 test. All rights reserved.
//

#import "NSData+CatchContainer.h"
#import "CacheContainer.h"


@implementation NSData (CatchContainer)
+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block
{
    return [NSData getDataFromURL:url toBlock:block needCache:YES];
}

+ (void)getDataFromURL:(NSURL *)url
               toBlock:(void(^)(NSData * data, BOOL * retry))block
             needCache:(BOOL)needCache
{
    static CacheContainer * cache;
    static NSOperationQueue * mainQueue;
    static NSOperationQueue * parallelQueue;
    static NSMutableDictionary * blocksDict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[CacheContainer alloc] initWithName:@"catchcontainer" Size:100];//setsize and name of catach
        mainQueue = [[NSOperationQueue alloc] init];
        mainQueue.maxConcurrentOperationCount = 1;
        parallelQueue = [[NSOperationQueue alloc] init];
        parallelQueue.maxConcurrentOperationCount = 64;
        blocksDict = [NSMutableDictionary dictionary];
        
        NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
        [NSURLCache setSharedURLCache:URLCache];
    });
    
    if (url == nil && block == nil)
        return [cache removeAllObjects];
    
    if (url == nil)
        return;
    
    NSData * object = [cache objectForKey:url.absoluteString];
    if (needCache && object)
    {
        BOOL retry = NO;
        block(object, &retry);
        if (!retry)
            return;
    }
    
    [mainQueue addOperationWithBlock:^{
        NSMutableArray * blocks = blocksDict[url];
        if (blocks == nil)
        {
            blocks = [NSMutableArray array];
            blocksDict[url] = blocks;
        }
        
        [blocks addObject:((id)block ?: (id)[NSNull null])];
        if (blocks.count != 1)
            return;
        
        [parallelQueue addOperationWithBlock:^
         {
             [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:mainQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError)
              {
                  if (data && needCache)
                      [cache setObject:data forKey:url.absoluteString];
                  
                  for (id a in blocks)
                  {
                      void(^aBlock)(NSData *,BOOL *) = a;
                      if ((id)aBlock == [NSNull null])
                          continue;
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          BOOL retry = NO;
                          aBlock(data, &retry);
                          if (retry)
                              [NSData getDataFromURL:url toBlock:aBlock needCache:needCache];
                      });
                  }
                  [blocks removeAllObjects];
              }];
         }];
    }];
}

@end
