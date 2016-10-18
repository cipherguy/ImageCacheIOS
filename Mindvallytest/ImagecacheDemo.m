//
//  Imagecache Demo.m
//  Mindvallytest
//
//  Created by Cipher on 15/07/16.
//  Copyright (c) 2016 test. All rights reserved.
//

#import "ImagecacheDemo.h"
#import "NSData+CatchContainer.h"
#import "SingleImageCell.h"

@interface Imagecache_Demo ()
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, assign) NSInteger totalItems;
@end

@implementation Imagecache_Demo

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos = [NSMutableArray new];
    [self loadPhotos:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (self.currentPage == self.totalPages
        || self.totalItems == self.photos.count) {
        return self.photos.count;
    }
    return self.photos.count + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     SingleImageCell *cell = nil;
    
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    if (indexPath.row == [self.photos count]) {
                
        
        
    } else {
        
        
        cell.Imageview.image = [UIImage imageNamed:@"mail-loading"];
        
        [NSData getDataFromURL:[self getImageURLfromDictionary:self.photos[indexPath.row]] toBlock:^(NSData *data, BOOL *retry) {
            NSLog(@"%ld  %@",(long)indexPath.row,[self getImageURLfromDictionary:self.photos[indexPath.row]]);
            if(data == nil)
            {
                *retry = YES;
            }
            cell.Imageview.image = [UIImage imageWithData:data];
        } needCache:YES];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 320.f;
}
-(NSURL*)getImageURLfromDictionary:(NSDictionary*)singleimage
{

    
    NSString *urlstring =[NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_%@.jpg",singleimage[@"farm"],singleimage[@"server"],singleimage[@"id"],singleimage[@"secret"],@"n"];
    
    return [NSURL URLWithString:urlstring];
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [self.photos count] - 1 ) {
        [self loadPhotos:++self.currentPage];
    }
}

- (void)loadPhotos:(NSInteger)page {
    
    NSString *apiURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=fe9ebb201b0c08a6f11d465960ff8be0&per_page=10&format=json&nojsoncallback=1&page=%ld",(long)page];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:apiURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                if (!error) {
                    
                    NSError *jsonError = nil;
                    NSMutableDictionary *jsonObject = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                    
                    NSLog(@"%@",jsonObject);
                    
                   [self.photos addObjectsFromArray:[(NSDictionary *)[jsonObject objectForKey:@"photos"] objectForKey:@"photo"]];
//                    
                    self.currentPage = [[(NSDictionary *)[jsonObject objectForKey:@"photos"] objectForKey:@"page"] integerValue];
                    self.totalPages  = [[(NSDictionary *)[jsonObject objectForKey:@"photos"] objectForKey:@"pages"] integerValue];
                   self.totalItems  = [[(NSDictionary *)[jsonObject objectForKey:@"photos"] objectForKey:@"total"] integerValue];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }
            }] resume];
}

-(void)getImageByPage:(int)page
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:@"flickr.interestingness.getList" forKey:@"method"];
    [params setValue:@"1bc4940306001d66bb88c08de26375b4" forKey:@"api_key"];
    [params setValue:@"10" forKey:@"per_page"];
    [params setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [params setValue:@"json" forKey:@"format"];
    [params setValue:@"1" forKey:@"nojsoncallback"];
    
    
    
    
    NSString *requesturl = @"https://api.flickr.com/services/rest/?method=flickr.interestingness.getList&api_key=fe9ebb201b0c08a6f11d465960ff8be0&per_page=10&format=json&nojsoncallback=1";
    NSURL *url = [NSURL URLWithString:requesturl];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
             NSLog(@"%@",dictionary);
         }];
    });
}


@end
