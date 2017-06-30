//
//  JHChatBaseCellLocation.m
//  note_ios_app
//
//  Created by hyjt on 2017/5/27.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "JHChatBaseCellLocation.h"
#import <MapKit/MapKit.h>
//#import <CoreLocation/CoreLocation.h>
@implementation JHChatBaseCellLocation

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setMessageModel:(M_MessageList *)messageModel{
    if (_messageModel!=messageModel) {
        _messageModel = messageModel;
    }
    [self creatSubViews];
}
-(void)creatSubViews{
    // 是发送还是接受
    CGFloat masTop=10;
    
    if (_messageModel.message_isShowTime) {
        
        masTop=37;
        
        UILabel *timeLabel=[[UILabel alloc] init];
        timeLabel.font=[UIFont systemFontOfSize:10];
        timeLabel.backgroundColor=COLOR_cecece;
        timeLabel.textColor=COLOR_ffffff;
        timeLabel.text= [NSString changeTimeIntervalToMinute:@(_messageModel.message_time)];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        timeLabel.layer.masksToBounds=YES;
        timeLabel.layer.cornerRadius=4;
        timeLabel.layer.borderColor=[COLOR_cecece CGColor];
        timeLabel.layer.borderWidth=1;
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(10);
            make.centerX.equalTo(self.contentView);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(17);
        }];
        
    }
    
    UIImageView *contextBack=[[UIImageView alloc] init];
    contextBack.userInteractionEnabled=YES;
    CGRect rect =  CGRectMake(0, 0, JHSCREENWIDTH/2,JHSCREENWIDTH/2*2/3);
    
    if (_messageModel.message_isSelf==MessageSenderTypeReceived) {
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(10, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic_r@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        contextBack.frame=CGRectMake(LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback1"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
//        [self.contentView addSubview:contextBack];
       
        //地图图片
        UIImageView *mapImage = [[UIImageView alloc] initWithFrame:contextBack.frame];
        [self creatMapSnapshot:_messageModel.message_text withCompletionBlock:^(UIImage *image) {
            mapImage.image = image;
        }];
        [self.contentView addSubview:mapImage];
        
    }else if (_messageModel.message_isSelf==MessageSenderTypeSend) {
        
        UIImageView *logoImage=[[UIImageView alloc] init];
        logoImage.frame=CGRectMake(JHSCREENWIDTH-10-40, masTop, 40, 40);
        logoImage.image = [UIImage imageNamed:@"button_pic@2x"];
        //        [logoImage setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:[UIImage imageNamed:DEF_ICON]];
        [self.contentView addSubview:logoImage];
        
        contextBack.frame=CGRectMake(JHSCREENWIDTH-(rect.size.width+26)-LEFT_WITH, masTop, rect.size.width+26, rect.size.height+26);
        contextBack.image=[[UIImage imageNamed:@"wechatback2"] stretchableImageWithLeftCapWidth:10 topCapHeight:25];
//        [self.contentView addSubview:contextBack];
        
        //地图图片
        UIImageView *mapImage = [[UIImageView alloc] initWithFrame:contextBack.frame];
        [self creatMapSnapshot:_messageModel.message_text withCompletionBlock:^(UIImage *image) {
            mapImage.image = image;
        }];
        [self.contentView addSubview:mapImage];
    }
}

/**
 创建地图截图
 */
-(void)creatMapSnapshot:(NSString *)locationStr withCompletionBlock:(void (^)(UIImage *image))completion{
    
    MKMapSnapshotOptions *options=[[MKMapSnapshotOptions alloc]init];
    
    //截图的地图类型
    options.mapType = MKMapTypeStandard;
    //显示建筑物
    options.showsBuildings=YES;

    NSArray *location = [locationStr componentsSeparatedByString:@"/"];
    //计算距离
    double distance =  200;
    //第一个参数指定目标区域的中心点，第二个参数是目标区域的南北跨度，单位为米。第三个参数为目标区域东西跨度，单位为米。后2个参数的调整会影响地图的缩放
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(CLLocationCoordinate2DMake([location[0] doubleValue], [location[1] doubleValue]), distance ,distance);
    
    options.region = viewRegion;
    //截图输出的大小
    options.size=CGSizeMake(JHSCREENWIDTH/2,JHSCREENWIDTH/2*2/3);
    
    options.scale=[UIScreen mainScreen].scale;
    
    MKMapSnapshotter *shotter=[[MKMapSnapshotter alloc]initWithOptions:options];
    
    [shotter startWithCompletionHandler:^(MKMapSnapshot * _Nullable snapshot, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"截图出错了");
            return;
        }
        
        UIImage *img=snapshot.image;
        
        completion(img);
        //后边的参数表示压缩比例0-1
//        NSData *data=UIImageJPEGRepresentation(img, 1.0);
//        
//        [data writeToFile:@"/Users/hq/Desktop/map.png" atomically:YES];
        
    }];
}

@end
