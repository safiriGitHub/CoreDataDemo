//
//  Teacher+CoreDataProperties.h
//  CoreDataDemo
//
//  Created by safiri on 2017/1/18.
//  Copyright © 2017年 com.egintra. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "Teacher+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Teacher (CoreDataProperties)

+ (NSFetchRequest<Teacher *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int16_t idNum;

@end

NS_ASSUME_NONNULL_END
