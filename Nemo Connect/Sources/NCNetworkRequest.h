//
//  NCNetworkRequest.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

extern NSString *const kNCNetworkRequestSessionTaskTypeData;
extern NSString *const kNCNetworkRequestSessionTaskTypeDownload;
extern NSString *const kNCNetworkRequestSessionTaskTypeUpload;

/**
 *  Basic network request object, represent network request parameters
 */
@interface NCNetworkRequest : NSObject

/**
 *  Request path, url to API
 */
@property (nonatomic, copy) NSString *path;

/**
 *  HTTP Request type, should be REST types
 */
@property (nonatomic, copy) NSString *type;

/**
 *  Session type
 */
@property (nonatomic, copy) NSString *sessionType;

/**
 *  Request header dictionary
 */
@property (nonatomic, strong) NSDictionary *headerDictionary;

/**
 *  Request parameters dictionary (applicable to POST and PUT methods)
 *  Should be used as a replacement of bodyObject, can be used with filesArray.
 *  If specified with bodyObject with Data or DownloadTask, then bodyObject will be ignored.
 *  If specified with bodyObject with UploadTask, then bodyObject will be overwritten.
 */
@property (nonatomic, strong) NSDictionary  *parametersDictionary;

/**
 *  Request files array containing NCFileDescription objects (applicable to POST and PUT methods)
 *  Should be used as a replacement of bodyObject, can be used with parametersDictionary
 *  If specified with bodyObject with UploadTask, then bodyObject will be overwritten.
 */
@property (nonatomic, strong) NSArray *filesArray;

/**
 *  Body object as NSData
 */
@property (nonatomic, strong) NSData *bodyObject;

#pragma mark - serialization properties

/**
 *  Serializer class name, optional
 */
@property (nonatomic, copy) NSString *serializerClassName;

/**
 *  Top level object to serialize, optional
 */
@property (nonatomic, copy) NSString *deserializationClass;

@end
