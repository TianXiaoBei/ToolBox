//
//  ViewController.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/24.
//

#import "ViewController.h"
#import "NSObject+TBoxTimer.h"
#import "NSObject+Notification.h"
#import "OneViewController.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL working;
@property (nonatomic, strong) OneViewController *oneVc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(clickedToDestroyTimer) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"销毁定时器" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 100, 100, 40);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [self addTimer];
    [self addNotification];
}

#pragma mark - 添加通知

- (void)addNotification {
    [self tb_addObserverWithName:UIApplicationWillEnterForegroundNotification callback:^(NSNotification *note) {
        NSLog(@"tl -- WillEnterForeground -- %s",__func__);
    }];
    [self tb_addObserverWithName:UIApplicationDidEnterBackgroundNotification callback:^(NSNotification *note) {
        NSLog(@"tl -- Background -- %s",__func__);
    }];
    [self tb_addObserverWithName:@"OneVcPush" callback:^(NSNotification *note) {
        NSLog(@"tl -- received OneVcPush,note.obj = %p,self.oneVc = %p",note.object,self.oneVc);
    }];
}

#pragma mark - 添加定时器

- (void)addTimer {
    [self tb_addTimerWithTimeInterval:1 callBack:^{
        NSLog(@"------123");
    } start:YES idf:@"123"];
    [self tb_addTimerWithTimeInterval:1 callBack:^{
        NSLog(@"------456");
    } start:YES idf:@"456" queue:dispatch_get_global_queue(0, 0)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.working = !self.working;
    if (self.working) {
        [self tb_stopTimerByIdf:@"123"];
        [self tb_stopTimerByIdf:@"456"];
    } else {
        [self tb_startTimerByIdf:@"123"];
        [self tb_startTimerByIdf:@"456"];
    }
//    [self tb_removeObserverWithName:UIApplicationWillEnterForegroundNotification];
    [self tb_removeAllObserver];
}

- (void)clickedToDestroyTimer {
    [self tb_destroyTimerByIdf:@"123"];
//    self.oneVc = [[OneViewController alloc] init];
//    self.oneVc.title = @"测试通知监听";
//    self.oneVc.view.backgroundColor = [UIColor redColor];
//    [self.navigationController pushViewController:self.oneVc animated:YES];
    
    OneViewController *testVc = [[OneViewController alloc] init];
    testVc.title = @"测试通知监听";
    testVc.view.backgroundColor = [UIColor redColor];
    [self.navigationController pushViewController:testVc animated:YES];
}

@end
