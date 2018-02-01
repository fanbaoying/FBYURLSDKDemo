//
//  ViewController.m
//  FBYURLSDKDemo
//
//  Created by fby on 2018/2/1.
//  Copyright © 2018年 FBYURLSDKDemo. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

#import "FBYSDKDemo.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define navColor [UIColor colorWithRed:243/255.0 green:237/255.0 blue:205/255.0 alpha:1]

@interface ViewController ()<WKNavigationDelegate,WKUIDelegate>
@property (weak, nonatomic) WKWebView *webView;
@property (weak, nonatomic) CALayer *progresslayer;

@property(strong,nonatomic)UIButton * blogsBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *dataArr = @[@"iOS博客",@"Android博客"];
    
    for (int i = 0; i < dataArr.count; i ++) {
        
        int count = SCREEN_WIDTH/2*i;
        
        self.blogsBtn = [[UIButton alloc]initWithFrame:CGRectMake(5+count, 20, SCREEN_WIDTH/2-5, 45)];
        [self.blogsBtn setTitle:dataArr[i] forState:0];
        [self.blogsBtn setTitleColor:[UIColor blackColor] forState:0];
        self.blogsBtn.backgroundColor = navColor;
        self.blogsBtn.tag = 6000+i;
        [self.blogsBtn addTarget:self action:@selector(blogsBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_blogsBtn];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [FBYSDKDemo urlType:@"iOS" withCompletion:^(NSString *result) {
        
        [self contentURL:result];
        
    }];
    
}

- (void)blogsBtn:(UIButton *)sender {
    
    if (sender.tag == 6000) {
        
        [FBYSDKDemo urlType:@"iOS" withCompletion:^(NSString *result) {
            
            [self contentURL:result];
            
        }];
    }else if (sender.tag == 6001) {
        
        [FBYSDKDemo urlType:@"Android" withCompletion:^(NSString *result) {
            
            [self contentURL:result];
        }];
    }
}

- (void)contentURL:(NSString *)contentURL {
    
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-45)];
    [self.view addSubview:webView];
    self.webView = webView;
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    //添加属性监听
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //进度条
    UIView *progress = [[UIView alloc]initWithFrame:CGRectMake(0, 65, CGRectGetWidth(self.view.frame), 3)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, 0, 3);
    layer.backgroundColor = [UIColor blueColor].CGColor;
    [progress.layer addSublayer:layer];
    self.progresslayer = layer;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:contentURL]]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"%@", change);
        self.progresslayer.opacity = 1;
        self.progresslayer.frame = CGRectMake(0, 0, self.view.bounds.size.width * [change[NSKeyValueChangeNewKey] floatValue], 3);
        if ([change[NSKeyValueChangeNewKey] floatValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.opacity = 0;
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progresslayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

@end
