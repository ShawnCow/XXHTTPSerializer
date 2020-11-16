//
//  XXHTTPRequestJSONSerializer.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXHTTPSerializer.h"

@interface XXHTTPRequestJSONSerializer : NSObject<XXRequestSerializer>

- (NSURLRequest *)serializerRequest:(id<XXRequest>)request;

@end
