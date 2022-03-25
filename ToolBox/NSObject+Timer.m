//
//  NSObject+Timer.m
//  SafeDemo
//
//  Created by tianlong on 2022/3/24.
//

#import "NSObject+Timer.h"
#import <objc/runtime.h>

@interface NSObject (Timer)

@property (nonatomic, strong) NSMutableDictionary *timerDict;

@end

@implementation NSObject (Timer)

#pragma mark - public function

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval
                        callBack:(dispatch_block_t)callBack
                           start:(BOOL)start
                             idf:(NSString *)idf {
    [self addTimerWithTimeInterval:interval callBack:callBack start:start idf:idf queue:dispatch_get_main_queue()];
}

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval
                        callBack:(dispatch_block_t)callBack
                           start:(BOOL)start
                             idf:(NSString *)idf
                           queue:(dispatch_queue_t)queue {
    
    if (idf.length <= 0) {
        NSLog(@"tl -- 定时器的标识不合法,idf===%@",idf);
        return;
    }
    
    if (!self.timerDict) {
        self.timerDict = [NSMutableDictionary dictionary];
    }
    
    NSMutableDictionary *timerItem = self.timerDict[idf];
    
    if (timerItem) {
        NSLog(@"tl -- 定时器已存在,不需要重复添加,idf===%@",idf);
        return;
    }
    
    dispatch_queue_t tiemrQueue = queue ? queue : dispatch_get_main_queue();
    
    timerItem = [NSMutableDictionary dictionary];
    timerItem[self.keyQueue] = tiemrQueue;
    timerItem[self.keyTimeInterval] = @(interval);
    timerItem[self.keyWorking] = @(start ? YES : NO);
    if (callBack) {
        timerItem[self.keyCallback] = callBack;
    }
    
    dispatch_source_t timer = [self createTimerWithTimerItem:timerItem];
    if (timer) {
        timerItem[self.keyTimer] = timer;
        if (start) {
            dispatch_resume(timer);
        }
    }
    self.timerDict[idf] = timerItem;
}

- (void)startTimerByIdf:(NSString *)idf {
    NSMutableDictionary *timerItem = self.timerDict[idf];
    if (!timerItem) {
        NSLog(@"tl -- startTimer 该标识没有存储的定时器,idf===%@",idf);
        return;
    }
    
    NSNumber *working = timerItem[self.keyWorking];
    if (working.boolValue) {
        NSLog(@"tl -- startTimer 定时器正在工作,idf===%@",idf);
        return;
    }
    
    dispatch_source_t timer = timerItem[self.keyTimer];
    if (timer) {
        NSLog(@"tl -- startTimer 定时器已存在,直接启动,idf===%@",idf);
        dispatch_resume(timer);
        timerItem[self.keyWorking] = @(YES);
        self.timerDict[idf] = timerItem;
    } else {
        dispatch_source_t timer = [self createTimerWithTimerItem:timerItem];
        if (timer) {
            dispatch_resume(timer);///<启动定时器
            timerItem[self.keyWorking] = @(YES);
            timerItem[self.keyTimer] = timer;
            self.timerDict[idf] = timerItem;
            NSLog(@"tl -- startTimer 重建定时器并启动,idf===%@",idf);
        }
    }
}

- (void)stopTimerByIdf:(NSString *)idf {
    NSMutableDictionary *timerItem = self.timerDict[idf];
    if (!timerItem) {
        NSLog(@"tl -- stopTimer 该标识没有存储的定时器,idf===%@",idf);
        return;
    }
    
    NSNumber *working = timerItem[self.keyWorking];
    if (!working.boolValue) {
        NSLog(@"tl -- stopTimer 定时器没有工作，不在重复停止,idf===%@",idf);
        return;
    }
    
    dispatch_source_t timer = timerItem[self.keyTimer];
    if (timer) {
        dispatch_cancel(timer);///<启动定时器
        timerItem[self.keyWorking] = @(NO);
        [timerItem removeObjectForKey:self.keyTimer];
        self.timerDict[idf] = timerItem;
        NSLog(@"tl -- stopTimer 停止定时器并移除,idf===%@",idf);
    }
}

- (void)destroyTimerByIdf:(NSString *)idf {
    NSMutableDictionary *timerItem = self.timerDict[idf];
    if (!timerItem) {
        NSLog(@"tl -- destroyTimer 该标识没有定时器,idf===%@",idf);
        return;
    }
    dispatch_source_t timer = timerItem[self.keyTimer];
    if (timer) {
        dispatch_cancel(timer);///<启动定时器
        timerItem[self.keyWorking] = @(NO);
    }
    [self.timerDict removeObjectForKey:idf];
    NSLog(@"tl -- destroyTimer 定时器已被销毁,idf===%@",idf);
}

#pragma mark - setter and getter

- (void)setTimerDict:(NSMutableDictionary *)timerDict {
    objc_setAssociatedObject(self, @selector(timerDict), timerDict, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableDictionary *)timerDict {
    return objc_getAssociatedObject(self, @selector(timerDict));
}

- (NSString *)keyTimer {
    return @"timer";
}

- (NSString *)keyWorking {
    return @"working";
}

- (NSString *)keyCallback {
    return @"callback";
}

- (NSString *)keyTimeInterval {
    return @"timeInterval";
}

- (NSString *)keyQueue {
    return @"queue";
}

#pragma mark - private function

///创建定时器
- (dispatch_source_t)createTimerWithTimerItem:(NSMutableDictionary *)timerItem {
    if (!timerItem) {
        return nil;
    }
    dispatch_queue_t queue = timerItem[self.keyQueue];
    NSNumber *interval = timerItem[self.keyTimeInterval];
    dispatch_block_t callback = timerItem[self.keyCallback];
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t startTime = DISPATCH_TIME_NOW;
    uint64_t timeInterval = (uint64_t)(interval.integerValue * NSEC_PER_SEC);///<定时器间隔时长
    dispatch_source_set_timer(timer, startTime, timeInterval, 0);///<允许误差
    dispatch_source_set_event_handler(timer, ^{
        ///定时器需要执行的操作
        if (callback) {
            callback();
        }
    });
    return timer;
}


@end
