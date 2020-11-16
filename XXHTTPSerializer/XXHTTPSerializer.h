//
//  XXHTTPSerializer.h
//  XXHTTPSerializer
//
//  Created by Shawn on 2019/3/11.
//  Copyright © 2019 Shawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XXRequest.h>
#import "XXJSONToModelWrap.h"

@protocol XXRequestORMParser <NSObject>

@optional

@property (nonatomic, weak) id<XXJSONToModelWrap> responseORMTargetModel;

@property (nonatomic, strong) Class responseORMTargetModelClass;

@property (nonatomic, weak) id<XXJSONToModelHandle> responseORMHandle;

@end
