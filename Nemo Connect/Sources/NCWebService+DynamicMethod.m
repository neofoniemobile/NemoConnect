//
//  NCWebService+DynamicMethod.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import ObjectiveC;

#import "NCWebService+DynamicMethod.h"
#import "NCWebService+Extensions.h"
#import "NCWebServiceParameterParser.h"
#import "NCNetworkTask.h"
#import "NCSerializationHandler.h"
#import "NCNetworkRequest.h"
#import "NCNetworkSessionManager.h"
#import "NCDispatchFunctions.h"

@implementation NCWebService (DynamicMethod)

- (void)forwardInvocation:(NSInvocation *)invocation
{
    NSUInteger index = [[invocation methodSignature] numberOfArguments];

    NSMutableArray *parameterList = [[NSMutableArray alloc] init];

    for (NSUInteger i = 0; i < index - 2; i++) // first is self and the second is the _cmd it self
    {
        id __unsafe_unretained arg;

        [invocation getArgument:&arg atIndex:(int)(i + 2)];

        if (arg)
        {
            [parameterList addObject:arg];
        }
        else
        {
            [parameterList addObject:[NSNull null]];
        }

    }

    [self dynamicWebServiceCallWithArguments:parameterList forInvocation:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSUInteger numberOfArguments = [[NSStringFromSelector(selector) componentsSeparatedByString:@":"] count] - 1; // the last item in the collection is empty

    const char *cTypeSignature = [[@"@@:@" stringByPaddingToLength : numberOfArguments + 3 withString : @"@" startingAtIndex : 0] UTF8String];

    return [NSMethodSignature signatureWithObjCTypes:cTypeSignature];
}

- (void)dynamicWebServiceCallWithArguments:(NSMutableArray *)parameterList forInvocation:(NSInvocation *)invocation
{
    NSUInteger numberOfBlocks = 0;

    for (id object in parameterList)
    {
        if ([NCWebService isBlockObject:object])
        {
            numberOfBlocks++;
        }
    }

    id completionBlock;
    id progressBlock;

    if (numberOfBlocks == 1) // must be the completion block
    {
        completionBlock = [parameterList lastObject];
        [parameterList removeLastObject];
    }
    else if (numberOfBlocks == 2)  // must be the progress block for the network request
    {
        progressBlock = [parameterList lastObject];
        [parameterList removeLastObject];

        completionBlock = [parameterList lastObject];
        [parameterList removeLastObject];
    }

    id result = [self executeDynamicImplementationForSelector:invocation.selector parameters:parameterList completionBlock:completionBlock progressBlock:progressBlock];

    [invocation setReturnValue:&result];
}

- (NSOperation *)executeDynamicImplementationForSelector:(const SEL)selector parameters:(NSArray *)parameters completionBlock:(id)completionBlock progressBlock:(id)progressBlock
{
    __block NSData *bodyData;
    __block NSDictionary *parametersDictionary;

    [self encodeParameters:parameters callbackBlock:^(NSDictionary *parametersInBlock, NSData *postData) {
        parametersDictionary = parametersInBlock;
        bodyData = postData;
    }];

    return [self executeCallWithSelector:selector parameters:parametersDictionary body:bodyData completionBlock:completionBlock progressBlock:progressBlock];
}

- (NSOperation *)executeCallWithSelector:(SEL)selector parameters:(NSDictionary *)parameters body:(NSData *)bodyData completionBlock:(NCWebServiceCallbackBlock)completionBlock progressBlock:(id)progressBlock
{
    NCNetworkRequest *networkRequest = [self networkRequestForSelector:selector parameters:parameters bodyData:bodyData];

    NSOperation *operation = [self.sessionManager sessionTaskOperationWithNetworkRequest:networkRequest completionBlock:^(id response, NSError *error, NSHTTPURLResponse *httpURLResponse) {

        if (networkRequest.deserializationClass && !error)
        {
            Class serializerClass = NSClassFromString(networkRequest.serializerClassName);

            id serializer = [[serializerClass alloc] init];

            dispatchOnBackgroundQueue (^{
                [NCSerializationHandler deserializeData:response withSerializer:serializer toDeserializationClass:networkRequest.deserializationClass withCompletitionBlock:^(id serializedData, NSError *error) {
                    completionBlock(serializedData, error, httpURLResponse);
                }];
            });
        }
        else
        {
            completionBlock(response, error, httpURLResponse);
        }
    } progressBlock:progressBlock];

    [self.processingQueue addOperation:operation]; // start operation

    return operation;
}

- (NCNetworkRequest *)networkRequestForSelector:(SEL)selector parameters:(NSDictionary *)parameters bodyData:(NSData *)bodyData
{
    NSParameterAssert(self.serviceName);

    NSDictionary *configuration = self.networkServices[self.serviceName];

    if (!configuration)
    {
        NSString *path = [NSStringFromClass([self class]) stringByAppendingFormat:@"+%@", self.serviceName];

        // load the configuration file
        NSString *configurationFile = [[NSBundle bundleForClass:[self class]] pathForResource:path ofType:kNCWebServicePlist];

        NSAssert(configurationFile, ([NSString stringWithFormat:@"[NCWebServiceAssertion] There is now plist file has been found based on service name: %@", self.serviceName]));

        configuration = [NSDictionary dictionaryWithContentsOfFile:configurationFile];

        self.networkServices[self.serviceName] = configuration;
    }

    NSDictionary *networkRequestParameters = configuration[NSStringFromSelector(selector)];

    NSAssert(networkRequestParameters, ([NSString stringWithFormat:@"[NCWebServiceAssertion] No configuration has been found for signature: %@", NSStringFromSelector(selector)]));

    NCWebServiceParameterParser *parameterParser = [[NCWebServiceParameterParser alloc] init];

    NSString *queryPath = networkRequestParameters[kNCWebServiceRequest][kNCWebServiceRequestPath];
    NSString *serviceQueryPath = [parameterParser parseServiceQueryString:queryPath parameters:parameters];
    NSString *requestPath = [NSString stringWithFormat:@"%@", [self.serviceRootURL absoluteString]];

    if ([requestPath length])
    {
        if (serviceQueryPath)
        {
            requestPath = [requestPath stringByAppendingString:serviceQueryPath];
        }
    }
    else
    {
        requestPath = serviceQueryPath;
    }

    NSDictionary *mappingParameters = networkRequestParameters[kNCWebServiceSerialization];

    NSMutableDictionary *headerDictionary = [[parameterParser parseWebServiceParameter:kNCWebServiceParameterParserHeaderParameter configuration:networkRequestParameters parameters:parameters] mutableCopy];

    if (![networkRequestParameters[kNCWebServiceRequest][kNCWebServiceParameterParserHeaderParameter][kNCWebServiceParameterParserExcludeSharedHeaderParameter] boolValue])
    {
        NSDictionary *sharedHeaderDictionary = [[self class] sharedHeaderDictionary];
        [headerDictionary addEntriesFromDictionary:sharedHeaderDictionary];
    }

    if (headerDictionary[kNCWebServiceParameterParserExcludeSharedHeaderParameter])
    {
        [headerDictionary removeObjectForKey:kNCWebServiceParameterParserExcludeSharedHeaderParameter];

    }

    NSDictionary *parametersDictionary;
    if (networkRequestParameters[kNCWebServiceRequest][kNCWebServiceParameterParserParametersParameter])
    {
        parametersDictionary = [parameterParser parseWebServiceParameter:kNCWebServiceParameterParserParametersParameter configuration:networkRequestParameters parameters:parameters];
    }

    NSArray *filesArray;
    if (networkRequestParameters[kNCWebServiceRequest][kNCWebServiceParameterParserFilesParameter])
    {
        filesArray = [parameterParser parseFilesParameterWithConfiguration:networkRequestParameters parameters:parameters];
    }

    // request type (POST, GET, PUT, HEAD, DELETE...)
    NSString *requestType = networkRequestParameters[kNCWebServiceRequest][kNCWebServiceRequestMethod];

    if (!requestType)
    {
        requestType = kNCWebServiceRequestTypeGet;
    }

    // network session type, data task, upload or download
    NSString *sessionType = networkRequestParameters[kNCWebServiceRequest][kNCWebServiceRequestSessionType];

    if (!sessionType)
    {
        sessionType = kNCWebServiceRequestSessionTypeDataTask;
    }

    NCNetworkRequest *networkRequest = [[NCNetworkRequest alloc] init];
    networkRequest.path = [requestPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    networkRequest.type = requestType;
    networkRequest.headerDictionary = headerDictionary;
    networkRequest.sessionType = sessionType;
    networkRequest.bodyObject = bodyData;
    networkRequest.parametersDictionary = parametersDictionary;
    networkRequest.filesArray = filesArray;

    if (mappingParameters)
    {
        networkRequest.serializerClassName = mappingParameters[kNCWebServiceSerializerClass];
        networkRequest.deserializationClass = mappingParameters[kNCWebServiceSerializedObjectClass];
    }

    return networkRequest;
}

- (void)encodeParameters:(NSArray *)parameterList callbackBlock:(void (^)(NSDictionary *parameters, NSData *postData))callbackBlock
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:[parameterList count]];
    NSData *bodyData;

    for (id object in parameterList)
    {
        NSString *key = [NSString stringWithFormat:@"%lu", (unsigned long)[result count]];
        id encodedObject;

        if ([object isKindOfClass:[NSString class]])
        {
            encodedObject = object;
        }
        else if ([object respondsToSelector:@selector(stringValue)])
        {
            encodedObject = [object stringValue];
        }
        else if ([object isKindOfClass:[NSData class]])
        {
            encodedObject = @"";
            bodyData = object;
        }
        else
        {
            if (object == nil)
            {
                NSAssert(encodedObject != nil, @"Encoded object must be a valid object not nil");
            }
            else
            {
                encodedObject = object;
            }
        }

        // store encoded objects
        result[key] = encodedObject;
    }

    callbackBlock(result, bodyData);
}

@end
