//
//  cnv_hmi_shortcuts.h
//  libNaviOne
//
//  Created by 郝海涛 on 15/6/5.
//  Copyright (c) 2015年 careland. All rights reserved.
//  添加（地铁图、一键导航功能）桌面快捷方式

#import <UIKit/UIKit.h>

@interface HmiDesktopShortcuts : NSObject

- (void)start;
- (void)createLinkWithDict:(NSDictionary *)dict desktopLinkType:(int)linkType;

@end
