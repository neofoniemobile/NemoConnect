//
//  NCAuthentication.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  Authentication Provider blue print
 */
@protocol NCAuthentication <NSObject>

@optional

/**
 *  Designated initializer with generic credential data like user name and password
 *
 *  @param username required parameter as string
 *  @param password required parameter as string
 *
 *  @return authentication provider instance
 */
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;

/**
 *  Designated initializer with token key
 *
 *  @param tokenKey token key as string
 *
 *  @return authentication provider instance
 */
- (instancetype)initWithTokenKey:(NSString *)tokenKey;

@required

/**
 *  Process authentication challenge for the incoming challenge
 *
 *  @param challenge incoming authentication challenge
 *
 *  @return NSURLCredential instance
 */
- (NSURLCredential *)processAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge;

@end
