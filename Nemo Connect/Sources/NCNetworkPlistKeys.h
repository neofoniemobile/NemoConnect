//
//  NCNetworkPlistKeys.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

static NSString *const kNCWebServiceRequest = @"request";
static NSString *const kNCWebServiceRequestContentType = @"contentType";
static NSString *const kNCWebServiceRequestPath = @"path";
static NSString *const kNCWebServiceRequestMethod = @"method";
static NSString *const kNCWebServiceRequestSessionType = @"sessionType";
static NSString *const kNCWebServiceRequestSessionTypeDataTask = @"DataTask";
static NSString *const kNCWebServiceRequestSessionTypeUpload = @"Upload";
static NSString *const kNCWebServicePlist = @"plist";
static NSString *const kNCWebServiceSerialization = @"serialization";
static NSString *const kNCWebServiceSerializerClass = @"serializer";
static NSString *const kNCWebServiceSerializedObjectClass = @"serializedObject";
static NSString *const kNCNetworkHTTPHeaderFieldContentType = @"Content-Type";
static NSString *const kNCNetworkHTTPHeaderFieldContentTypeJSONApplication = @"application/json";
static NSString *const kNCNetworkSessionUploadTaskTempFilePrefix = @"NCNetworkSessionUploadTask_";
static NSString *const kNCSerializationErrorDomain = @"NCSerializationErrorDomain";
static NSString *const kNCSerializationErrorUserInformationDictionaryOriginalDataKey = @"NCSerializationErrorUserInformationDictionaryOriginalDataKey";
static NSInteger const kNCSerializationErrorCode = -5001;
static NSString *const kNCWebServiceParameterParserBodyParameter = @"body";
static NSString *const kNCWebServiceParameterParserHeaderParameter = @"header";
static NSString *const kNCWebServiceParameterParserExcludeSharedHeaderParameter = @"excludeSharedHeader";
