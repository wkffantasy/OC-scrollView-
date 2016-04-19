//
//  WKFCircularSlidingView.h
//  scrollView的滑动
//
//  Created by fantasy on 15/11/6.
//  Copyright © 2015年 fantasy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WKFCircularSlidingViewDelegate <NSObject>

-(void)clickCircularSlidingView:(int)tag;

@end

@interface WKFCircularSlidingView : UIView

//用来接受图片的数组
@property (nonatomic,strong) NSArray * imagesArray;

//scrollView的宽度
@property (nonatomic,assign) CGFloat scrollWidth;

@property (nonatomic,weak)id<WKFCircularSlidingViewDelegate>delegate;


@end
