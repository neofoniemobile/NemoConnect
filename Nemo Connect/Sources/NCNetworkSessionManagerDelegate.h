//
//  NCNetworkSessionManagerDelegate.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCNetworkTask.h"

@class NCNetworkSessionManager;

/**
 *  Network session manager delegate
 *
 *  Implementing all the session tasks related protocols
 */
@interface NCNetworkSessionManagerDelegate : NSObject <NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>

/**
 *  Designated initializer
 *
 *  @param sessionManager  required session manager instance
 *  @param completionBlock required generic completion block
 *  @param progressBlock   optional progress block
 *
 *  @return session manager delegate instance
 */
- (id)initWithSessionManager:(NCNetworkSessionManager *)sessionManager completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock;

@end
