//
//  NSObject+Notification.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "NSObject+Notification.h"
#import "TBNotificationTool.h"
#import "TBWeakProxy.h"
#import <objc/runtime.h>

@interface NSObject (Notification)

@property (nonatomic, strong) TBNotificationTool *noteTool;

@end

@implementation NSObject (Notification)

- (void)tb_addObserverWithName:(nullable NSString *)aName
                      callback:(TBNotificationCallback)callBack {
    [self.noteTool private_addObserver:[TBWeakProxy proxyWithTarget:self] name:aName callback:callBack];
}

- (void)tb_removeObserverWithName:(nullable NSString *)aName
                           object:(nullable id)anObject {
    [self.noteTool private_removeObserver:[TBWeakProxy proxyWithTarget:self] name:aName];
}

- (void)tb_removeAllObserver {
    [self.noteTool private_removeAllObserver];
}

#pragma mark - setter and getter

- (void)setNoteTool:(TBNotificationTool *)noteTool {
    objc_setAssociatedObject(self, @selector(noteTool), noteTool, OBJC_ASSOCIATION_RETAIN);
}

- (TBNotificationTool *)noteTool {
    return objc_getAssociatedObject(self, @selector(noteTool));
}

@end
