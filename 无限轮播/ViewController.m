//
//  ViewController.m
//  无限轮播
//
//  Created by 马延玉 on 16/3/14.
//  Copyright © 2016年 yyMae. All rights reserved.
//

#import "ViewController.h"
#import "YYCarouselView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    YYCarouselView *VCCC = [[YYCarouselView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) withPictures:@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"]];
    [self.view addSubview:VCCC];
}



@end
