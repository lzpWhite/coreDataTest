//
//  ViewController.m
//  CoreDataTest
//
//  Created by 刘志鹏 on 16/5/23.
//  Copyright © 2016年 刘志鹏. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "CoreDataManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSMutableArray *dataSoucre;
@property (nonatomic, assign) NSInteger selectTag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSoucre = [[NSMutableArray alloc] init];
    
    NSArray *title = @[@"刷新",@"插入",@"更新",@"删除",@"排序"];
    CGFloat widt = self.view.frame.size.width/title.count;
    for (int i = 0; i<title.count; i++) {
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(widt*i, 20, widt, 40);
        btn1.backgroundColor = [UIColor grayColor];
        [btn1 setTitle:title[i] forState:UIControlStateNormal];
        btn1.tag = i+1;
        [btn1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn1];
    }
    
    
    _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60) style:UITableViewStylePlain];
    _tabelView.delegate = self;
    _tabelView.dataSource = self;
    [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    _tabelView.tableFooterView = [UIView new];
    [self.view addSubview:_tabelView];
    
    
    
    [self refreshTabelView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSoucre.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    Person *person = _dataSoucre[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.text = [NSString stringWithFormat:@"name:%@,age:%@,chinese:%@,sorce:%@",person.name,person.age,person.chinese, person.sorce];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Person *person = _dataSoucre[indexPath.row];
    if (_selectTag == 3) {
       BOOL result = [[CoreDataManager shareInstance] updateModelWithName:person.name];
        if (result) {
            [self refreshTabelView];
        }
        
    } else if (_selectTag == 4) {
        BOOL result = [[CoreDataManager shareInstance] deleteModelWithName:person.name];
        if (result) {
            [self refreshTabelView];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClick:(UIButton *)button
{
    _selectTag = button.tag;
    
    if (_selectTag == 1) {
        [self refreshTabelView];
    } else if(_selectTag == 2) {
        BOOL result = [[CoreDataManager shareInstance] insertModel];
        if (result) {
            [self refreshTabelView];
        }
    } else if (_selectTag == 5) {
        [_dataSoucre removeAllObjects];
        [_dataSoucre addObjectsFromArray:[CoreDataManager shareInstance].sortAll];
        [_tabelView reloadData];
    }
    
}

- (void)refreshTabelView {
    [_dataSoucre removeAllObjects];
    [_dataSoucre addObjectsFromArray:[CoreDataManager shareInstance].qureAll];
    [_tabelView reloadData];

}

@end
