//
//  XXHTTPRequest.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/7.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPRequest.h"
#import <XXHTTPRequestManager.h>

NSString * const XXHTTPRequestErrorDomain = @"XXHTTPRequestErrorDomain";

@implementation XXHTTPRequest

- (instancetype)initWithBaseURL:(NSString *)baseURL
{
    self = [super init];
    if (self) {
        _baseURL = [baseURL copy];
    }
    return self;
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return self;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    XXHTTPRequest *request = [[[self class] alloc]initWithBaseURL:self.baseURL];
    request.URLString = self.URLString;
    request.HTTPMethod = self.HTTPMethod;
    request.parameter = self.parameter;
    request.headers = self.headers;
    request.requestSerializer = self.requestSerializer;
    request.responseSerializer = self.responseSerializer;
    request.formBodyParts = self.formBodyParts;
    return request;
}

- (id<XXRequestOperation>)sendRequestWithCompletion:(XXHTTPRequestCompletion)completion
{
    return [[XXHTTPRequestManager defaultRequestManager]sendRequest:self completion:^(id<XXResponse> response) {
        [self _requestFinishWithReponse:response request:self completion:completion];
    }];
}

- (void)_requestFinishWithReponse:(id<XXResponse>)response request:(id<XXRequest>)request completion:(XXHTTPRequestCompletion)completion
{
    if (response.error) {
        [self _callCompletion:completion error:response.error];
    }else
    {
        if (response.statusCode == 200) {
            
            id tempResponseObject = nil;
            if ([response respondsToSelector:@selector(responseObject)]) {
                tempResponseObject = [response responseObject];
            }
            id result = tempResponseObject;
            
            NSError *error = nil;
            if (self.responseSerializer) {
                result = [self.responseSerializer serializerResponse:(NSData *)tempResponseObject error:&error request:self];
            }
            if (error) {
                [self _callCompletion:completion error:error];
                return;
            }
            [self _callCompletion:completion result:result];
        }else
        {
            NSError *error = response.error;
            if (error == nil) {
                error = [NSError errorWithDomain:XXHTTPRequestErrorDomain code:response.statusCode userInfo:@{NSLocalizedDescriptionKey:@"Server error"}];
            }
            [self _callCompletion:completion error:error];
        }
    }
}

- (void)_callCompletion:(XXHTTPRequestCompletion)completion error:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(error,nil);
        }
    });
}

- (void)_callCompletion:(XXHTTPRequestCompletion)completion result:(id)result
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completion) {
            completion(nil,result);
        }
    });
}
@end
