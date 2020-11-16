//
//  XXHTTPRequest.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXHTTPSerializer.h"

extern NSString * const XXHTTPRequestErrorDomain;

typedef void (^XXHTTPRequestCompletion)(NSError *error, id result);

@interface XXHTTPRequest : NSObject<XXRequest,XXRequestORMParser>

- (instancetype)initWithBaseURL:(NSString *)baseURL;

@property (nonatomic, readonly, copy) NSString *baseURL;

@property (nonatomic, copy) NSString *URLString;

@property (nonatomic, copy) NSString *HTTPMethod;

@property (nonatomic, copy) NSDictionary *parameter;

@property (nonatomic, copy) NSDictionary *headers;

@property (nonatomic, copy) NSArray *formBodyParts;

@property (nonatomic, strong) id<XXRequestSerializer>requestSerializer;

@property (nonatomic, strong) id<XXResponseSerializer>responseSerializer;

@property (nonatomic, weak) id<XXJSONToModelWrap> responseORMTargetModel;

@property (nonatomic, strong)Class responseORMTargetModelClass;

@property (nonatomic, weak) id<XXJSONToModelHandle> responseORMHandle;

- (id<XXRequestOperation>)sendRequestWithCompletion:(XXHTTPRequestCompletion)completion;

@end
