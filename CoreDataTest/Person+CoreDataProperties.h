//
//  Person+CoreDataProperties.h
//  CoreDataTest
//
//  Created by 刘志鹏 on 16/5/23.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *chinese;
@property (nullable, nonatomic, retain) NSNumber *sorce;

@end

NS_ASSUME_NONNULL_END
