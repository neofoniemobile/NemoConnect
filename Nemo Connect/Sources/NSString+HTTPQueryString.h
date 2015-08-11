//
//  NSString+HTTPQueryString.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import <Foundation/Foundation.h>

@interface NSString (HTTPQueryString)

+ (NSString *)HTTPQueryStringWithParameters:(NSDictionary *)parameters;

@end
