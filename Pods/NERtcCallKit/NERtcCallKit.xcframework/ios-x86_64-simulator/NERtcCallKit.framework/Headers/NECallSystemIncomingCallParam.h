//// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

#import <Foundation/Foundation.h>
#import "NECallParam.h"
NS_ASSUME_NONNULL_BEGIN

@interface NECallSystemIncomingCustomCallParam : NSObject
// 自定义来电显示信息
@property(nonatomic, copy, nullable) NSString *displayContent;

// 远端IM账号，可选
@property(nonatomic, copy, nullable) NSString *remoteAccid;

// 来电类型，如不指定默认显示音频
@property(nonatomic, assign) NECallType callType;
@end

@interface NECallSystemIncomingCallParam : NSObject

// pushkit 中的 payload.dictionaryPayload,
// 如果设置该字段，云信读取该字段内容，根据云信默认的解析规则进行显示，若显示信息无法满足需求，用户也可以配置
// customPayload 字段进行展示。
@property(nonatomic, strong, nullable) NSDictionary *payload;

// 来电提示音，需要放在 app bundle 中， 如：xxx.mp3, 可选
@property(nonatomic, copy, nullable) NSString *ringtoneName;

// 自定义来电信息，优先级更高，会覆盖 payload 显示信息，如自定义显示来电信息，来电类型等
@property(nonatomic, strong, nullable) NECallSystemIncomingCustomCallParam *customPayload;

@end

NS_ASSUME_NONNULL_END
