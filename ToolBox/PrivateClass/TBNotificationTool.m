//
//  TBNotificationTool.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "TBNotificationTool.h"
#import "TBWeakProxy.h"

@interface TBNotificationTool ()

@property (nonatomic, strong) NSMutableDictionary *observerDict;

@end

@implementation TBNotificationTool

#pragma mark - public function

- (void)private_addObserver:(id)observer
                       name:(NSString *)aName
                   callback:(TBNotificationCallback)callBack {
    if (!observer || !aName || aName.length <= 0) {
        NSLog(@"tl -- observer或aName不合法");
        return;
    }
    
    if (!self.observerDict) {
        self.observerDict = [NSMutableDictionary dictionary];
    }

    NSMutableArray *arrM = self.observerDict[aName];
    NSMutableDictionary *obsModel = [self observerIsExistWithName:aName observer:observer];
    if (obsModel) {
        ///监听者已存在
        if (callBack) {
            obsModel[self.keyCallback] = callBack;
        }
    } else {
        ///监听者不存在
        obsModel = [NSMutableDictionary dictionary];
        [obsModel setObject:observer forKey:self.keyObserver];
        if (callBack) {
            [obsModel setObject:callBack forKey:self.keyCallback];
        }
        if (!arrM) {
            arrM = [NSMutableArray array];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCallback:) name:aName object:nil];
        }
        [arrM addObject:obsModel];
        [self.observerDict setObject:arrM forKey:aName];
    }
    
}

- (void)private_removeObserver:(id)observer
                          name:(NSString *)aName {
    NSMutableArray *arrM = self.observerDict[aName];
    if (!arrM) {
        NSLog(@"tl -- 该通知没有任何监听者，不需要移除");
        return;
    }
    NSMutableArray *temp = [NSMutableArray arrayWithArray:arrM];
    for (NSMutableDictionary *dictM in temp) {
        id oldOb = dictM[self.keyObserver];
        TBWeakProxy *weakOld = (TBWeakProxy *)oldOb;
        TBWeakProxy *weakNew = (TBWeakProxy *)observer;
        if ([weakOld.target isEqual:weakNew.target]) {
            [arrM removeObject:dictM];
            break;
        }
    }
    if (arrM.count == 0) {
        [self.observerDict removeObjectForKey:aName];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:aName object:nil];
    }
}

- (void)private_removeAllObserver:(id)observer {
    __weak typeof(self)weakSelf = self;
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:self.observerDict];
    [tempDict enumerateKeysAndObjectsUsingBlock:^(NSString *aName, NSMutableArray *arrM, BOOL * _Nonnull stop) {
        [weakSelf private_removeObserver:observer name:aName];
    }];
}

#pragma mark - note callback

- (void)notificationCallback:(NSNotification *)note {
    NSString *name = note.name;
    NSArray *array = self.observerDict[name];
    for (NSMutableDictionary *dictM in array) {
        TBNotificationCallback callback = dictM[self.keyCallback];
        if (callback) {
            callback(note);
        }
    }
}

#pragma mark - private function

/// 返回通知监听者的模型字典
/// @param aName 通知名称
/// @param observer 监听者
- (NSMutableDictionary *)observerIsExistWithName:(NSString *)aName observer:(id)observer {
    NSArray *array = self.observerDict[aName];
    NSMutableDictionary *temp = nil;
    for (NSMutableDictionary *dictM in array) {
        id oldOb = dictM[self.keyObserver];
        TBWeakProxy *weakOld = (TBWeakProxy *)oldOb;
        TBWeakProxy *weakNew = (TBWeakProxy *)observer;
        if ([weakOld.target isEqual:weakNew.target]) {
            temp = dictM;
            break;
        }
    }
    return temp;
}

#pragma mark - setter and getter

- (NSString *)keyObserver {
    return @"observer";
}

- (NSString *)keyCallback {
    return @"callback";
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"tl -- %s",__FUNCTION__);
}

@end
