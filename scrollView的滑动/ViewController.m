//
//  ViewController.m
//  scrollView的滑动
//
//  Created by fantasy on 15/11/6.
//  Copyright © 2015年 fantasy. All rights reserved.
//

#import "ViewController.h"

#import "WKFCircularSlidingView.h"

#define myWidth  [UIScreen mainScreen].bounds.size.width
#define myHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<WKFCircularSlidingViewDelegate>

@property (nonatomic,strong)NSMutableArray *firstViewImageArray;

@property (nonatomic,weak) UILabel * statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
  //第一个scrollView
  WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]init];
#warning  先设置frame  在给图片
  firstView.frame=CGRectMake(0, 70, myWidth, myWidth * 400 / 640);
  firstView.delegate=self;
  firstView.imagesArray = self.firstViewImageArray;
  [self.view addSubview:firstView];
  
  //label
  UILabel *statusLabel = [[UILabel alloc]init];
  statusLabel.textAlignment = NSTextAlignmentCenter;
  statusLabel.frame=CGRectMake(0, CGRectGetMaxY(firstView.frame) + 30, myWidth, 30);
  statusLabel.text = @"还没有上面点击图片";
  _statusLabel=statusLabel;
  [self.view addSubview:statusLabel];

}
#pragma mark -WKFCircularSlidingViewDelegate代理方法
-(void)clickCircularSlidingView:(int)tag{
  
  _statusLabel.text = [NSString stringWithFormat:@"点击了第  %d  张图",tag];
  
}



-(NSMutableArray *)firstViewImageArray{
  
  if (_firstViewImageArray==nil) {
    
    _firstViewImageArray = [NSMutableArray array];
    
#warning 改变imageCount的个数 最多是9
    //图片的个数 可以控制
    int imageCount = 2;
    for (int i = 0; i < imageCount; i++) {
      
      NSString *imageName = [NSString stringWithFormat:@"%02d",i+1];
      [_firstViewImageArray addObject:imageName];
      
    }
    
    
  }
  return _firstViewImageArray;
}


@end
