//
//  NotificationTool.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "NotificationTool.h"

@interface NotificationTool ()

@property (nonatomic, strong) NSMutableDictionary *observerDict;

@end

@implementation NotificationTool

- (void)tl_addObserver:(id)observer
                  name:(nullable NSString *)aName
                object:(nullable id)anObject
              callback:(NotificationCallback)callBack {
    if (!observer || !aName || aName.length <= 0) {
        NSLog(@"tl -- observer或aName不合法");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCallback:) name:aName object:anObject];
    
    if (!self.observerDict) {
        self.observerDict = [NSMutableDictionary dictionary];
    }
    /*
     {
         "name":[
             {
                  "observer":observer,
                  "object":object,
                  "callback":callback
             }
         ]
     }
     */
    NSMutableDictionary *obsModel = [self observerIsExistWithName:aName observer:observer];
    if (obsModel) {
        if (callBack) {
            obsModel[self.keyCallback] = callBack;
        }
        if (anObject) {
            obsModel[self.keyObject] = anObject;
        }
    } else {
        NSMutableArray *arrM = self.observerDict[aName];
        obsModel = [NSMutableDictionary dictionary];
        [obsModel setObject:observer forKey:self.keyObserver];
        if (anObject) {
            [obsModel setObject:anObject forKey:self.keyObject];
        }
        if (callBack) {
            [obsModel setObject:callBack forKey:self.keyCallback];
        }
        [arrM addObject:obsModel];
        [self.observerDict setObject:arrM forKey:aName];
    }
}

- (NSMutableDictionary *)observerIsExistWithName:(NSString *)aName observer:(id)observer {
    NSArray *array = self.observerDict[aName];
    NSMutableDictionary *temp = nil;
    for (NSMutableDictionary *dictM in array) {
        id obs = dictM[self.keyObserver];
        if ([obs isEqual:observer]) {
            temp = dictM;
            break;
        }
    }
    return temp;
}

#pragma mark - note callback

- (void)notificationCallback:(NSNotification *)note {
    NSString *name = note.name;
    NSArray *array = self.observerDict[name];
    for (NSMutableDictionary *dictM in array) {
        NotificationCallback callback = dictM[self.keyCallback];
        if (callback) {
            callback(note);
        }
    }
}

#pragma mark - setter and getter

- (NSString *)keyObserver {
    return @"observer";
}

- (NSString *)keyObject {
    return @"object";
}

- (NSString *)keyCallback {
    return @"callback";
}

- (void)dealloc {

}

@end
