//
//  FBYSDKDemo.h
//  FBYSDKDemo
//
//  Created by fby on 2018/1/31.
//  Copyright © 2018年 FBYSDKDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^FBYSDKCompletion)(NSString *result);

@interface FBYSDKDemo : NSObject

/**
 *
 *  @param urltype       网页类型信息 urltype可为iOS、Android
 *  @param completion    根据urltype获取到相应网页url结果回调
 *
 */

+ (void)urlType:(NSString *)urltype withCompletion:(FBYSDKCompletion)completion;


@end
