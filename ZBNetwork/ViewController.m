//
//  ViewController.m
//  ZBNetwork
//
//  Created by 周博 on 2018/3/26.
//  Copyright © 2018年 周博. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self getDataRequest];
}


- (IBAction)getDataRequest {
    NSString *url = @"https:/api.derongtx.com/apk/article/HOMEPAGE/list?name=icon_list_app&page=1&size=9";
//    NSString *url = @"http://news-at.zhihu.com/api/4/news/latest";
    [ZBNetwork GET:url parameters:nil success:^(id  _Nullable response) {
        NSArray *data = response[@"data"];
        NSLog(@"%@",data);
        if (data.count == 0) {
            return;
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"error：%@",error);
    }];
}


@end
