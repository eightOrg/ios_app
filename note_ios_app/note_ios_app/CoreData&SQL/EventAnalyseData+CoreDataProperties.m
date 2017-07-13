//
//  EventAnalyseData+CoreDataProperties.m
//  note_ios_app
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "EventAnalyseData+CoreDataProperties.h"

@implementation EventAnalyseData (CoreDataProperties)

+ (NSFetchRequest<EventAnalyseData *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"EventAnalyseData"];
}

@dynamic eventCodeName;
@dynamic eventCount;
@dynamic eventDate;
@dynamic eventName;
@dynamic eventUser;
@dynamic eventClass;
@dynamic eventTag;

@end
