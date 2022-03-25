//
//  NSObject+Notification.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "NSObject+Notification.h"
#import "NotificationTool.h"
#import <objc/runtime.h>

@interface NSObject (Notification)

@property (nonatomic, strong) NSMutableDictionary *observerDict;
@property (nonatomic, strong) NotificationTool *noteTool;

@end

@implementation NSObject (Notification)

- (void)tb_addObserver:(id)observer
                  name:(nullable NSString *)aName
                object:(nullable id)anObject
              callback:(NotificationCallback)callBack {
    [self.noteTool tb_addObserver:observer name:aName object:anObject callback:callBack];
}

#pragma mark - setter and getter

- (void)setNoteTool:(NotificationTool *)noteTool {
    objc_setAssociatedObject(self, @selector(noteTool), noteTool, OBJC_ASSOCIATION_RETAIN);
}

- (NotificationTool *)noteTool {
    return objc_getAssociatedObject(self, @selector(noteTool));
}

@end
