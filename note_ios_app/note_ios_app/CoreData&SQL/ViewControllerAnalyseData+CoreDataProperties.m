//
//  ViewControllerAnalyseData+CoreDataProperties.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/6.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "ViewControllerAnalyseData+CoreDataProperties.h"

@implementation ViewControllerAnalyseData (CoreDataProperties)

+ (NSFetchRequest<ViewControllerAnalyseData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ViewControllerAnalyseData"];
}

@dynamic viewControllerCodeName;
@dynamic viewControllerName;
@dynamic viewControllerTime;
@dynamic viewControllerDate;

@end
