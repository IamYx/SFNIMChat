//
//  OCClass.m
//  NIMSDKSwift
//
//  Created by 姚肖 on 2023/4/30.
//

#import "OCClass.h"

@implementation OCClass

//崩溃
-(void)test0: (NSError *_Nonnull *_Nonnull)error
{
    *error = nil;
}


//不崩溃
-(void)test1: (NSError *_Nullable *_Nullable)error
{
    *error = nil;
}

@end
