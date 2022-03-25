//
//  NotificationTool.h
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NotificationTool : NSObject

- (void)tl_addObserver:(id)observer
                  name:(nullable NSString *)aName
                object:(nullable id)anObject
              callback:(NotificationCallback)callBack;
- (void)tl_removeObserver:(id)observer name:(nullable NSString *)aName;
- (void)tl_removeAllObserver;

@end

NS_ASSUME_NONNULL_END
