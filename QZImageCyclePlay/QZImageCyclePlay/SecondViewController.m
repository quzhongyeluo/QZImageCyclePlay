//
//  SecondViewController.m
//  QZImageCyclePlay
//
//  Created by 曲终叶落 on 2017/9/17.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "SecondViewController.h"
#import "QZImageCyclePlayView.h"

@interface SecondViewController () <QZImageCyclePlayViewDelegate>

@property (nonatomic,strong) QZImageCyclePlayView *cycleView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSArray *urls = @[
                      @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/02/0A/ChMkJlfRN5OIBhN-AAqhbWa1sY8AAVHsAFOG8AACqGF953.jpg?downfile=150563938773.jpg",
                      @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/02/0A/ChMkJ1fRN4qIPFMsAArBZJOZNwoAAVHrwHEybAACsF8427.jpg?downfile=1505639372696.jpg",
                      @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/02/0A/ChMkJlfRN4mIV7OTAAjZ5WOnSCsAAVHrwFEzJEACNn9401.jpg?downfile=1505639367655.jpg",
                      @"http://desk.fd.zol-img.com.cn/t_s1920x1080c5/g5/M00/02/0A/ChMkJlfRN5CILdPwAAmonBxvbqkAAVHrwPtuLMACai0391.jpg?downfile=1505639354560.jpg"
                      ];
    
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:urls.count];
    
    for (int i = 0; i < urls.count; i ++) {
        NSString *title = [NSString stringWithFormat:@"第%d张图片",i+1];
        [titles addObject:title];
    }

    QZImageCyclePlayView *cycleView = [[QZImageCyclePlayView alloc] initWithFrame:(CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 9/16)) imagesurl:urls autoPlay:true delay:2 titles:titles];
    cycleView.delegate = self;
    [self.view addSubview:cycleView];
    self.cycleView = cycleView;

}


#pragma mark - QZImageCyclePlayViewDelegate
- (void)imageCyclePlayViewClickIndex:(NSInteger)index {
    NSLog(@"点击了第%ld张图片",index + 1);
}

- (void)dealloc {
    [self.cycleView stopCycle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
