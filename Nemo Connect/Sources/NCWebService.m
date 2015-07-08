//
//  NCWebService.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCWebService.h"
#import "NCWebService+DynamicMethod.h"
#import "NCBasicAuthentication.h"
#import "NCAuthentication.h"
#import "NCNetworkSessionManager.h"

NSString *const kNCWebServiceRequestTypeGet = @"GET ";
NSString *const kNCWebServiceRequestTypePost = @"POST ";
NSString *const kNCWebServiceRequestTypePut = @"PUT ";
NSString *const kNCWebServiceRequestTypeDelete = @"DELETE ";
NSString *const kNCWebServiceRequestTypeTrace = @"TRACE ";
NSString *const kNCWebServiceRequestTypeHead = @"HEAD ";

@interface NCWebService ()

@property (nonatomic, strong, readwrite) NSOperationQueue *processingQueue;
@property (nonatomic, copy, readwrite) NSURL *serviceRootURL;
@property (nonatomic, strong, readwrite) NCNetworkSessionManager *sessionManager;
@property (nonatomic, strong, readwrite) id<NCAuthentication> authenticationProvider;

@end

@implementation NCWebService

- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration authenticationProvider:(id<NCAuthentication>)authenticationProvider
{
    NSParameterAssert(serviceRootURL);
    NSParameterAssert(processingQueue);
    NSParameterAssert(sessionConfiguration);

    self = [super init];

    if (self)
    {
        self.serviceRootURL = serviceRootURL;
        self.processingQueue = processingQueue;
        self.authenticationProvider = authenticationProvider;
        self.networkServices = [[NSMutableDictionary alloc] init];
        self.sessionManager = [[NCNetworkSessionManager alloc] initWithOperationQueue:self.processingQueue sessionConfiguration:sessionConfiguration authenticationProvider:self.authenticationProvider];
    }

    return self;
}

- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue authenticationProvider:(id<NCAuthentication>)authenticationProvider
{
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];

    return [self initWithBaseURL:serviceRootURL processingQueue:processingQueue sessionConfiguration:sessionConfiguration authenticationProvider:authenticationProvider];
}

- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue
{
    return [self initWithBaseURL:serviceRootURL processingQueue:processingQueue authenticationProvider:nil];
}

- (id)initWithBaseURL:(NSURL *)serviceRootURL
{
    NSOperationQueue *processingQueue = [NSOperationQueue currentQueue];

    return [self initWithBaseURL:serviceRootURL processingQueue:processingQueue];
}

+ (NSDictionary *)sharedHeaderDictionary
{
    static NSDictionary *headerDictionary = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        headerDictionary =  [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:NSStringFromClass([self class]) ofType:@"plist"]];

        if (!headerDictionary)
        {
            headerDictionary = @{};
        }
    });

    return headerDictionary;
}

@end