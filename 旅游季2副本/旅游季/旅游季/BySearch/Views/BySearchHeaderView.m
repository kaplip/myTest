//
//  BySearchHeaderView.m
//  旅游季
//
//  Created by niit on 16/1/10.
//  Copyright © 2016年 niit. All rights reserved.
//

#import "BySearchHeaderView.h"

#import "CustomCell.h"

#define ScreenW  [UIScreen mainScreen].bounds.size.width
#define ScrollerH 160
#define CollectionViewH 180
#define  PageC_W(i) i*20
#define CellMarginW (ScreenW - 100*2)/3
#define CellMarginH 10
#define Cell_W 30
#define  Cell_H Cell_W
@interface BySearchHeaderView()<UIScrollViewDelegate,SortOnChoiceDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) NSArray *imageNameArr;

@end

@implementation BySearchHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
    }
    return self;
}

- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((ScreenW - PageC_W(_imageNameArr.count))/2, 130, PageC_W(_imageNameArr.count), 20)];
        _pageControl.numberOfPages =_imageNameArr.count;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}


- (void)initUI{
    self.userInteractionEnabled = YES;
      [self initScrollerView];
      [self initSearchSortView];
      [self addSubview:self.pageControl];
}

- (void)initScrollerView{
    
    _scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScrollerH)];
    _imageNameArr = @[@"r1",@"r2",@"r3"];
    
    for (int i = 0; i<_imageNameArr.count; i++) {
        UIImageView *scrollImage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenW*i, 0, ScreenW, ScrollerH)];
        [scrollImage setImage:[UIImage imageNamed:_imageNameArr[i]] ];
        [_scrollerView addSubview:scrollImage];
        
    }
    
    [_scrollerView setContentSize:CGSizeMake(_imageNameArr.count*ScreenW, 0)];
    _scrollerView.showsHorizontalScrollIndicator =   NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.bounces = NO;
    _scrollerView.delegate = self;
    _scrollerView.pagingEnabled = YES;
    
    [self addSubview:_scrollerView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.pageControl.currentPage = scrollView.contentOffset.x/ScreenW+0.5;
}


- (void)initSearchSortView{
    
    NSArray *arr = @[@"地图",@"天气",@"美食",@"景点"];
    NSArray *imageNames = @[@"map",@"weather",@"food",@"tree"];
    
    UIView *sortView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollerView.frame)+10, ScreenW,125)];
    [sortView setBackgroundColor:[UIColor whiteColor]];
    
    for (int i = 0; i<4; i++) {
        
        int row = i/2;
        int col = i%2;
        
        CustomCell *cell = [[CustomCell alloc]initWithFrame:CGRectMake(CellMarginW+(CellMarginW+100)*col, CellMarginH+(CellMarginH+50)*row, 130, 30)];
       
        cell.imageName = imageNames[i];
        cell.sortTag = 100+i;
        cell.sortTitle = arr[i];
        cell.delegate = self;
        [sortView addSubview:cell];
    }

    [self addSubview:sortView];
}


- (void)sortButtonOnClick:(CustomCell *)cell{
    
    if (self.sortDelegate &&[self.sortDelegate respondsToSelector:@selector(didChoiceSort:)]) {
        [self.sortDelegate didChoiceSort:cell];
    }
    
}

@end
