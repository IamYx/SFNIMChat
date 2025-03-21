//
//  OCClass.h
//  NIMSDKSwift
//
//  Created by 姚肖 on 2023/4/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OCClass : NSObject

//崩溃
-(void)test0: (NSError *_Nonnull *_Nonnull)error;


//不崩溃
-(void)test1: (NSError *_Nullable *_Nullable)error;

@end

NS_ASSUME_NONNULL_END
