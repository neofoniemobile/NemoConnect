//
//  NCNetworkDownloader.h
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

@import Foundation;

#import "NCAuthentication.h"

@class NCNetworkRequest;

typedef void (^NCNetworkCallback)(id response, NSError *error, NSHTTPURLResponse *httpURLResponse);
typedef void (^NCNetworkDownloaderProgressBlock)(float progress);

/**
 *  Webservice downloader protocol
 */
@protocol NCNetworkTask <NSObject>

@optional

/**
 *  Designated initialiser for downloader session task
 *
 *  @param request         network request object
 *  @param session         url session instance, created by network session manager
 *  @param completionBlock generic completion block NCNetworkCallback
 *
 *  @return returning with a cancelable object
 */
- (id)initWithRequest:(NCNetworkRequest *)request session:(NSURLSession *)session completionBlock:(NCNetworkCallback)completionBlock;

/**
 *  Designated initialiser for downloader with progress block
 *
 *  @param request         network request object
 *  @param session         url session instance, created by network session manager
 *  @param completionBlock generic completion block NCNetworkCallback
 *  @param progressBlock   progress block with the float value of the current download process
 *
 *  @return returning with a cancelable object
 */
- (id)initWithRequest:(NCNetworkRequest *)request session:(NSURLSession *)session completionBlock:(NCNetworkCallback)completionBlock progressBlock:(NCNetworkDownloaderProgressBlock)progressBlock;

@end
