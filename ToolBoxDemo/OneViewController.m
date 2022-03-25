//
//  OneViewController.m
//  ToolBoxDemo
//
//  Created by tianlong on 2022/3/25.
//

#import "OneViewController.h"
#import "NSObject+TBoxNotification.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tb_addObserverWithName:UIApplicationWillEnterForegroundNotification callback:^(NSNotification *note) {
        NSLog(@"tl -- WillEnterForeground %s",__FUNCTION__);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OneVcPush" object:self];
 }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
