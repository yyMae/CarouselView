//
//  YYCarouselView.m
//  无限轮播
//
//  Created by yyMae on 16/3/14.
//  Copyright © 2016年 yyMae. All rights reserved.
//

#import "YYCarouselView.h"
#define kWIDTH self.bounds.size.width
#define kHEIGHT self.bounds.size.height

@interface YYCarouselView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSArray *picture_array;//存放图片名称的数组
@property (nonatomic, assign) NSInteger index;//记录数组的下标
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageController;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YYCarouselView
//初始化

- (instancetype)initWithFrame:(CGRect)frame withPictures:(NSArray *)picture_array{
    self = [super initWithFrame:frame];
    if (self) {
        self.picture_array = picture_array;
        self.index = 0;
        [self addSubview:self.scrollView];
        [self addImgViewToScrollView];
        [self addSubview:self.pageController];
        [self initTimer];
    }
    return self;

}

//懒加载
-(NSArray *)picture_array{
    if (!_picture_array) {
        _picture_array = [[NSArray alloc]init];
    }
    return _picture_array;
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;//隐藏滚动条
        _scrollView.pagingEnabled = YES;//设置分页
        _scrollView.contentSize = CGSizeMake(kWIDTH * 3, 0);//设置可滑尺寸
        _scrollView.contentOffset = CGPointMake(kWIDTH, 0);//设置初始偏移量
    }
    return _scrollView;
}
-(UIPageControl *)pageController{
    if (!_pageController) {
        _pageController = [[UIPageControl alloc]initWithFrame:CGRectMake(kWIDTH - 100, kHEIGHT - 50, 100, 50)];
        _pageController.numberOfPages = self.picture_array.count;//圆点个数
        _pageController.currentPage = 0;//初始选中第一个圆点
        _pageController.pageIndicatorTintColor = [UIColor whiteColor];//圆点颜色
        _pageController.currentPageIndicatorTintColor = [UIColor greenColor];//当前圆点颜色
        _pageController.enabled = NO;//由于后面要添加计时器,所以此处取消圆点选中事件
        
    }
    return _pageController;
}
//往sctollView上添加imgView:初始时让第二个imgView显示第一张图片(三图轮播,因此只创建三个imgView即可,始终让中间的imgView显示当前图片)
- (void)addImgViewToScrollView{
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH * i, 0, kWIDTH, kHEIGHT)];
        imgView.tag = 1000 + i;//添加标记,方便后面找到
        if (i == 0) {
            imgView.image = [UIImage imageNamed:self.picture_array.lastObject];
        }
        if (i == 1) {
            imgView.image = [UIImage imageNamed:self.picture_array.firstObject];
        }
        if (i == 2) {
            imgView.image = [UIImage imageNamed:self.picture_array[1]];
        }
        imgView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:imgView];
    }
}
//scrollView结束减速时执行
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x >= kWIDTH) {
        //根据偏移量是向左还是右分别控制index的值
        if (self.index == self.picture_array.count - 1) {
            self.index = 0;
        }else{
            self.index ++;
        }
    }else{
        if (self.index == 0) {
            self.index = self.picture_array.count -1;
        }else{
            self.index --;
        }
    }
    //调整好index的值之后重新设置下偏移量以及当前选中的圆点
    [self.scrollView setContentOffset:CGPointMake(kWIDTH, 0) animated:NO];
    self.pageController.currentPage = self.index;
    //让中间的imgView始终显示index位置的图片(中心思想)
    [self addImage:self.index];
}

// 改变imageView显示的图片名称
- (void)addImage:(NSInteger)index{
    //找到添加到scrollView上的imgView
    UIImageView *imageView1 = (UIImageView *)[self.scrollView viewWithTag:1000];
    UIImageView *imageView2 = (UIImageView *)[self.scrollView viewWithTag:1001];
    UIImageView *imageView3 = (UIImageView *)[self.scrollView viewWithTag:1002];
    if (index == self.picture_array.count - 1){
        imageView1.image = [UIImage imageNamed:self.picture_array[index-1]];
        imageView2.image = [UIImage imageNamed:self.picture_array[index]];
        imageView3.image = [UIImage imageNamed:self.picture_array[0]];
    }
    else if (index == 0){
        imageView1.image = [UIImage imageNamed:self.picture_array.lastObject];
        imageView2.image = [UIImage imageNamed:self.picture_array[index]];
        imageView3.image = [UIImage imageNamed:self.picture_array[1+index]];
    }
    else{
        imageView1.image = [UIImage imageNamed:self.picture_array [index-1]];
        imageView2.image = [UIImage imageNamed:self.picture_array[index]];
        imageView3.image = [UIImage imageNamed:self.picture_array[index+1]];
    }
    
}
//创建计时器
- (void)initTimer{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(loadScrollViewImage) userInfo:nil repeats:YES];
}
//计时器要执行的方法:每次执行改变偏移量
- (void)loadScrollViewImage{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + kWIDTH, 0) animated:YES] ;
}

//偏移量改变并且有滚动动画才会执行该方法,内部代码与上面结束减速(scrollViewDidEndDecelerating:)要执行的代码相同
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //NSLog(@"11111");
    if (scrollView.contentOffset.x >= kWIDTH) {
        //根据偏移量是向左还是右分别控制index的值
        if (self.index == self.picture_array.count - 1) {
            self.index = 0;
        }else{
            self.index ++;
        }
    }else{
        if (self.index == 0) {
            self.index = self.picture_array.count -1;
        }else{
            self.index --;
        }
    }
    //调整好index的值之后重新设置下偏移量以及当前选中的圆点
    [self.scrollView setContentOffset:CGPointMake(kWIDTH, 0) animated:NO];
    self.pageController.currentPage = self.index;
    //让中间的imgView始终显示index位置的图片(中心思想)
    [self addImage:self.index];
}

//防止计时器与拖动手势冲突
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.timer invalidate] ;
    self.timer = nil ;
}
//拖拽结束时开启一个新的计时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self initTimer] ;
}

@end
