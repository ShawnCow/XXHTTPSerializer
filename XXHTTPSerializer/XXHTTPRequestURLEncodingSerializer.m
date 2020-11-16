//
//  XXHTTPRequestURLEncodingSerializer.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPRequestURLEncodingSerializer.h"

@implementation XXHTTPRequestURLEncodingSerializer

- (NSURLRequest *)serializerRequest:(id<XXRequest>)request
{
    NSString *tempMethod = [request.HTTPMethod lowercaseString];
    
    NSDictionary *tempParameter = [[request parameter] copy];
    NSMutableArray *tempParamterKeyValues = [NSMutableArray array];
    for (NSString *tempKey in tempParameter) {
        [tempParamterKeyValues addObject:[NSString stringWithFormat:@"%@=%@",tempKey,tempParameter[tempKey]]];
    }
    
    NSMutableString *tempURL = [NSMutableString string];
    [tempURL appendString:request.baseURL];
    [tempURL stringByAppendingPathComponent:request.URLString];
    NSURL *url = [NSURL URLWithString:tempURL];
    NSMutableURLRequest *tempRequest = [NSMutableURLRequest requestWithURL:url];
    if ([tempMethod isEqualToString:@"get"] == YES || [tempMethod isEqualToString:@"head"] == YES) {
        if (url.query) {
            tempRequest.URL = [NSURL URLWithString:[url.absoluteString stringByAppendingFormat:@"&%@",[tempParamterKeyValues componentsJoinedByString:@"&"]]];
        }else
        {
            tempRequest.URL = [NSURL URLWithString:[url.absoluteString stringByAppendingFormat:@"?%@",[tempParamterKeyValues componentsJoinedByString:@"&"]]];
        }
    }else
    {
        tempRequest.HTTPBody = [[tempParamterKeyValues componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
        [tempRequest addValue:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[tempRequest.HTTPBody length]]] forHTTPHeaderField:@"Content-Length"];
        [tempRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    }
    
    tempRequest.HTTPMethod = request.HTTPMethod;
    
    for (NSString *tempHeaderKey in request.headers) {
        [tempRequest setValue:request.headers[tempHeaderKey] forHTTPHeaderField:tempHeaderKey];
    }
    
    return tempRequest;
}

@end
