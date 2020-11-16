//
//  XXHTTPRequestJSONSerializer.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPRequestJSONSerializer.h"

@implementation XXHTTPRequestJSONSerializer

- (NSURLRequest *)serializerRequest:(id<XXRequest>)request
{
    NSMutableString *tempURL = [NSMutableString string];
    [tempURL appendString:request.baseURL];
    [tempURL stringByAppendingPathComponent:request.URLString];
    NSURL *url = [NSURL URLWithString:tempURL];
    NSMutableURLRequest *tempRequest = [NSMutableURLRequest requestWithURL:url];
    tempRequest.HTTPMethod = request.HTTPMethod;
    NSString *tempMethod = [request.HTTPMethod lowercaseString];
    if ([tempMethod isEqualToString:@"get"] == NO && [tempMethod isEqualToString:@"head"] == NO) {
        NSDictionary *tempParameter = [[request parameter] copy];
        if ([tempParameter count] > 0) {
            tempRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:tempParameter options:kNilOptions error:nil];
        }
        [tempRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [tempRequest addValue:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[tempRequest.HTTPBody length]]] forHTTPHeaderField:@"Content-Length"];
    }
    for (NSString *tempHeaderKey in request.headers) {
        [tempRequest setValue:request.headers[tempHeaderKey] forHTTPHeaderField:tempHeaderKey];
    }
    return tempRequest;
}

@end
