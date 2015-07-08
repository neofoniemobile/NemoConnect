//
//  NCNetworkSessionUploadTask.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCNetworkTask.h"

/**
 *  Network Session Upload Task Operation
 */
@interface NCNetworkSessionUploadTask : NSOperation <NCNetworkTask>

/**
 *  Readonly property of the session task
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *task;

@end
