//
//  XXHTTPPostFormDataPart.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XXRequest.h>

@interface XXHTTPPostFormDataPart : NSObject<XXPostFormBodyPart>

- (instancetype)initWithData:(NSData *)data mimeType:(NSString *)type filename:(NSString *)filename name:(NSString *)name;

@property (nonatomic, readonly, copy) NSData *data;
@property (nonatomic, readonly, copy) NSString *mimeType;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *filename;

@end
