//
//  NSObject+Timer.h
//  SafeDemo
//
//  Created by tianlong on 2022/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Timer)

- (void)addTimerWithTimeInterval:(NSTimeInterval)interval
                        callBack:(dispatch_block_t)callBack
                           start:(BOOL)start
                             idf:(NSString *)idf;
- (void)addTimerWithTimeInterval:(NSTimeInterval)interval
                        callBack:(dispatch_block_t)callBack
                           start:(BOOL)start
                             idf:(NSString *)idf
                           queue:(dispatch_queue_t)queue;

/// 开始计时
- (void)startTimerByIdf:(NSString *)idf;
/// 停止计时
- (void)stopTimerByIdf:(NSString *)idf;
/// 销毁计时
- (void)destroyTimerByIdf:(NSString *)idf;

@end

NS_ASSUME_NONNULL_END
