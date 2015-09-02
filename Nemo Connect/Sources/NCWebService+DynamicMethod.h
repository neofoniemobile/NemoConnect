//
//  NCWebService+DynamicMethod.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCWebService.h"

/**
 *  Web service dynamic implementation category extension
 */
@interface NCWebService (DynamicMethod)
- (NCNetworkRequest *)networkRequestForSelector:(SEL)selector parameters:(NSDictionary *)parameters bodyData:(NSData *)bodyData;
@end
