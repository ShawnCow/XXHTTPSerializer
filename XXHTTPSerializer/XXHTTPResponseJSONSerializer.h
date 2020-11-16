//
//  XXHTTPResponseJSONSerializer.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/12.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXHTTPSerializer.h"

@interface XXHTTPResponseJSONSerializer : NSObject<XXResponseSerializer>

- (instancetype)initWithDataMappingKey:(NSString *)dataKey messageKey:(NSString *)messageKey statusKey:(NSString *)statusKey successStatus:(NSString *)successStatus;

@property (nonatomic, readonly, copy) NSString *dataKey;
@property (nonatomic, readonly, copy) NSString *messsageKey;
@property (nonatomic, readonly, copy) NSString *statusKey;
@property (nonatomic, readonly, copy) NSString *successStatus;

@end
