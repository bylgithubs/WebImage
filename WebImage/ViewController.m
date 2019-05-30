//
//  ViewController.m
//  WebImage
//
//  Created by Civet on 2019/5/28.
//  Copyright © 2019年 PandaTest. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BookModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"加载网络视图";
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_tableView];
    
    _arrayData = [[NSMutableArray alloc] init];
    _loadDataBtn = [[UIBarButtonItem alloc] initWithTitle:@"加载" style:UIBarButtonItemStylePlain target:self action:@selector(pressLoad)];
    self.navigationItem.rightBarButtonItem = _loadDataBtn;
}
//加载新的数据刷新显示的视图
- (void)pressLoad{
//    static int i = 0;
//    for (int j = 0; j < 10; j++, i++) {
//        NSString *str = [NSString stringWithFormat:@"数据%d",i + 1];
//        [_arrayData addObject:str];
//    }
    
    [self loadDataFromNet];

}
//下载数据
- (void)loadDataFromNet{
    //下载网络数据
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSArray *arrayG = [NSArray arrayWithObjects:@"iOS",@"Android",@"C++", nil];
    static int count = 0;
    NSString *path = [NSString stringWithFormat:@"http://api.douban.com/book/subjects?q=%@&alt=json&apikey=01987f93c544bbfb04c97ebb4fce33f1",arrayG[count]];
    
    count++;
    if (count >= 3) {
        count = 0;
    }
    //下载网络数据
    [session GET:path parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"下载成功");
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSLog(@"dic = %@", responseObject);
            [self parseData:responseObject];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"下载失败");
    }];
}
//解析数据函数
- (void)parseData:(NSDictionary *)dicData{
    
    NSArray *arrEntry = [dicData objectForKey:@"entry"];
    for (NSDictionary *dicBook in arrEntry) {
        NSDictionary *dicTitle = [dicBook objectForKey:@"title"];
        NSString *strTitle = [dicTitle objectForKey:@"$t"];
        BookModel *bModel = [[BookModel alloc] init];
        //获取书籍的名字
        bModel.mBooKName = strTitle;
        NSArray *arrLink = [dicBook objectForKey:@"link"];
        for (NSDictionary *dicLink in arrLink) {
            NSString *sValue = [dicLink objectForKey:@"@rel"];
            if ([sValue isEqualToString:@"image"]) {
                
                bModel.mBImageURL = [dicLink objectForKey:@"@href"];
            }
        }
        [_arrayData addObject:bModel];
    }
    [_tableView reloadData];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *strID = @"ID";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:strID];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:strID];
    }
    BookModel *bModel = _arrayData[indexPath.row];
    cell.textLabel.text = bModel.mBooKName;
    //使用WebImage来加载网络图片，如果无图，则使用本地图片代替
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:bModel.mBImageURL] placeholderImage:[UIImage imageNamed:@"9.jpg"]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
