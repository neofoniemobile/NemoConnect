//
//  NCNetworkSessionManager.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCAuthentication.h"
#import "NCNetworkTask.h"
#import "NCNetworkRequest.h"

/**
 *  Network session manager
 *
 *  - Holding the url session instance long as the web service instance is exists
 *  - Private - Download/Upload/Data session task operation factory
 *  - Private - Conforms to NSURLSessionDelegate, NSURLSessionDownloadDelegate, NSURLSessionUploadDelegate, NSURLSessionDataDelegate
 */
@interface NCNetworkSessionManager : NSObject

/**
 *  Designated initializer method
 *
 *  @param operationQueue         processing operation queue, this instance will created by the client application
 *  @param sessionConfiguration   NSURLSessionConfiguration instance
 *  @param authenticationProvider authentication provider
 *
 *  @return network session manager instance
 */
- (id)initWithOperationQueue:(NSOperationQueue *)operationQueue sessionConfiguration:(NSURLSessionConfiguration *)sessionConfiguration authenticationProvider:(id<NCAuthentication>)authenticationProvider;

/**
 *  NSOperation with session download operation factory method
 *
 *  Creates an NSOperation with Session Task, based on the network request object.
 *
 *  @param request         network request object with all the required parameters that the web service call needed
 *  @param completionBlock generic framework related network completion block with response, error and HTTP status code
 *  @param progressBlock   generic framework related network progress block with percentage of the download progress
 *
 *  @return operation
 */
- (NSOperation *)sessionTaskOperationWithNetworkRequest:(NCNetworkRequest *)request completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock;

@end
