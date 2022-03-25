//
//  NSObject+Notification.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "NSObject+Notification.h"
#import <objc/runtime.h>

@interface NSObject (Notification)

@property (nonatomic, strong) NSMutableDictionary *noteDict;

@end

@implementation NSObject (Notification)

- (void)addObserver:(id)observer
               name:(nullable NSString *)aName
             object:(nullable id)anObject
           callback:(void(^)(NSNotification *note))callBack {
    if (!observer || !aName || aName.length <= 0) {
        NSLog(@"tl -- observer或aName不合法");
        return;
    }
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:@selector(notificationCallback:) name:aName object:anObject];
}

#pragma mark - note callback

- (void)notificationCallback:(NSNotification *)note {
    
}

#pragma mark - setter and getter

- (void)setNoteDict:(NSMutableDictionary *)noteDict {
    objc_setAssociatedObject(self, @selector(noteDict), noteDict, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)noteDict {
    return objc_getAssociatedObject(self, @selector(noteDict));
}

@end
