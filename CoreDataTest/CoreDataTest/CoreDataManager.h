//
//  CoreDataManager.h
//  CoreDataTest
//
//  Created by 刘志鹏 on 16/5/23.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define DATA_BASE_NAME @"dataBaseNameTest"
#define CORE_DATA_NAME @"UserModel"
#define ENTITY_NAME @"Person"


@interface CoreDataManager : NSObject

+ (instancetype)shareInstance;

- (BOOL)insertModel;

- (BOOL)updateModelWithName:(NSString *)name;

- (NSArray *)qureAll;

- (BOOL)deleteModelWithName:(NSString *)name;

- (NSArray *)sortAll;

@end
