//
//  TBNotificationTool.h
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import <Foundation/Foundation.h>
#import "ToolBoxHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface TBNotificationTool : NSObject

- (void)private_addObserver:(id)observer
                       name:(nullable NSString *)aName
                   callback:(TBNotificationCallback)callBack;
- (void)private_removeObserver:(id)observer
                          name:(nullable NSString *)aName;
- (void)private_removeAllObserver:(id)observer;

@end

NS_ASSUME_NONNULL_END
