//
//  NCWebService+Test.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NemoConnect.h"

@interface NCWebService (Test)
- (NSOperation *)testCallWithParameter:(NSNumber *)parameter completionBlock:(NCWebServiceCallbackBlock)completionBlock;
@end
