//
//  ViewController.h
//  WebImage
//
//  Created by Civet on 2019/5/28.
//  Copyright © 2019年 PandaTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *arrayData;
@property(nonatomic,strong) UIBarButtonItem * loadDataBtn;
@property(nonatomic,strong) UIBarButtonItem *editBtn;


@end

