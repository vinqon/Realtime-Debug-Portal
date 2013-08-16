//
//  ViewController.m
//  Realtime Debug Protal
//
//  Created by Feather Chan on 13-3-19.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import "ViewController.h"
#import "libRDP.h"
#import "NSObject+ViewTree.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIButton *btn = [[[UIButton alloc]initWithFrame:CGRectMake(10,20, 200, 50)]autorelease];
    [btn setTitle:[@(self.navigationController.viewControllers.count) description] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    if (self.navigationController.viewControllers.count == 1) {
        [RDP startServer];
    }
    
    NSMutableArray *list = [[NSMutableArray alloc]init];
    while(list.count < 10000){
        [list addObject:@(22)];
    }

}

- (void)push
{
    [RDP logWithFormat:@"push"];
    
    [self.navigationController pushViewController:[[[ViewController alloc]init]autorelease] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
