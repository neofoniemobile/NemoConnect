//
//  NCDispatchFunctions.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  Simple dispatch functions, to handle dispatching more easily
 */
@interface NCDispatchFunctions : NSObject

void dispatchOnMainQueue(dispatch_block_t block);

void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block);

void dispatchOnBackgroundQueue(dispatch_block_t block);

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block);

@end
