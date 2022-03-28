//
//  NSObject+TBoxTimer.h
//  SafeDemo
//
//  Created by tianlong on 2022/3/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (TBoxTimer)

- (void)tb_addTimerWithTimeInterval:(NSTimeInterval)interval
                           callBack:(dispatch_block_t)callBack
                              start:(BOOL)start
                                idf:(NSString *)idf;
- (void)tb_addTimerWithTimeInterval:(NSTimeInterval)interval
                           callBack:(dispatch_block_t)callBack
                              start:(BOOL)start
                                idf:(NSString *)idf
                              queue:(dispatch_queue_t)queue;
/// 开始计时
- (void)tb_startTimerByIdf:(NSString *)idf;
/// 停止计时
- (void)tb_stopTimerByIdf:(NSString *)idf;
/// 销毁计时
- (void)tb_destroyTimerByIdf:(NSString *)idf;

@end

NS_ASSUME_NONNULL_END
