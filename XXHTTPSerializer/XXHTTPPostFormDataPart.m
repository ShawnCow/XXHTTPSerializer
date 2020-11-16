//
//  XXHTTPPostFormDataPart.m
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import "XXHTTPPostFormDataPart.h"

@interface XXHTTPPostFormDataPart ()
{
    long long readLenght;
}
@end

@implementation XXHTTPPostFormDataPart

- (instancetype)initWithData:(NSData *)data mimeType:(NSString *)type filename:(NSString *)filename name:(NSString *)name
{
    self = [super init];
    if (self) {
        _data = [data copy];
        _mimeType = [type copy];
        _name = [name copy];
        _filename = [filename copy];
    }
    return self;
}

- (NSString *)partName
{
    return self.name;
}

- (long long)partLenght
{
    return self.data.length;
}

- (NSData *)partData
{
    return self.data;
}
- (NSString *)partMimeType
{
    return self.mimeType;
}

- (NSString *)partFileName
{
    return self.filename;    
}
@end
