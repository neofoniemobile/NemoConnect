//
//  NCWebService.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCAuthentication.h"

@class NCNetworkSessionManager;

extern NSString *const kNCWebServiceRequestTypeGet;
extern NSString *const kNCWebServiceRequestTypePost;
extern NSString *const kNCWebServiceRequestTypePut;
extern NSString *const kNCWebServiceRequestTypeDelete;
extern NSString *const kNCWebServiceRequestTypeTrace;
extern NSString *const kNCWebServiceRequestTypeHead;

typedef void (^NCWebServiceCallbackBlock)(id data, NSError *const error, NSHTTPURLResponse *httpURLResponse);

typedef void (^NCNetworkDownloaderProgressBlock)(float progress);

/**
 *  Web service
 */
@interface NCWebService : NSObject

/**
 *  Web service root URL property, it should be valid HTTP url.
 */
@property (nonatomic, copy, readonly) NSURL *serviceRootURL;

/**
 *  Processing operation queue for the session tasks. Handled by the client application.
 *
 *  If you are not set this property during the initialization, than the queue will be the current operation queue by default.
 */
@property (nonatomic, strong, readonly) NSOperationQueue *processingQueue;

/**
 *  Network session manager, instance for NSURLSession and task delegate handler
 */
@property (nonatomic, strong, readonly) NCNetworkSessionManager *sessionManager;

/**
 *  Service name, should be matched as the service plist file and the category name of the service
 */
@property (nonatomic, copy, readonly) NSString *serviceName;

/**
 *  Network requests configuration from the plist, using for caching
 */
@property (nonatomic, strong) NSMutableDictionary *networkServices __deprecated_msg("This is not used anymore. Use networkServiceConfiguration instead.");

/**
 *  Network requests configuration from the plist
 */
@property (nonatomic, copy, readonly) NSDictionary *networkServiceConfiguration;

/**
 *  Authentication provider instance
 */
@property (nonatomic, strong, readonly) id<NCAuthentication> authenticationProvider;

/**
 *  Designated initializer method with service root parameter. The processing queue will be in this case the current queue
 *
 *  The processing queue will be the current queue that launched the current operation
 *
 *  @param serviceRootURL The API URL
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL __deprecated_msg("Use initializer with serviceName parameter instead.");

/**
 *  Designated initializer method with service root parameter and processing queue
 *
 *  @param serviceRootURL The API URL
 *  @param processingQueue Network operations processing queue
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue __deprecated_msg("Use initializer with serviceName parameter instead.");

/**
 *  Designated initializer method with service root parameter, processing queue and authentication provider instance
 *
 *  @param serviceRootURL The API URL
 *  @param processingQueue Network operations processing queue
 *  @param authenticationProvider NCAuthentication instance
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue authenticationProvider:(id<NCAuthentication>)authenticationProvider __deprecated_msg("Use initializer with serviceName parameter instead.");

/**
 *  Designated initializer with service root, session configuration, working queue and auth. provider
 *
 *  @param serviceRootURL The API URL
 *  @param processingQueue Network operations processing queue
 *  @param sessionConfiguration   NSURLSessionConfiguration instance
 *  @param authenticationProvider NCAuthentication instance
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL processingQueue:(NSOperationQueue *)processingQueue sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration authenticationProvider:(id<NCAuthentication>)authenticationProvider __deprecated_msg("Use initializer with serviceName parameter instead.");

/**
 *  Designated initializer method with service root parameter. The processing queue will be in this case the current queue
 *
 *  The processing queue will be the current queue that launched the current operation
 *
 *  @param serviceRootURL The API URL
 *  @param serviceName Should be matched as the service plist file and the category name of the service
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL serviceName:(NSString *)serviceName;

/**
 *  Designated initializer method with service root parameter and processing queue
 *
 *  @param serviceRootURL The API URL
 *  @param serviceName Should be matched as the service plist file and the category name of the service
 *  @param processingQueue Network operations processing queue
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL serviceName:(NSString *)serviceName processingQueue:(NSOperationQueue *)processingQueue;

/**
 *  Designated initializer method with service root parameter, processing queue and authentication provider instance
 *
 *  @param serviceRootURL The API URL
 *  @param serviceName Should be matched as the service plist file and the category name of the service
 *  @param processingQueue Network operations processing queue
 *  @param authenticationProvider NCAuthentication instance
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL serviceName:(NSString *)serviceName processingQueue:(NSOperationQueue *)processingQueue authenticationProvider:(id<NCAuthentication>)authenticationProvider;

/**
 *  Designated initializer with service root, session configuration, working queue and auth. provider
 *
 *  @param serviceRootURL The API URL
 *  @param serviceName Should be matched as the service plist file and the category name of the service
 *  @param processingQueue Network operations processing queue
 *  @param sessionConfiguration   NSURLSessionConfiguration instance
 *  @param authenticationProvider NCAuthentication instance
 *
 *  @return web service instance
 */
- (id)initWithBaseURL:(NSURL *)serviceRootURL serviceName:(NSString *)serviceName processingQueue:(NSOperationQueue *)processingQueue sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration authenticationProvider:(id<NCAuthentication>)authenticationProvider;

/**
 *  Header dictionary for every service call. If one service call should exclude this parameter, it should be inserted in the plist file
 *
 *  @return web service instance
 */
+ (NSDictionary *)sharedHeaderDictionary;

@end
