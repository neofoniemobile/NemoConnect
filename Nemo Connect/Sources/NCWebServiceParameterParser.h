//
//  NCWebServiceParameterParser.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

/**
 *  Plist configuration parser
 */
@interface NCWebServiceParameterParser : NSObject

/**
 *  Request query parser
 *
 *  @param serviceRootQuery request URI
 *  @param parameters       parameters to replace
 *
 *  @return parsed URI with parameter objects
 */
- (NSString *)parseServiceQueryString:(NSString *)serviceRootQuery parameters:(NSDictionary *)parameters;

/**
 *  Request header parameter parser
 *
 *  @param parameters parameters from configuration
 *  @param param      parameters as keys
 *
 *  @return parsed dictionary, dictionary with replaced parameter keys
 */
- (NSDictionary *)parseHeaderParametersWithCallParameters:(NSDictionary *)parameters withParameters:(NSDictionary *)param;

@end
