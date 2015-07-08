//
//  NCNetworkSessionManagerDelegate.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCNetworkSessionManagerDelegate.h"
#import "NCDispatchFunctions.h"
#import "NCFileManager.h"

@interface NCNetworkSessionManagerDelegate ()

@property (nonatomic, copy) NCNetworkCallback completionBlock;
@property (nonatomic, copy) NCNetworkDownloaderProgressBlock progressBlock;
@property (nonatomic, strong) NCNetworkSessionManager *sessionManager;

@end

@implementation NCNetworkSessionManagerDelegate

- (id)initWithSessionManager:(NCNetworkSessionManager *)sessionManager completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock
{
    NSParameterAssert(sessionManager);
    NSParameterAssert(completionBlock);

    self = [super init];

    if (self)
    {
        self.sessionManager = sessionManager;
        self.completionBlock = completionBlock;
        self.progressBlock = progressBlock;
    }

    return self;
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didSendBodyData:(int64_t)bytesSent totalBytesSent:(int64_t)totalBytesSent totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    if (self.progressBlock) // the progress block is optional, we do not need to assert in here
    {
        float progress = (double)totalBytesSent / (double)totalBytesExpectedToSend;

        if (progress < 0)
        {
            progress = 0;
        }

        if (progress > 1)
        {
            progress = 1;
        }

        self.progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSParameterAssert(self.completionBlock);

    if ([task isKindOfClass:[NSURLSessionUploadTask class]])
    {
        [NCFileManager removeDataFileFromTemporaryFolderWithName:task.taskDescription];
    }

    if (error)
    {
        NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)task.response;

        self.completionBlock(nil, error, httpURLResponse);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSParameterAssert(self.completionBlock);

    NSData *data = [NSData dataWithContentsOfURL:location];

    NSHTTPURLResponse *httpURLResponse = (NSHTTPURLResponse *)downloadTask.response;

    self.completionBlock(data, nil, httpURLResponse);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSAssert(NO, @"Not finished delegate method implementation. Resume a partially downloaded data is not supported yet!");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    if (self.progressBlock) // progress block is optional, do not need to assert
    {
        float progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;

        // The OS calls it with totalBytesExpectedToWrite = -1
        if (progress < 0)
        {
            progress = 0;
        }

        if (progress > 1)
        {
            progress = 1;
        }

        self.progressBlock(progress);
    }
}

#pragma mark - NSURLSessionDataTaskDelegate methods

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveResponse:(NSURLResponse *)response
    completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    // transform data task to download task
    completionHandler(NSURLSessionResponseBecomeDownload);
}

@end
