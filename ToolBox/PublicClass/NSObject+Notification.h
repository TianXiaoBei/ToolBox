//
//  NSObject+Notification.h
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import <Foundation/Foundation.h>
#import "ToolBoxHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Notification)

/// 添加通知监听：同一个监听者监听同一个key，新的覆盖老的
/// @param aName 通知名称
/// @param callBack 通知回调
- (void)tb_addObserverWithName:(nullable NSString *)aName
                      callback:(TBNotificationCallback)callBack;
- (void)tb_removeObserverWithName:(nullable NSString *)aName;
- (void)tb_removeAllObserver;

@end

NS_ASSUME_NONNULL_END
