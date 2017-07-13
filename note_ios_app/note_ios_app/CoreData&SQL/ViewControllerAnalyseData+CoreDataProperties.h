//
//  ViewControllerAnalyseData+CoreDataProperties.h
//  note_ios_app
//
//  Created by hyjt on 2017/7/6.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "ViewControllerAnalyseData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ViewControllerAnalyseData (CoreDataProperties)

+ (NSFetchRequest<ViewControllerAnalyseData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *viewControllerCodeName;
@property (nullable, nonatomic, copy) NSString *viewControllerName;
@property (nonatomic) float viewControllerTime;
@property (nullable, nonatomic, copy) NSString *viewControllerDate;

@end

NS_ASSUME_NONNULL_END
