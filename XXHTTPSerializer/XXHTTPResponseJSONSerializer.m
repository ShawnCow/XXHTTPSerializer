//
//  XXHTTPResponseJSONSerializer.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/12.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPResponseJSONSerializer.h"

@implementation XXHTTPResponseJSONSerializer

- (instancetype)initWithDataMappingKey:(NSString *)dataKey
                            messageKey:(NSString *)messageKey
                             statusKey:(NSString *)statusKey
                         successStatus:(NSString *)successStatus
{
    self = [super init];
    if (self) {
        _dataKey = [dataKey copy];
        _messsageKey = [messageKey copy];
        _statusKey = [statusKey copy];
        _successStatus = [successStatus copy];
    }
    return self;
}

- (id)serializerResponse:(id)responseObject error:(NSError *__autoreleasing *)error request:(id<XXRequest,XXRequestORMParser>)request
{
    if (responseObject == nil) {
        if (error) {
            *error = [NSError errorWithDomain:@"XXHTTPResponseSerializerErrorDomain" code:100 userInfo:@{NSLocalizedDescriptionKey:@"data is null"}];
        }
        return nil;
    }
    NSDictionary *jsonDic = nil;
    if ([responseObject isKindOfClass:[NSData class]]) {
        NSError *jsonError = nil;
        jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:&jsonError];
        if (jsonError) {
            if (error) {
                *error = jsonError;
            }
            return nil;
        }
    }else if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        jsonDic = responseObject;
    }
    
    NSString *statusValue = jsonDic[self.statusKey];
    if ([statusValue isKindOfClass:[NSNumber class]]) {
        statusValue = [(NSNumber *)statusValue stringValue];
    }
    if ([statusValue isKindOfClass:[NSString class]] == NO) {
        statusValue = [statusValue description];
    }
    if ([statusValue isEqualToString:self.successStatus]) {
        //success
        id result = jsonDic[self.dataKey];
        id<XXJSONToModelHandle> handle = nil;
        if ([request respondsToSelector:@selector(responseORMHandle)]) {
            handle = [request responseORMHandle];
        }
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray * data = result;
            if([request respondsToSelector:@selector(responseORMTargetModelClass)])
            {
                data = [self _parserJSONDictionaryArray:result targetClass:request.responseORMTargetModelClass handle:handle];
            }
            return data;
        }else if ([result isKindOfClass:[NSDictionary class]])
        {
            id<XXJSONToModelWrap> model = nil;
            if ([handle respondsToSelector:@selector(xx_modelFromJSONDictionary:)]) {
                model = [handle xx_modelFromJSONDictionary:result];
            }else
            {
                if ([request respondsToSelector:@selector(responseORMTargetModel)] && request.responseORMTargetModel) {
                    model = [request responseORMTargetModel];
                }
                if (model == nil) {
                    if ([request respondsToSelector:@selector(responseORMTargetModelClass)] && request.responseORMTargetModelClass != nil)
                    {
                        model = [request.responseORMTargetModelClass new];
                    }
                }
                if (model == nil) {
                    model = result;
                }
                if ([model respondsToSelector:@selector(xx_mergeJSONDictionary:)]) {
                    [model xx_mergeJSONDictionary:result];
                }
            }
            return model;
        }else if ([result isKindOfClass:[NSNumber class]] || [result isKindOfClass:[NSString class]])
        {
            return result;
        }else
            return nil;
    }else
    {
        NSString *msg = jsonDic[self.messsageKey];
        if (!msg) {
            msg = @"Unknow error";
        }
        NSInteger errorCode = [statusValue integerValue];
        if (error) {
            *error = [NSError errorWithDomain:@"XXHTTPResponseSerializerErrorDomain" code:errorCode userInfo:@{NSLocalizedDescriptionKey:msg}];
        }
        return nil;
    }
}


- (NSArray *)_parserJSONDictionaryArray:(NSArray *)jsonArray targetClass:(Class)class handle:(id<XXJSONToModelHandle>)handle
{
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < jsonArray.count; i ++) {
        id tempOb = jsonArray[i];
        if ([tempOb isKindOfClass:[NSArray class]]) {
            [tempArray addObject:[self _parserJSONDictionaryArray:tempOb targetClass:class handle:handle]];
        }else if ([tempOb isKindOfClass:[NSDictionary class]])
        {
            if ([handle respondsToSelector:@selector(xx_modelFromJSONDictionary:)]) {
                [tempArray addObject:[handle xx_modelFromJSONDictionary:tempOb]];
            }else
            {
                id<XXJSONToModelWrap> model = [class new];
                [model xx_mergeJSONDictionary:tempOb];
                [tempArray addObject:model];
            }
        }else if ([tempOb isKindOfClass:[NSString class]] || [tempOb isKindOfClass:[NSNumber class]])
        {
            [tempArray addObject:tempOb];
        }
    }
    return tempArray;
}
@end
