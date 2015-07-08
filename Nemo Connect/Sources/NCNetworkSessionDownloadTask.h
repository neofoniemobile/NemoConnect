//
//  NCNetworkSessionDownloadTask.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCNetworkTask.h"

/**
 *  Network Downloader operation
 *
 *  Worked with NSURLSessionDownload
 */
@interface NCNetworkSessionDownloadTask : NSOperation <NCNetworkTask>

/**
 *  Readonly session task instance
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *task;

@end
