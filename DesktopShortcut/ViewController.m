//
//  ViewController.m
//  DesktopShortcut
//
//  Created by mac on 2017/3/29.
//  Copyright © 2017年 haoht. All rights reserved.
//

#import "ViewController.h"
#import "cnv_hmi_shortcuts.h"

@interface ViewController () {

    HmiDesktopShortcuts *desktopShortcuts;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(60, 100, 200, 100);
    [button setTitle:@"点击创建桌面快捷方式" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor grayColor];
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}

- (void)click:(UIButton *)sender {
    if (!desktopShortcuts) {
        desktopShortcuts = [[HmiDesktopShortcuts alloc] init];
        [desktopShortcuts start];
        
        NSString *addsName = @"导航目的地";
    
        NSString *dest = @"地图上的点";
       
        NSDictionary *dic = @{@"x":[NSString stringWithFormat:@"%d",410817147],@"y":[NSString stringWithFormat:@"%d",81362810],@"addsName":addsName,@"destination":
                                  dest,@"eRpCondition":[NSString stringWithFormat:@"%d",0x1]};
        
        [desktopShortcuts createLinkWithDict:dic desktopLinkType:1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
