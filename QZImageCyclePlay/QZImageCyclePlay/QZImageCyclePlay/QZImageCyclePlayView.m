//
//  QZImageCyclePlayView.m
//  QZImageCyclePlay
//
//  Created by 曲终叶落 on 2017/9/17.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "QZImageCyclePlayView.h"
#import "UIImageView+WebCache.h"

@interface QZImageCyclePlayView() <UIScrollViewDelegate>

/**
 图片链接
 */
@property (nonatomic,copy) NSArray *imagesurl;

/**
 标题
 */
@property (nonatomic,copy) NSArray *titles;


/**
 是否自动切换
 */
@property (nonatomic,assign) BOOL isAuto;


/**
 自动切换时间
 */
@property (nonatomic,assign) NSTimeInterval timeInterval;

/**
 当前页
 */
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *currentImages;

@property (nonatomic, strong) NSMutableArray *currentTitles;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIPageControl *pageControl;

/**
 标题
 */
@property (nonatomic,strong) UILabel *titleLb;

@end


@implementation QZImageCyclePlayView

static CGFloat PageHeight = 20;

static CGFloat TitleHeight = 32;

- (instancetype)initWithFrame:(CGRect)frame imagesurl:(NSArray *)imagesurl autoPlay:(BOOL)isAuto delay:(NSTimeInterval)timeInterval titles:(NSArray *)titles{
    
    if (self = [super initWithFrame:frame]) {
        self.imagesurl = imagesurl;
        self.titles = titles;
        self.isAuto = isAuto;
        self.timeInterval = timeInterval;
        
        [self scrollView];
        
        [self pageControl];
        
        if (self.isAuto) {
            [self toPlay];
        }
        
        self.titleLb.text = self.titles[0];
        
    }
    return self;
}


- (void)toPlay{
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:self.timeInterval];
}
- (void)autoPlayToNextPage{
    
    //取消前面的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width * 2, 0) animated:YES];
    
    [self performSelector:@selector(autoPlayToNextPage) withObject:nil afterDelay:self.timeInterval];
}

//更新图片
- (void)refreshImages{
    
    NSLog(@"循环滚动View还在进行中");
    
    NSArray *subViews = self.scrollView.subviews;
    
    for (int i = 0; i < subViews.count; i++) {
        
        UIImageView *imageView = (UIImageView *)subViews[i];
        
        [imageView sd_setImageWithURL:self.currentImages[i]];

    }
    
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0)];
}

#pragma mark - delegate图片点击事件的代理
- (void)singleTapped:(UITapGestureRecognizer *)recognizer{
    
    if ([self.delegate respondsToSelector:@selector(imageCyclePlayViewClickIndex:)]) {
        [self.delegate imageCyclePlayViewClickIndex:self.currentPage];
    }
}

#pragma mark - scrollView代理

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //取消前面的请求
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    [self toPlay];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat x = scrollView.contentOffset.x;
    
    CGFloat width = self.frame.size.width;
    
    if (self.imagesurl.count > 0) {
        
        if (x >= 2 * width) {
            
            self.currentPage = (++self.currentPage) % self.imagesurl.count;
            
            self.pageControl.currentPage = self.currentPage;
            
            self.titleLb.text = self.titles[self.pageControl.currentPage];
            
            [self refreshImages];
        }
        
        if (x <= 0) {
            
            self.currentPage = (int)(self.currentPage + self.imagesurl.count - 1)%self.imagesurl.count;
            
            self.pageControl.currentPage = self.currentPage;
            
            self.titleLb.text = self.titles[self.pageControl.currentPage];
            
            [self refreshImages];
        }
    }
}

/**
 停止循环并释放
 */
- (void)stopCycle{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
}

- (void)dealloc{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(autoPlayToNextPage) object:nil];
    NSLog(@"循环滚动视图已释放");
}

#pragma mark - get and set
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        
        for (int i = 0; i < 3; i++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
            
            if (_imagesurl.count >0) {
                
                [imageView sd_setImageWithURL:self.currentImages[i]];
                [scrollView addSubview:imageView];
                
            }
        }
        scrollView.contentSize = CGSizeMake(3 * width, height);
        scrollView.contentOffset = CGPointMake(width, 0);
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        [self addSubview:scrollView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapped:)];
        
        [scrollView addGestureRecognizer:tap];
        
        _scrollView = scrollView;
        
        [self addSubview:_scrollView];
    }
    return _scrollView;
}


- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,self.frame.size.height -  PageHeight, self.frame.size.width, PageHeight)];
        //个数
        pageControl.numberOfPages = self.imagesurl.count;
        pageControl.currentPage = 0;//显示的默认位置
        pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        pageControl.userInteractionEnabled = NO;
        pageControl.clipsToBounds = NO;
        _pageControl = pageControl;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (UILabel *)titleLb{
    if (!_titleLb) {
        _titleLb = [[UILabel alloc] initWithFrame:(CGRectMake(15, self.frame.size.height - PageHeight - TitleHeight, self.frame.size.width - 30,TitleHeight))];
        _titleLb.textAlignment = NSTextAlignmentCenter;
        _titleLb.textColor = [UIColor whiteColor];
        _titleLb.font = [UIFont systemFontOfSize:14];
        [self addSubview:_titleLb];
    }
    return _titleLb;
}

- (NSMutableArray *)currentImages{
    
    if (_currentImages == nil) {
        _currentImages = [[NSMutableArray alloc] init];
    }
    
    [_currentImages removeAllObjects];
    
    NSInteger count = self.imagesurl.count;
    
    int i = (int)(_currentPage + count - 1)%count;
    
    [_currentImages addObject:self.imagesurl[i]];
    
    [_currentImages addObject:self.imagesurl[self.currentPage]];
    
    i = (int)(self.currentPage + 1)%count;
    
    [_currentImages addObject:self.imagesurl[i]];
    
    return _currentImages;
}


- (NSMutableArray *)currentTitles{
    
    if (_currentTitles == nil) {
        _currentTitles = [[NSMutableArray alloc] init];
    }
    
    [_currentTitles removeAllObjects];
    
    NSInteger count = _titles.count;
    
    int i = (int)(self.currentPage + count - 1)%count;
    
    [_currentTitles addObject:_titles[i]];
    [_currentTitles addObject:_titles[self.currentPage]];
    
    i = (int)(_currentPage + 1)%count;
    [_currentTitles addObject:_titles[i]];
    
    return _currentTitles;
}




@end
