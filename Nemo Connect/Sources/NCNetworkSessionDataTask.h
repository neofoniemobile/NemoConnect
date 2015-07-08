//
//  NCNetworkSessionDataTask.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCNetworkTask.h"

/**
 *  Downloader
 *
 *  Working with NSURLSessionDataTask
 */
@interface NCNetworkSessionDataTask : NSOperation <NCNetworkTask>

/**
 *  Readonly session task property
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *task;

@end
