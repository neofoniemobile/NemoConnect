//
//  NCNetworkSessionDownloadTask.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCNetworkSessionDownloadTask.h"
#import "NCNetworkRequest.h"
#import "NCDispatchFunctions.h"
#import "NSString+HTTPQueryString.h"

@interface NCNetworkSessionDownloadTask ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, copy) NCNetworkCallback callbackBlock;
@property (nonatomic, copy) NCNetworkDownloaderProgressBlock progressBlock;
@property (nonatomic, strong) NCNetworkRequest *networkRequest;

@end

@implementation NCNetworkSessionDownloadTask

- (id)initWithRequest:(NCNetworkRequest *)request session:(NSURLSession *)session completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock
{
    self = [super init];

    if (self)
    {
        self.networkRequest = request;
        self.session = session;
        self.callbackBlock = completionBlock;
        self.progressBlock = progressBlock;

        [self prepareTask];
    }

    return self;
}

- (void)prepareTask
{
    NSURL *requestURL = [NSURL URLWithString:self.networkRequest.path];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:requestURL];

    if (self.networkRequest.bodyObject && !self.networkRequest.parametersDictionary)
    {
        [urlRequest setHTTPBody:self.networkRequest.bodyObject];
    }

    if (self.networkRequest.parametersDictionary)
    {
        if (![urlRequest valueForHTTPHeaderField:@"Content-Type"])
        {
            [urlRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        }
        NSData *bodyData = [[NSString HTTPQueryStringWithParameters:self.networkRequest.parametersDictionary] dataUsingEncoding:NSUTF8StringEncoding];
        [urlRequest setHTTPBody:bodyData];
    }

    [urlRequest setHTTPMethod:self.networkRequest.type];

    self.task = [self.session downloadTaskWithRequest:urlRequest];
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

- (void)cancel
{
    __weak typeof(self) weakSelf = self;

    [(NSURLSessionDownloadTask *)self.task cancelByProducingResumeData :^(NSData *resumeData) {

        __strong typeof(self) strongSelf = weakSelf;

        if (strongSelf.callbackBlock)
        {
            dispatchOnMainQueue (^{
                    strongSelf.callbackBlock(resumeData, nil, nil);
                });
        }
    }];
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
