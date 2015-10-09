//
//  NCFileDescription.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import <Foundation/Foundation.h>

@interface NCFileDescription : NSObject <NSCopying>
@property (nonatomic, strong, readonly) NSString *mimeType;
@property (nonatomic, strong, readonly) NSString *parameter;
@property (nonatomic, strong, readonly) NSString *filename;
@property (nonatomic, strong, readonly) NSData *fileContents;

+ (instancetype)fileDescriptionWithMimeType:(NSString *)mimeType parameter:(NSString *)parameter filename:(NSString *)filename fileContents:(NSData *)fileContents;
- (instancetype)initWithMimeType:(NSString *)mimeType parameter:(NSString *)parameter filename:(NSString *)filename fileContents:(NSData *)fileContents;
@end
