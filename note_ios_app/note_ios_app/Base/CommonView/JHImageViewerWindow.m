//
//  JHImageViewerWindow.m
//  note_ios_app
//
//  Created by 江弘 on 2017/2/20.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHImageViewerWindow.h"
@interface JHImageViewerWindow ()<UIScrollViewDelegate>

@property (nonatomic,assign)CGSize imageSize;
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITapGestureRecognizer *tap;
@end
/**
 图片查看器公用window层，主体为scrollView上面加上imageView支持缩放，需要限定图片大小
 */
@implementation JHImageViewerWindow
{
    CGSize _defaultSize;
}

/**
 init
 */
- (instancetype)initWithFrame:(CGRect)frame WithImage:(UIImage *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _setAttributeWithImage:image];
        [self _setOneTapGesture];
    }
    return self;
}

/**
 设置属性内容
 */
-(void)_setAttributeWithImage:(UIImage *)image{
    self.backgroundColor = [UIColor blackColor];
    
    self.hidden = NO;
    self.alpha = 0;
    
    _imageSize = CGSizeMake(image.size.width, image.size.height);
    CGFloat scale = [self _changeSize:CGSizeMake(_imageSize.width, _imageSize.height)];
    _defaultSize = CGSizeMake(_imageSize.width/scale, _imageSize.height/scale);
    self.imageView.image = image;
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}
/**
 设置单点事件
 */
-(void)_setOneTapGesture{
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_tapAction)];
    [self addGestureRecognizer:_tap];
}

-(UIScrollView *)scrollView{
    if (_scrollView==nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = self.imageView.bounds.size;
        _scrollView.delegate = self;
        CGFloat scale = [self _changeSize:CGSizeMake(_imageSize.width, _imageSize.height)];
        
        _scrollView.maximumZoomScale = scale>3?scale:3;
        _scrollView.minimumZoomScale = 1.0;
    }
    return _scrollView;
}

-(UIImageView *)imageView{
    if (_imageView==nil) {
        //处理imageView初始大小
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,_defaultSize.width, _defaultSize.height)];
        _imageView.userInteractionEnabled = YES;
        _imageView.center = self.center;
        
    }
    return _imageView;
}
#warning 暂时不用缩放，有bug
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
//    return self.imageView;
//}
//
///**
// scrollView的缩放代理，此处动态改变
//
// @param scrollView _scrollView.contentSize跟随缩放比例，防止出现多余的位移
// */
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
////    _scrollView.contentSize = ;
//    
//}
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
 点击事件，关闭视图
 */
-(void)_tapAction{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


/**
 创建图片选择与取消的按钮
 */
-(void)_setCancelAndCertainButton{
    //取消按钮
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 50, 40)];
    [cancelButton setTitle:@"取消" forState:0];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:0];
    [cancelButton addTarget:self action:@selector(_tapAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    //确定按钮
    UIButton *certainButton = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, 20, 50, 40)];
    [certainButton setTitle:@"确定" forState:0];
    [certainButton setTitleColor:[UIColor whiteColor] forState:0];
    [certainButton addTarget:self action:@selector(_certainAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:certainButton];
    //取消tap
    [self removeGestureRecognizer:_tap];
    
}

/**
 确定按钮，将block数据返回，用于执行事件
 */
-(void)_certainAction{
    [self removeFromSuperview];
    _block([UIImage new]);
}
@end
