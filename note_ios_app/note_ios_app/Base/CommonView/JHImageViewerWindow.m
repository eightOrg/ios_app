//
//  JHImageViewerWindow.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/20.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHImageViewerWindow.h"
#define JHSCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define JHSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define JH_UIViewAnimation 0.3
@interface JHImageViewerWindow ()<UIScrollViewDelegate>
//存储图片原始大小
@property (nonatomic,assign)CGSize imageSize;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@property (nonatomic,strong)UIView *navView;
@end
/**
 图片查看器公用window层，主体为scrollView上面加上imageView支持缩放，需要限定图片大小
 */
@implementation JHImageViewerWindow


/**
 init
 */
- (instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setAttributeWithImage:image];
//        [self _setOneTapGesture];
//        [self _setDoubleTapGesture];
    }
    return self;
}
/**
 init
 */
- (instancetype)initWithFrame:(CGRect)frame WithImageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setAttributeWithImageUrl:imageUrl];
//        [self _setOneTapGesture];
        [self _setDoubleTapGesture];
    }
    return self;
}
/**
 设置属性内容
 */
-(void)_setAttributeWithImageUrl:(NSString *)imageUrl{
    self.backgroundColor = [UIColor blackColor];
    
    self.hidden = NO;
    self.alpha = 0;
    WeakSelf
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.imageView sd_setShowActivityIndicatorView:YES];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"p1.jpg"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
        weakSelf.imageSize = CGSizeMake(image.size.width, image.size.height);
        weakSelf.imageView.frame = CGRectMake(0, 0, _imageSize.width,_imageSize.height);
        [weakSelf remakeScale];
    }];
    
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}
/**
 设置属性内容
 */
-(void)_setAttributeWithImage:(UIImage *)image{
    self.backgroundColor = [UIColor blackColor];
    
    self.hidden = NO;
    self.alpha = 0;
    
    _imageSize = CGSizeMake(image.size.width, image.size.height);
    
    self.imageView.image = image;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}
/**
 设置单点消失事件
 */
-(void)_setOneTapDismissGesture{

    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_cancelAction)];
    [self addGestureRecognizer:_tap];
}
/**
 设置单点事件
 */
-(void)_setOneTapGesture{

    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction)];
    [self addGestureRecognizer:_tap];
}
/**
 设置双击事件
 */
-(void)_setDoubleTapGesture{
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_doubleTapAction)];
    doubleTap.numberOfTapsRequired = 2;
    //设置点击优先值
    [_tap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:doubleTap];
}

/**
 双击
 */
-(void)_doubleTapAction{
    CGFloat currentZoom  = _scrollView.zoomScale;
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        if (currentZoom==_scrollView.maximumZoomScale) {
            [_scrollView setZoomScale:_scrollView.minimumZoomScale];
        }else{
            [_scrollView setZoomScale:_scrollView.maximumZoomScale];
        }
    }];
    
}
-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(JHSCREENWIDTH, JHSCREENHEIGHT);
        [self remakeScale];
        
    }
    return _scrollView;
}
-(void)remakeScale{
    CGFloat scale = [self _changeSize:CGSizeMake(_imageSize.width, _imageSize.height)]==0?1:[self _changeSize:CGSizeMake(_imageSize.width, _imageSize.height)];
    //设置最高和最低的缩放倍数，也就是让一个边达到和屏幕相同到另外一个比例较大的边达到和屏幕项目的区间
    if (_imageSize.width/_imageSize.height>JHSCREENWIDTH/JHSCREENHEIGHT) {
        //按照图片的宽缩放
        _scrollView.maximumZoomScale = JHSCREENHEIGHT/(_imageSize.height/scale)/scale;
    }else{
        //按照图片的高缩放
        _scrollView.maximumZoomScale = JHSCREENWIDTH/(_imageSize.width/scale)/scale;
    }
    
    _scrollView.minimumZoomScale = 1/scale;
    [_scrollView setZoomScale:1/scale];
}
-(UIImageView *)imageView{
    if (_imageView==nil) {
        //处理imageView初始大小
        if (_imageSize.width>0&&_imageSize.height>0) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _imageSize.width,_imageSize.height)];
        }else{
            
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, JHSCREENWIDTH,JHSCREENHEIGHT)];
        }
        _imageView.userInteractionEnabled = YES;
        _imageView.center = CGPointMake(JHSCREENWIDTH/2, JHSCREENHEIGHT/2);
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }
    return _imageView;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

/**
 scrollView的缩放代理，此处动态改变

 @param scrollView _scrollView.contentSize跟随缩放比例，防止出现多余的位移
 */
-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    UIImageView *imgView  = self.imageView;
    scrollView.contentSize = CGSizeMake(imgView.frame.size.width, imgView.frame.size.height);
    //默认为image大小，当存在小于等于某个边的，设置为这个边为contentSize
    if (imgView.frame.size.width<=JHSCREENWIDTH) {
        scrollView.contentSize = CGSizeMake(JHSCREENWIDTH, scrollView.contentSize.height);

    }
    if (imgView.frame.size.height<=JHSCREENHEIGHT) {
        scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, JHSCREENHEIGHT);

    }
    
//    改变图片的中心点
    _imageView.center = CGPointMake(scrollView.contentSize.width/2, scrollView.contentSize.height/2);
}

/**
 改变图像大小

 @param size 原始大小
 @return 根据屏幕缩放后的大小
 */
-(CGFloat )_changeSize:(CGSize )size{
    CGFloat width  = size.width;
    CGFloat height = size.height;
    //对比屏幕的宽和高
//    JHSCREENWIDTH/width
    CGFloat scale = 0.0;
    
    scale = width/JHSCREENWIDTH>height/JHSCREENHEIGHT?width/JHSCREENWIDTH:height/JHSCREENHEIGHT;

    return  scale;
//    return  CGSizeMake(width/scale, height/scale);
}



/**
 创建图片选择与取消的按钮
 */
-(void)_setCancelAndCertainButton{
    _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, JH_NavigationHeight)];
    _navView.backgroundColor = [UIColor colorWithRed:57/255.0 green:58/255.0 blue:62/255.0 alpha:1];
    [self addSubview:_navView];
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 40)];
    [cancelButton setTitle:@"取消" forState:0];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:0];
    [cancelButton addTarget:self action:@selector(_tapAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:cancelButton];
    //确定按钮
    UIButton *certainButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, 20, 50, 40)];
    [certainButton setTitle:@"确定" forState:0];
    [certainButton setTitleColor:[UIColor whiteColor] forState:0];
    [certainButton addTarget:self action:@selector(_certainAction) forControlEvents:UIControlEventTouchUpInside];
    [_navView addSubview:certainButton];
    
    [self _setOneTapGesture];
    [self _setDoubleTapGesture];
}

-(void)_cancelAction{
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
/**
 点击事件，关闭视图
 */
-(void)_tapAction{
    [UIView animateWithDuration:JH_UIViewAnimation animations:^{
        _navView.top = _navView.top==0?-64:0;
    } completion:^(BOOL finished) {
        
    }];
    
}
/**
 确定按钮，将block数据返回，用于执行事件
 */
-(void)_certainAction{
    _block(self.imageView.image);
    [self removeFromSuperview];
}
@end
