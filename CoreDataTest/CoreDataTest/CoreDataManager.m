//
//  CoreDataManager.m
//  CoreDataTest
//
//  Created by 刘志鹏 on 16/5/23.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import "CoreDataManager.h"
#import "Person.h"


@interface CoreDataManager ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *manageObjectContext;

@property (nonatomic, strong, readonly) NSManagedObjectModel *manageObjectModel;

@property(strong,nonatomic,readonly)NSPersistentStoreCoordinator* persistentStoreCoordinator;

@end



@implementation CoreDataManager

@synthesize manageObjectContext = _manageObjectContext;
@synthesize manageObjectModel = _manageObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (instancetype)shareInstance {

    static CoreDataManager * shareCoreDataManger = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCoreDataManger = [[CoreDataManager alloc] init];
    });
    
    return shareCoreDataManger;
}

- (NSManagedObjectModel *)manageObjectModel {
    if (!_manageObjectModel) {
        
        NSString *modelPath = [[NSBundle mainBundle] pathForResource:CORE_DATA_NAME ofType:@"mom" inDirectory:[NSString stringWithFormat:@"%@.momd", CORE_DATA_NAME]];
        NSLog(@"modelPath:%@", modelPath);
        if (modelPath.length>0) {
            NSURL *modelUrl = [NSURL URLWithString:modelPath];
            _manageObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
        } else {
            NSLog(@"未获取model路径");
        }
    }
    
    return _manageObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        
        NSString* docs=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSURL* storeURL=[NSURL fileURLWithPath:[docs stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite", DATA_BASE_NAME]]];
        NSLog(@"path is %@",storeURL);
        NSError* error=nil;
        NSManagedObjectModel *modle = self.manageObjectModel;
        if (modle) {
            _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:modle];
            if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
                NSLog(@"unresolved error %@, %@", error, error.userInfo);
            }
        }
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)manageObjectContext {
    
    if (!_manageObjectContext) {
        
        if (self.persistentStoreCoordinator) {
            _manageObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_manageObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];
        }
    }
    
    return _manageObjectContext;
}

#pragma mark -- 插入数据
- (BOOL)insertModel {
    
    if (!self.manageObjectContext) {
        return NO;
    }
    
    Person *person = (Person *)[NSEntityDescription insertNewObjectForEntityForName:ENTITY_NAME inManagedObjectContext:self.manageObjectContext];
    
    NSInteger index = arc4random()%100;
    [person setName:[NSString stringWithFormat:@"liu%@",@(index)]];
    [person setAge:@(index)];
    index = arc4random()%100;
    [person setChinese:@(index)];
    index = arc4random()%100;
    [person setSorce:@(index)];
    
    NSError* error;
    BOOL isSaveSuccess=[self.manageObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
    return isSaveSuccess;
}

#pragma mark -- 更新

- (BOOL)updateModelWithName:(NSString *)name {
    if (!self.manageObjectContext) {
        return NO;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.manageObjectContext];
    [fetchRequest setEntity:personEntity];
    
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"name==%@",name];
    [fetchRequest setPredicate:predicate];
    
    // 查询
    NSError *error = nil;
    NSArray *array = [self.manageObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@,%@", error, error.userInfo);
        return nil;
    }
    
    
    for (Person *personModel in array) {
        personModel.name = @"liu";
    }
    
    
    
    BOOL isSaveSuccess=[self.manageObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
    return isSaveSuccess;
    
    return YES;
}

#pragma mark -- 查询

- (NSArray *)qureAll {
    if (!self.manageObjectContext) {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *person = [NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.manageObjectContext];
    [fetchRequest setEntity:person];
    
    NSError *error = nil;
    NSArray *array = [self.manageObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@,%@", error, error.userInfo);
        return nil;
    }
    
    return array;
    
}


#pragma mark -- 删除

- (BOOL)deleteModelWithName:(NSString *)name {
    if (!self.manageObjectContext) {
        return NO;
    }
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* user=[NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.manageObjectContext];
    [request setEntity:user];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"name==%@",name];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[self.manageObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
        NSLog(@"Error:%@",error);
    }
    NSLog(@"The count of entry: %ld",[mutableFetchResult count]);
    for (Person* person in mutableFetchResult) {
        [self.manageObjectContext deleteObject:person];
    }
    BOOL isSuccess = [self.manageObjectContext save:&error];
    if (!isSuccess) {
        NSLog(@"Error:%@,%@",error,[error userInfo]);
    }
    
    return isSuccess;
}

- (NSArray *)sortAll {
    if (!self.manageObjectContext) {
        return nil;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *person = [NSEntityDescription entityForName:ENTITY_NAME inManagedObjectContext:self.manageObjectContext];
    [fetchRequest setEntity:person];
    
//    NSSortDescriptor *sort1 = [[NSSortDescriptor alloc] initWithKey:@"age" ascending:YES];
    NSSortDescriptor *sort2 = [[NSSortDescriptor alloc] initWithKey:@"sorce" ascending:NO];
//    NSSortDescriptor *sort3 = [[NSSortDescriptor alloc] initWithKey:@"chinese" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort2]];
    
    NSError *error = nil;
    NSArray *array = [self.manageObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"%@,%@", error, error.userInfo);
        return nil;
    }
    
    return array;
}


@end
