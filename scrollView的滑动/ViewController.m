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

@interface ViewController ()

@property (nonatomic,strong)NSMutableArray *firstViewImageArray;

@property (nonatomic,weak) UILabel * statusLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  __weak typeof(self)weakSelf = self;
  
  CGFloat scrollWidth = 300;
  CGFloat scrollHeight = scrollWidth * 40 / 64;
  
  CGRect frame=CGRectMake(0, 70, scrollWidth, scrollHeight);
  
  //scrollView
  WKFCircularSlidingView * firstView = [[WKFCircularSlidingView alloc]initWithFrame:frame ImagesArray:self.firstViewImageArray andClickImageBlock:^(int tag) {
    
    weakSelf.statusLabel.text = [NSString stringWithFormat:@"点击了第  %d  张图",tag];
    
  } withChangeAnImageTime:3];
  
  [self.view addSubview:firstView];
  
  //label
  UILabel *statusLabel = [[UILabel alloc]init];
  statusLabel.textAlignment = NSTextAlignmentCenter;
  statusLabel.frame=CGRectMake(0, CGRectGetMaxY(firstView.frame) + 30, myWidth, 30);
  statusLabel.text = @"还没有上面点击图片";
  _statusLabel=statusLabel;
  [self.view addSubview:statusLabel];

}


- (NSMutableArray *)firstViewImageArray{
  
  if (_firstViewImageArray==nil) {
    
    _firstViewImageArray = [NSMutableArray array];
    
    // 改变imageCount的个数 最多是9
    int imageCount = 4;
    for (int i = 0; i < imageCount; i++) {
      
      NSString *imageName = [NSString stringWithFormat:@"%02d",i+1];
      [_firstViewImageArray addObject:imageName];
      
    }
  }
  return _firstViewImageArray;
}


@end
