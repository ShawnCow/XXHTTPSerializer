//
//  XXHTTPRequestPostFormSerializer.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPRequestPostFormSerializer.h"

@implementation XXHTTPRequestPostFormSerializer

- (NSURLRequest *)serializerRequest:(id<XXRequest>)request
{
    NSMutableString *tempURL = [NSMutableString string];
    [tempURL appendString:request.baseURL];
    [tempURL stringByAppendingPathComponent:request.URLString];
    NSURL *url = [NSURL URLWithString:tempURL];
    NSMutableURLRequest *tempRequest = [NSMutableURLRequest requestWithURL:url];
    tempRequest.HTTPMethod = @"POST";
    for (NSString *tempHeaderKey in request.headers) {
        [tempRequest setValue:request.headers[tempHeaderKey] forHTTPHeaderField:tempHeaderKey];
    }
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    
    NSString *boundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString * start = [NSString stringWithFormat:@"--%@",boundary];
    NSString * end = [NSString stringWithFormat:@"\r\n--%@--\r\n",boundary];
    NSMutableArray *parts = [[request formBodyParts] mutableCopy];
    NSMutableData *body = [NSMutableData data];
    
    for (NSString *tempParamterKey in request.parameter) {
        NSString *name = tempParamterKey;
        NSString *tempHeader = [NSString stringWithFormat:@"%@\r\n" ,start];
        [body appendData:[tempHeader dataUsingEncoding:NSUTF8StringEncoding]];
        NSString * disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",name];
        [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        id tempData = request.parameter[tempParamterKey];
        if ([tempData isKindOfClass:[NSData class]]) {
            [body appendData:tempData];
        }else if ([tempData isKindOfClass:[NSString class]])
        {
            [body appendData:[(NSString *)tempData dataUsingEncoding:NSUTF8StringEncoding]];
        }else
        {
            NSString *d = [tempData description];
            [body appendData:[d dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    for (id<XXPostFormBodyPart>tempPart in parts) {
        NSString *name = [tempPart partName];
        NSString *tempHeader = [NSString stringWithFormat:@"%@\r\n" ,start];
        [body appendData:[tempHeader dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *fileName = nil;
        if ([tempPart respondsToSelector:@selector(partFileName)]) {
            fileName = [tempPart partFileName];
        }
        NSString *disposition = nil;
        if (fileName) {
            disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",name,fileName];
        }else
        {
            disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",name];
        }
        [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSString *mimeType = nil;
        if ([tempPart respondsToSelector:@selector(partMimeType)]) {
            mimeType = [tempPart partMimeType];
        }
        if (mimeType) {
            NSString *mimeNodeString = [NSString stringWithFormat:@"Content-Type: %@\r\n",mimeType];
            [body appendData:[mimeNodeString dataUsingEncoding:NSUTF8StringEncoding]];
        }
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        if ([tempPart respondsToSelector:@selector(partData)]) {
            [body appendData:[tempPart partData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    [body appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentType=[[NSString alloc]initWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@",boundary];
    [tempRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    [tempRequest addValue:[NSString stringWithFormat:@"%@", [NSNumber numberWithInteger:[body length]]] forHTTPHeaderField:@"Content-Length"];
    return tempRequest;
}

@end
