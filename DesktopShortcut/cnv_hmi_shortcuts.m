//
//  cnv_hmi_shortcuts.m
//  libNaviOne
//
//  Created by 郝海涛 on 15/6/5.
//  Copyright (c) 2015年 careland. All rights reserved.
//  添加（地铁图、一键导航功能）桌面快捷方式

#import "cnv_hmi_shortcuts.h"
#import "HTTPServer.h"

#define getNSLibraryDirectoryPath [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES) objectAtIndex:0]

enum{
    
    SyDesktopLinkType_Subway = 0, //地铁图
    SyDesktopLinkType_Navione,    //导航
    SyDesktopLinkType_Three,
    
}SyDesktopLinkType;

@implementation HmiDesktopShortcuts{
    
    HTTPServer *httpServer;
    NSMutableString *htmlStr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initHttpServer];
    }
    return self;
}


#pragma mark -
#pragma mark 初始化 httpserver
- (void)initHttpServer{
    NSString *documentsPath = getNSLibraryDirectoryPath;
    
    NSLog(@"root============%@",documentsPath);
    
    NSString *webRootDir = [documentsPath stringByAppendingPathComponent:@"web"];
    NSLog(@"webRootDir====%@",webRootDir);
    
    BOOL isDirectory = YES;
    BOOL exsit = [[NSFileManager defaultManager] fileExistsAtPath:webRootDir isDirectory:&isDirectory];
    NSLog(@"isDirectory==%d-----exit===%d",isDirectory,exsit);
    
    if(!exsit){
        [[NSFileManager defaultManager] createDirectoryAtPath:webRootDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    httpServer = [[HTTPServer alloc] init];
    [httpServer setType:@"_http._tcp."];
    [httpServer setDocumentRoot:[NSURL fileURLWithPath:webRootDir]];
    
    NSError *error;
    if(![httpServer start:&error]){
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}


- (void)createLinkWithDict:(NSDictionary *)dict desktopLinkType:(int)linkType
{
    NSString *title = nil;
    if(linkType == SyDesktopLinkType_Subway){
        title = @"凯立德地铁图";
    }else if (linkType == SyDesktopLinkType_Navione){
        title = dict[@"addsName"];
    }else if(linkType == SyDesktopLinkType_Three){
        
    }
    NSString *urlScheme = @"haoht://";
    
    NSString *imageName = @"icon@2x.png";
    
    
    
    htmlStr = [[NSMutableString alloc] init];
    [htmlStr appendString:@"<html><head>"];
    [htmlStr appendString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    
    NSMutableString *taragerUrl = [NSMutableString stringWithFormat:@"0;url=data:text/html;charset=UTF-8,<html><head><meta content=\"yes\" name=\"apple-mobile-web-app-capable\" /><meta content=\"text/html; charset=UTF-8\" http-equiv=\"Content-Type\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\" /><title>%@</title></head><body bgcolor=\"#ffffff\">",title];
    
    NSString *htmlUrlScheme = [NSString stringWithFormat:@"<a href=\"%@",urlScheme];
    
    NSString *dataUrlStr = nil;
    if(linkType == SyDesktopLinkType_Subway){
        
        dataUrlStr =  [NSString stringWithFormat:@"%@?moduleID=%d\" id=\"qbt\" style=\"display: none;\"></a>",urlScheme,linkType];
        
    }else if (linkType == SyDesktopLinkType_Navione){
        
        //dataUrlStr =  [NSString stringWithFormat:@"%@=%@&%@=%@\" id=\"qbt\" style=\"display: none;\"></a>",deskLinkModuleTag,moduleID,deskLinkType,[NSString stringWithInt:linkType]];
        
        dataUrlStr =  [NSString stringWithFormat:@"%@?moduleID=%d&x=%@&y=%@&addsName=%@&destination=%@&eRpCondition=%@\" id=\"qbt\" style=\"display: none;\"></a>",urlScheme,linkType,dict[@"x"],dict[@"y"],dict[@"addsName"],dict[@"destination"],dict[@"eRpCondition"]];
        
    }else if(linkType == SyDesktopLinkType_Three){
        
    }
    
    UIImage *image = [UIImage imageNamed:imageName];
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *base6ImageStr = [imageData base64Encoding];
    
    // 转码
    //  dataUrlStr = [dataUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    NSString *imageUrlStr = [NSString stringWithFormat:@"<span id=\"msg\"></span></body><script>if (window.navigator.standalone == true) {    var lnk = document.getElementById(\"qbt\");    var evt = document.createEvent('MouseEvent');    evt.initMouseEvent('click');    lnk.dispatchEvent(evt);}else{    var addObj=document.createElement(\"link\");    addObj.setAttribute('rel','apple-touch-icon-precomposed');    addObj.setAttribute('href','data:image/png;base64,%@');",base6ImageStr];
    
    NSString *lastHtmlStr = @"document.getElementsByTagName(\"head\")[0].appendChild(addObj);    document.getElementById(\"msg\").innerHTML='<div style=\"font-size:12px;\">点击页面下方的 + 或 <img id=\"i\" src=\"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAMAAAC6V+0/AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAAyJpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZVJlZiMiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENTNiAoV2luZG93cykiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6OTU1NEJDMzMwQTBFMTFFM0FDQTA4REMyNUE4RkExNkEiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6OTU1NEJDMzQwQTBFMTFFM0FDQTA4REMyNUE4RkExNkEiPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDo5NTU0QkMzMTBBMEUxMUUzQUNBMDhEQzI1QThGQTE2QSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo5NTU0QkMzMjBBMEUxMUUzQUNBMDhEQzI1QThGQTE2QSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4gPC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PlMy2ugAAAAbUExUReXy/yaS/4nE/67W//n8/+n0/0yl/wB//////1m3cVcAAAAJdFJOU///////////AFNPeBIAAABDSURBVHjaxNA7DgAgCAPQoiLc/8T+EgV1p0ubxwb0E+xR8SBICBcyJUnEHktW0VwOykivvSaus6kA1CD0sZ+3aQIMAJIgC+S9X9jmAAAAAElFTkSuQmCC\"> 按钮，在弹出的菜单中选择［添加至主屏幕］，即可将选定的功能添加到主屏幕作为快捷方式。</div>';}</script></html>";
    
    [taragerUrl appendString:htmlUrlScheme];
    [taragerUrl appendString:dataUrlStr];
    
    
    NSString *dataUrlEncode = [taragerUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *imageUrlEncode = [imageUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *lastHtmlStrEncode = [lastHtmlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    /*****
     方法一：对于HTML语言
     
     以下是代码片段： <html> <head> <meta http-equiv="Refresh" content="2;url=http://www.你的域名.com"> </head> <body> Loading... </body> </html>
     
     对于HTML语言可以用如上方法，
     
     以上含义为：则会在2秒之后重定向到 http://www.你的域名.com；如果 http://www.你的域名.com为本身，则每2秒自动刷新1次；如果 content=0，则立即重定向。
     
     *****/
    
    [htmlStr appendFormat:@"<meta http-equiv=\"REFRESH\" content=\"%@%@%@\">",dataUrlEncode,imageUrlEncode,lastHtmlStrEncode];
    [htmlStr appendString:@"</head></html>"];
    
    
    NSLog(@"htmlStr===%@",htmlStr);
    
    NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/web",getNSLibraryDirectoryPath]]){
        
        return ;
        
    }
    
    NSString *filePath = [NSString stringWithFormat:@"%@/web/read.html",getNSLibraryDirectoryPath];
    NSLog(@"filePath=======%@",filePath);
    
    
    if(![[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        
    }
    
    BOOL isComplete = [data writeToFile:filePath atomically:NO];
    
    BOOL isExistFilePath = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    NSLog(@"isComplete===%d------isExistFilePath====%d",isComplete,isExistFilePath);
    
    
    
    NSString *urlStrWithPort = [NSString stringWithFormat:@"http://127.0.0.1:%d/read.html",[httpServer listeningPort]];
    
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath] && isComplete){
        BOOL isFinish = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStrWithPort]];
        if(isFinish){
            NSLog(@"isFinish======%d",isFinish);
        }
    }
}

- (void)start{
    
    NSLog(@"HmiDesktopShortcuts启动");
}

- (void)dealloc{
//    [httpServer stop];
}

@end
