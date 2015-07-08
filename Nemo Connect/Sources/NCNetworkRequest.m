//
//  NCNetworkRequest.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCNetworkRequest.h"

NSString *const kNCNetworkRequestSessionTaskTypeData = @"DataTask";
NSString *const kNCNetworkRequestSessionTaskTypeDownload = @"DownloadTask";
NSString *const kNCNetworkRequestSessionTaskTypeUpload = @"UploadTask";

@implementation NCNetworkRequest

- (NSString *)description
{
    return [NSString stringWithFormat:@"path: %@\n type: %@\n", self.path, self.type];
}

@end
