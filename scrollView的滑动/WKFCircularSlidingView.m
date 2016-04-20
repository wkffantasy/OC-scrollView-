//
//  WKFCircularSlidingView.m
//  scrollView的滑动
//
//  Created by fantasy on 15/11/6.
//  Copyright © 2015年 fantasy. All rights reserved.
//

#import "WKFCircularSlidingView.h"

#import "Masonry.h"

#define  pageControlH  20

@interface WKFCircularSlidingView () <UIScrollViewDelegate>

@property (copy,nonatomic)    ClickImageBlock clickImage;

@property (weak,nonatomic)    UIPageControl *myPageControl;

@property (weak,nonatomic)    UIScrollView *myScrollView;

@property (strong,nonatomic)  NSArray *myImagesArray;

@property (strong,nonatomic)  NSTimer *myTimer;

@property (assign, nonatomic) CGFloat timeToChange;


@end

@implementation WKFCircularSlidingView

- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)imagesArray andClickImageBlock:(ClickImageBlock)clickImageBlock withChangeAnImageTime:(CGFloat)time{
  
  if (self = [super initWithFrame:frame]) {
   
    if (0 >= time) {
      self.timeToChange = 3.f;
    } else {
      self.timeToChange = time;
    }
    self.clickImage = clickImageBlock;
    
    [self initWithImagesArray:imagesArray];
    
    [self setupChildViews];
    
  }
  return self;
  
}

//创建子控件
-(void)setupChildViews{
  
  NSAssert(self.myImagesArray.count !=2 , @"");
  NSAssert(self.myImagesArray.count !=3 , @"");
  
  //scrollView
  UIScrollView *scrollView = [[UIScrollView alloc]init];
  scrollView.bounces=NO;
  scrollView.delegate=self;
  scrollView.pagingEnabled=YES;
  scrollView.showsHorizontalScrollIndicator=NO;
  scrollView.contentSize = CGSizeMake(self.frame.size.width * self.myImagesArray.count, self.frame.size.height);
  _myScrollView=scrollView;
  [self addSubview:scrollView];
  
  //pageControl
  UIPageControl * pageControl = [[UIPageControl alloc]init];
  pageControl.userInteractionEnabled=NO;
  pageControl.currentPageIndicatorTintColor =[UIColor redColor];
  pageControl.pageIndicatorTintColor = [UIColor greenColor];
  if (self.myImagesArray.count == 1) {
    pageControl.numberOfPages = self.myImagesArray.count;
  } else {
    
    pageControl.numberOfPages = self.myImagesArray.count - 2;
    
  }
  pageControl.currentPage = 0;
  _myPageControl = pageControl;
  [self addSubview:pageControl];
  
  //imageViews
  UIImageView * lastView = nil;
  for (int i = 0; i < self.myImagesArray.count; i++) {
    
    UIImageView *myImageView = [[UIImageView alloc]init];
    
    NSString *imageName = self.myImagesArray[i];
    myImageView.image = [UIImage imageNamed:imageName];
    myImageView.userInteractionEnabled=YES;
    myImageView.tag=i+100;
    [self.myScrollView addSubview:myImageView];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScrollViewImage:)];
    [myImageView addGestureRecognizer:tap];
    
    myImageView.frame = CGRectMake(i * self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    
    lastView = myImageView;
  }
  
  if (self.myImagesArray.count != 1) {
    
    [self.myScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    [self addTimer];
  }
  
  [_myScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
    
    make.top.and.right.and.left.and.bottom.mas_equalTo(0);
    
  }];
  [_myPageControl mas_makeConstraints:^(MASConstraintMaker *make) {
    make.bottom.and.right.and.left.mas_equalTo(0);
    make.height.mas_equalTo(pageControl);
  }];

}

#pragma mark - 点击轮播图中任意一个图片的时候
-(void)clickScrollViewImage:(UITapGestureRecognizer *)tap{
  
  if (self.clickImage) {
    self.clickImage((int)self.myPageControl.currentPage);
  }

}

#pragma mark - UIScrollViewDelegate代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat x = scrollView.contentOffset.x;
  
  NSInteger page = x / self.bounds.size.width -1;
  self.myPageControl.currentPage = page;
  
  CGPoint point =scrollView.contentOffset;
  
  if (point.x==0) {
    
    [self.myScrollView setContentOffset:CGPointMake(self.bounds.size.width * (self.myImagesArray.count-2), 0) animated:NO];
    
  }else if (point.x==self.bounds.size.width*(self.myImagesArray.count-1)){
    
    [self.myScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    
  }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
  [self removeTimer];
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
  [self addTimer];
  
}

#pragma mark - myTimer
- (void)addTimer {
  
  self.myTimer = [NSTimer scheduledTimerWithTimeInterval:self.timeToChange target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer {
  
  [self.myTimer invalidate];
  
  self.myTimer = nil;
  
}

-(void)runTimer{
  
  NSInteger page = self.myPageControl.currentPage;
  
  CGFloat x = 0;

  if (page == self.myImagesArray.count - 3) {
    
    x = self.bounds.size.width * (self.myImagesArray.count-1);
    
  }else {
    
    x = self.bounds.size.width * (page+2);
    
  }
  
  [self.myScrollView setContentOffset:CGPointMake(x, 0) animated:YES];
  
}

- (void)initWithImagesArray:(NSArray *)imagesArray{
  
  NSAssert(imagesArray.count>0, @"");
  
  if (imagesArray.count == 1) {
    self.myImagesArray = imagesArray;
    return;
  }
  
  NSMutableArray * temArray = [[NSMutableArray alloc]initWithArray:imagesArray];
  
  NSString * lastImage = [imagesArray lastObject];
  [temArray insertObject:lastImage atIndex:0];

  NSString * firstImage = [imagesArray firstObject];
  [temArray addObject:firstImage];
  
  self.myImagesArray = temArray;
  
  NSAssert(self.myImagesArray.count == imagesArray.count+2, @"");

}



@end
