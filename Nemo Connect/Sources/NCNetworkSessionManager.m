//
//  NCNetworkSessionManager.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCNetworkSessionManager.h"
#import "NCNetworkSessionManagerDelegate.h"
#import "NCNetworkSessionDataTask.h"
#import "NCNetworkSessionDownloadTask.h"
#import "NCNetworkSessionUploadTask.h"

@interface NCNetworkSessionManager () <NSURLSessionDelegate>

@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfiguration;
@property (nonatomic, strong) NSMutableDictionary *taskDelegates;
@property (nonatomic, strong) id<NCAuthentication> authenticationProvider;

@end

@implementation NCNetworkSessionManager

- (id)initWithOperationQueue:(NSOperationQueue *)operationQueue sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration authenticationProvider:(id<NCAuthentication>)authenticationProvider
{
    self = [super init];

    if (self)
    {
        self.sessionConfiguration = sessionConfiguration;
        self.operationQueue = operationQueue;
        self.urlSession = [NSURLSession sessionWithConfiguration:self.sessionConfiguration delegate:self delegateQueue:self.operationQueue];
        self.authenticationProvider = authenticationProvider;
        self.taskDelegates = [[NSMutableDictionary alloc] init];
    }

    return self;
}

#pragma mark - Session task Operations factory methods

- (NSOperation *)sessionTaskOperationWithNetworkRequest:(NCNetworkRequest *)request completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock
{
    NSParameterAssert(request);
    NSParameterAssert(completionBlock);

    NSOperation *operation;

    if ([request.sessionType isEqualToString:kNCNetworkRequestSessionTaskTypeDownload])
    {
        operation = [self downloadOperationTaskWithNetworkRequest:request completionBlock:completionBlock progressBlock:progressBlock];
    }
    else if ([request.sessionType isEqualToString:kNCNetworkRequestSessionTaskTypeUpload])
    {
        operation = [self uploadOperationTaskWithNetworkRequest:request completionBlock:completionBlock progressBlock:progressBlock];
    }
    else
    {
        // Default operation is data task, kNCNetworkRequestSessionTaskTypeData
        operation = [self dataOperationTaskWithNetworkRequest:request completionBlock:completionBlock];
    }

    return operation;
}

- (NSOperation *)dataOperationTaskWithNetworkRequest:(NCNetworkRequest *)request completionBlock:(NCNetworkCallback)completionBlock
{
    NCNetworkSessionDataTask *dataTaskOperation = [[NCNetworkSessionDataTask alloc] initWithRequest:request session:self.urlSession completionBlock:completionBlock];

    NCNetworkSessionManagerDelegate *delegate = [[NCNetworkSessionManagerDelegate alloc] initWithSessionManager:self completionBlock:completionBlock progressBlock:nil];

    [self addDelegate:delegate forTask:dataTaskOperation.task];

    return dataTaskOperation;
}

- (NSOperation *)downloadOperationTaskWithNetworkRequest:(NCNetworkRequest *)request completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock
{
    NCNetworkSessionDownloadTask *downloadTaskOperation = [[NCNetworkSessionDownloadTask alloc] initWithRequest:request session:self.urlSession completionBlock:completionBlock progressBlock:progressBlock];

    NCNetworkSessionManagerDelegate *delegate = [[NCNetworkSessionManagerDelegate alloc] initWithSessionManager:self completionBlock:completionBlock progressBlock:progressBlock];

    [self addDelegate:delegate forTask:downloadTaskOperation.task];

    return downloadTaskOperation;
}

- (NSOperation *)uploadOperationTaskWithNetworkRequest:(NCNetworkRequest *)request completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock
{
    NCNetworkSessionUploadTask *uploadTaskOperation = [[NCNetworkSessionUploadTask alloc] initWithRequest:request session:self.urlSession completionBlock:completionBlock progressBlock:progressBlock];

    NCNetworkSessionManagerDelegate *delegate = [[NCNetworkSessionManagerDelegate alloc] initWithSessionManager:self completionBlock:completionBlock progressBlock:progressBlock];

    [self addDelegate:delegate forTask:uploadTaskOperation.task];

    return uploadTaskOperation;
}

#pragma mark - Delegate stack helper methods

- (void)addDelegate:(id)delegate forTask:(NSURLSessionTask *)task
{
    NSParameterAssert(delegate);
    NSParameterAssert(task);

    [self.taskDelegates setObject:delegate forKey:@(task.taskIdentifier)];
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);

    [self.taskDelegates removeObjectForKey:@(task.taskIdentifier)];
}

- (id)delegateForTask:(NSURLSessionTask *)task
{
    NSParameterAssert(task);

    return [self.taskDelegates objectForKey:@(task.taskIdentifier)];
}

#pragma mark - NSURLSessionDelegate methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    if (challenge.previousFailureCount == 0 && self.authenticationProvider)
    {
        if ([self.authenticationProvider respondsToSelector:@selector(processAuthenticationChallenge:)])
        {
            NSURLCredential *credential = [self.authenticationProvider processAuthenticationChallenge:challenge];

            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
        }
    }
    else
    {
        completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
}

#pragma mark - NSURLSessionDownloadDelegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:downloadTask];

    [delegate URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:downloadTask];

    [delegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
}

#pragma mark - NSURLSessionTaskDelegate methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:task];

    [delegate URLSession:session task:task didSendBodyData:bytesSent totalBytesSent:totalBytesSent totalBytesExpectedToSend:totalBytesExpectedToSend];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:task];

    [delegate URLSession:session task:task didCompleteWithError:error];

    [self removeDelegateForTask:task];
}

#pragma mark - NSURLSessionDataTaskDelegate methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveResponse:(NSURLResponse *)response
    completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:dataTask];

    [delegate URLSession:session dataTask:dataTask didReceiveResponse:response completionHandler:completionHandler];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:dataTask];

    if (delegate)
    {
        [self removeDelegateForTask:dataTask];
        [self addDelegate:delegate forTask:downloadTask];
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    NCNetworkSessionManagerDelegate *delegate = [self delegateForTask:dataTask];

    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

@end
