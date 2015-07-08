//
//  NCBasicAuthentication.m
//  Nemo Connect
//
//  Copyright (c) 2015 Neofonie Mobile GmbH. All rights reserved.
//  See LICENSE.txt for this framework's licensing information.
//

#import "NCBasicAuthentication.h"

@interface NCBasicAuthentication ()

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) NSURLCredential *urlCredential;

@end

@implementation NCBasicAuthentication

- (id)initWithUsername:(NSString *)username password:(NSString *)password
{
    self = [super init];

    if (self)
    {
        self.username = username;
        self.password = password;
    }

    return self;
}

- (void)createCredential
{
    self.urlCredential = [[NSURLCredential alloc] initWithUser:self.username password:self.password persistence:NSURLCredentialPersistenceForSession];
}

- (NSURLCredential *)processAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault] || [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic])
    {
        if (!self.urlCredential)
        {
            [self createCredential];
        }

        [challenge.sender useCredential:self.urlCredential forAuthenticationChallenge:challenge];
    }

    return self.urlCredential;
}

@end
