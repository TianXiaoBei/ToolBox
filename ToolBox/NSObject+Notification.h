//
//  NSObject+Notification.h
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Notification)

- (void)addObserver:(id)observer
               name:(nullable NSString *)aName
             object:(nullable id)anObject
           callback:(void(^)(NSNotification *note))callBack;

@end

NS_ASSUME_NONNULL_END
