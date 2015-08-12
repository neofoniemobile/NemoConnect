//
//  NCNetworkSessionUploadTask.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCWebService.h"
#import "NCNetworkSessionUploadTask.h"
#import "NCNetworkRequest.h"
#import "NCFileManager.h"
#import "NCNetworkPlistKeys.h"
#import "NCFileDescription.h"

@interface NCNetworkSessionUploadTask ()

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong, readwrite) NSURLSessionTask *task;
@property (nonatomic, copy) NCNetworkCallback callbackBlock;
@property (nonatomic, copy) NCNetworkDownloaderProgressBlock progressBlock;
@property (nonatomic, strong) NCNetworkRequest *networkRequest;

@end

@implementation NCNetworkSessionUploadTask

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

- (NSData *)prepareMultipartBodyWithBoundary:(NSString *)boundary files:(NSArray *)files parameters:(NSDictionary *)parameters
{
    NSString *bodyBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
    NSString *(^contentDisposition)(NSString *, NSString *) = ^NSString *(NSString *parameter, NSString *filename) {
        if (filename)
        {
            return [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", parameter, filename];
        }

        return [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameter];
    };

    NSMutableData *body = [NSMutableData data];

    for (NCFileDescription *fileDescription in files)
    {
        [body appendData:[bodyBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[contentDisposition(fileDescription.parameter, fileDescription.filename) dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", fileDescription.mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:fileDescription.fileContents];
    }

    for (NSString *parameter in parameters)
    {
        [body appendData:[bodyBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[contentDisposition(parameter, nil) dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[parameters[parameter] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[bodyBoundary dataUsingEncoding:NSUTF8StringEncoding]];

    return body;
}

- (void)prepareTask
{
    NSString *contentType;

    if (self.networkRequest.parametersDictionary || self.networkRequest.filesArray)
    {
        NSString *const boundary = [NCFileManager uniqueNameWithNumberOfCharacters:16];
        contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        self.networkRequest.bodyObject = [self prepareMultipartBodyWithBoundary:boundary files:self.networkRequest.filesArray parameters:self.networkRequest.parametersDictionary];
    }
    else
    {
        contentType = @"application/octet-stream";
    }

    NSString *name = [self createTempFileName];

    NSURL *fullPath = [NCFileManager saveDataToTemporaryFolder:self.networkRequest.bodyObject name:name];

    uint64_t bytesTotalForThisFile = [self.networkRequest.bodyObject length];

    NSURL *url = [NSURL URLWithString:self.networkRequest.path];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];

    [urlRequest setHTTPMethod:kNCWebServiceRequestTypePost];
    [urlRequest setValue:[NSString stringWithFormat:@"%llu", bytesTotalForThisFile] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [urlRequest setHTTPBody:self.networkRequest.bodyObject];

    // set network header files
    [self.networkRequest.headerDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *__unused stop) {
        [urlRequest setValue:value forHTTPHeaderField:key];
    }];

    self.task = [self.session uploadTaskWithRequest:urlRequest fromFile:fullPath];

    /**
     *  The name of the task/file should be a unique and based on this parameter
     *  we could identify and delete the temporary file
     */
    self.task.taskDescription = name;
}

- (NSString *)createTempFileName
{
    NSString *uniqueIdentifier = [NCFileManager uniqueNameWithNumberOfCharacters:6];

    NSString *fileName = [NSString stringWithFormat:@"%@%@.tmp", kNCNetworkSessionUploadTaskTempFilePrefix, uniqueIdentifier];

    return fileName;
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
    [self.task cancel];
}

- (BOOL)isConcurrent
{
    return YES;
}

@end
