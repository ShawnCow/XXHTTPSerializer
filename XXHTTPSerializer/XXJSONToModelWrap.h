//
//  XXJSONToModelWrap.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/12.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XXJSONToModelWrap <NSObject>

@optional

- (void)xx_mergeJSONDictionary:(NSDictionary *)jsonDic;

- (id)xx_serializerToJSONObject;

@end

@protocol XXJSONToModelHandle <NSObject>

@optional

- (id)xx_modelFromJSONDictionary:(NSDictionary *)jsonDic;

@end
