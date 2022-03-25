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

- (void)tb_addObserverWithName:(nullable NSString *)aName
                      callback:(TBNotificationCallback)callBack;
- (void)tb_removeObserverWithName:(nullable NSString *)aName
                           object:(nullable id)anObject;
- (void)tb_removeAllObserver;

@end

NS_ASSUME_NONNULL_END
