//
//  EventAnalyseData+CoreDataProperties.h
//  note_ios_app
//
//  Created by hyjt on 2017/7/5.
//  Copyright © 2017年 江弘. All rights reserved.
//

#import "EventAnalyseData+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface EventAnalyseData (CoreDataProperties)

+ (NSFetchRequest<EventAnalyseData *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *eventCodeName;
@property (nonatomic) int64_t eventCount;
@property (nullable, nonatomic, copy) NSString *eventDate;
@property (nullable, nonatomic, copy) NSString *eventName;
@property (nullable, nonatomic, copy) NSString *eventUser;
@property (nullable, nonatomic, copy) NSString *eventClass;
@property (nullable, nonatomic, copy) NSString *eventTag;

@end

NS_ASSUME_NONNULL_END
