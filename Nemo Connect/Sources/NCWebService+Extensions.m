//
//  NCWebService+Extensions.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCWebService+Extensions.h"

@implementation NCWebService (Extensions)

+ (BOOL)isBlockObject:(id)block
{
    return [[block class] isSubclassOfClass:NSClassFromString(@"NSBlock")];
}

@end