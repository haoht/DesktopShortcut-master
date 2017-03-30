SettingPage Wrapper
================

##### Safari有一个“添加至屏幕”的功能，其实就是在桌面上添加了一个网页书签，App可以使用这个功能来实现创建桌面快捷方式。

##### 封装成一个类，直接创建HmiDesktopShortcuts的实例，调用createLinkWithDict方法即可

使用方法: (详情请下载demo查看)

	if (!desktopShortcuts) {
        desktopShortcuts = [[HmiDesktopShortcuts alloc] init];
        [desktopShortcuts start];
        
        NSString *addsName = @"导航目的地";
    
        NSString *dest = @"地图上的点";
       
        NSDictionary *dic = @{@"x":[NSString stringWithFormat:@"%d",410817147],@"y":[NSString stringWithFormat:@"%d",81362810],@"addsName":addsName,@"destination":
                                  dest,@"eRpCondition":[NSString stringWithFormat:@"%d",0x1]};
        
        [desktopShortcuts createLinkWithDict:dic desktopLinkType:1];
    }