//
//  NCCancelable.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  Cancelable object protocol
 */
#warning not used interface definition
@protocol NCCancelable <NSObject>

@required

/**
 *  Cancel method
 */
- (void)cancel;

@end
