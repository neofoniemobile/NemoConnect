//
//  NCDispatchFunctions.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCDispatchFunctions.h"

@implementation NCDispatchFunctions

dispatch_time_t dispatchTimeFromNow(float seconds)
{
    return dispatch_time(DISPATCH_TIME_NOW, (seconds * 1000000000));
}

void dispatchOnMainQueue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_main_queue(), block);
}

void dispatchOnBackgroundQueue(dispatch_block_t block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

void dispatchOnMainQueueAfterDelayInSeconds(float delay, dispatch_block_t block)
{
    dispatchAfterDelayInSeconds(delay, dispatch_get_main_queue(), block);
}

void dispatchAfterDelayInSeconds(float delay, dispatch_queue_t queue, dispatch_block_t block)
{
    dispatch_after(dispatchTimeFromNow(delay), queue, block);
}

@end
