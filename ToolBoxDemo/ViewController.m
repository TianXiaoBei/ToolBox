//
//  ViewController.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/24.
//

#import "ViewController.h"
#import "NSObject+Timer.h"
#import "NSObject+Notification.h"

@interface ViewController ()
@property (nonatomic, assign) BOOL working;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addTimer];
    [self tb_addObserverWithName:UIApplicationWillEnterForegroundNotification callback:^(NSNotification *note) {
        NSLog(@"tl -- tb_addObserverWithName,UIApplicationWillEnterForegroundNotification");
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
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(clickedToDestroyTimer) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"销毁定时器" forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 100, 100, 40);
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
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
}

- (void)clickedToDestroyTimer {
    [self tb_destroyTimerByIdf:@"123"];
}

@end
