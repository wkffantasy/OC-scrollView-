//
//  WKFCircularSlidingView.m
//  scrollView的滑动
//
//  Created by fantasy on 15/11/6.
//  Copyright © 2015年 fantasy. All rights reserved.
//

#import "WKFCircularSlidingView.h"

//#define myWidth  [UIScreen mainScreen].bounds.size.width
//#define myHeight [UIScreen mainScreen].bounds.size.height

@interface WKFCircularSlidingView ()<UIScrollViewDelegate>

@property (nonatomic,weak)UIPageControl *myPageControl;

@property (nonatomic,weak)UIScrollView *myScrollView;

@property (nonatomic,strong)NSMutableArray *myImagesArray;

@property (nonatomic,strong)NSTimer *myTimer;

@end

@implementation WKFCircularSlidingView


-(instancetype)initWithFrame:(CGRect)frame{
  
  if (self = [super initWithFrame:frame]) {
    
    //创建子控件
    [self setupChildViews];
    
  }
  return self;
  
}
//创建子控件
-(void)setupChildViews{
  
  //创建scrollView
  UIScrollView *scrollView = [[UIScrollView alloc]init];
  scrollView.bounces=NO;
  scrollView.delegate=self;
  scrollView.pagingEnabled=YES;
  scrollView.showsHorizontalScrollIndicator=NO;
  _myScrollView=scrollView;
  [self addSubview:scrollView];
  
  
  
  //创建pageControl
  UIPageControl * pageControl = [[UIPageControl alloc]init];
  pageControl.userInteractionEnabled=NO;
  pageControl.currentPageIndicatorTintColor =[UIColor redColor];
  pageControl.pageIndicatorTintColor = [UIColor whiteColor];
  _myPageControl = pageControl;
  [self addSubview:pageControl];
  
  
  
}
#pragma mark - 点击轮播图中任意一个图片的时候
-(void)clickScrollViewImage:(UITapGestureRecognizer *)tap{
  
  //设置tag
  int tag =(int)tap.view.tag-100;
  if (tag==self.myImagesArray.count-1) {
    tag=1;
  }else if (tag==0){
    tag=(int)self.myImagesArray.count-2;
  }else{
    
  }
  
  //通知代理做事情
  if ([_delegate respondsToSelector:@selector(clickCircularSlidingView:)]) {
    [_delegate clickCircularSlidingView:tag];
  }
  
  
}

#pragma mark - UIScrollViewDelegate代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGFloat x = scrollView.contentOffset.x;
  
  NSInteger page = x / self.bounds.size.width -1;
  self.myPageControl.currentPage = page;
  
  CGPoint point =scrollView.contentOffset;
  
  if (point.x==0) {
    [self.myScrollView setContentOffset:CGPointMake(self.bounds.size.width*(self.myImagesArray.count-2), 0) animated:NO];
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

#pragma mark - 计时器
//添加计时器
- (void)addTimer {
  
  self.myTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
  [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
}

//移除计时器
- (void)removeTimer {
  
  [self.myTimer invalidate];
  
  self.myTimer = nil;
  
}

//计时器运行的方法
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

-(void)setImagesArray:(NSArray *)imagesArray{
  
  _imagesArray = imagesArray;
  
  if (self.imagesArray.count==0) {
    
    return;
    
  }
  
  for (int i=0; i<self.imagesArray.count; i++) {
    
    NSString * imageString =self.imagesArray[i];
    [self.myImagesArray addObject:imageString];
    
  }
  
  if (self.imagesArray.count==1) {
    
    //填充scrollView的contentSize
    [self setupScrollViewSubviews];
    return ;
  }
  
  //把最后一个图片添加到这个数组的第一个位置
  NSString * imageString1 = [self.imagesArray lastObject];
  [self.myImagesArray insertObject:imageString1 atIndex:0];
  
  //把原本第一张的图片 添加到这个数组的末尾
  NSString * imageString2 = [self.imagesArray firstObject];
  [self.myImagesArray addObject:imageString2];
  
  //填充scrollView的contentSize
  [self setupScrollViewSubviews];
  
  
  
  
  
}

//填充scrollView的contentSize
-(void)setupScrollViewSubviews{
  
  //给scrollView添加图片
  for (int i = 0; i < self.myImagesArray.count; i++) {
    
    UIImageView *myImageView = [[UIImageView alloc]init];
    
    NSString *imageName = self.myImagesArray[i];
    myImageView.image = [UIImage imageNamed:imageName];
    myImageView.userInteractionEnabled=YES;
    myImageView.tag=i+100;
    [self.myScrollView addSubview:myImageView];
    
    //添加手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickScrollViewImage:)];
    [myImageView addGestureRecognizer:tap];
    
    
  }
  
  
  if (self.myImagesArray.count==1) {
    
    self.myScrollView.contentSize = CGSizeMake(self.bounds.size.width, 0);
    self.myScrollView.scrollEnabled=NO;
    [self removeTimer];
    self.myPageControl.numberOfPages=1;
    
  }else{
    self.myScrollView.contentSize = CGSizeMake(self.bounds.size.width * self.myImagesArray.count, 0);
    [self.myScrollView setContentOffset:CGPointMake(self.bounds.size.width, 0) animated:NO];
    self.myPageControl.numberOfPages= self.myImagesArray.count-2;
    [self addTimer];
    
  }

}


-(NSMutableArray *)myImagesArray{
  
  if (_myImagesArray==nil) {
    
    _myImagesArray =[NSMutableArray array];
  }
  return _myImagesArray;
  
}

-(void)layoutSubviews{
  
  [super layoutSubviews];
  
  //轮播图的frame
  self.myScrollView.frame=self.bounds;
  
  //pageControl的frame
  CGFloat pageControlH = 20;
  CGFloat pageControlW = self.bounds.size.width;
  CGFloat pageControlY = self.frame.size.height - pageControlH;
  CGFloat pageControlX = 0;
  self.myPageControl.frame=CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
  
  //scrollView添加的图片的frame
  for (UIImageView *myImageView in self.myScrollView.subviews) {
    
    int i =(int)myImageView.tag-100;
    
    myImageView.frame=CGRectMake(i*self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
  }
  

  
}



@end
