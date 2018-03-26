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
}


- (IBAction)getDataRequest {
    NSString *url = @"https://news-at.zhihu.com";
    [ZBNetwork GET:url parameters:nil success:^(id  _Nullable response) {
        NSArray *data = response[@"data"];
        if (data.count == 0) {
            return;
        }
    } failure:^(NSError * _Nullable error) {
        NSLog(@"error：%@",error);
    }];
}


@end
