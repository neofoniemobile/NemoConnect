//
//  NCNetworkSessionDataTask.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCNetworkSessionDataTask.h"
#import "NCNetworkRequest.h"
#import "NCDispatchFunctions.h"
#import "NCAuthentication.h"

@interface NCNetworkSessionDataTask () <NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, copy) NCNetworkCallback callbackBlock;
@property (nonatomic, strong) NCNetworkRequest *networkRequest;

@end

@implementation NCNetworkSessionDataTask

- (id)initWithRequest:(NCNetworkRequest *)request session:(NSURLSession *)session completionBlock:(NCNetworkCallback)completionBlock
{
    self = [super init];

    if (self)
    {
        self.callbackBlock = completionBlock;
        self.networkRequest = request;
        self.session = session;

        [self prepareTask];
    }

    return self;
}

- (void)prepareTask
{
    NSURL *url = [NSURL URLWithString:self.networkRequest.path];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];

    // set network header filed
    [self.networkRequest.headerDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *__unused stop) {
        [urlRequest setValue:value forHTTPHeaderField:key];
    }];

    if (self.networkRequest.bodyObject)
    {
        [urlRequest setHTTPBody:self.networkRequest.bodyObject];
    }
    [urlRequest setHTTPMethod:self.networkRequest.type];

    self.task = [self.session dataTaskWithRequest:urlRequest];
}

- (void)cancel
{
    [self.task cancel];
}

- (void)main
{
    if (self.isCancelled)
    {
        return;
    }

    @autoreleasepool {
        [self.task resume];
    }
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
