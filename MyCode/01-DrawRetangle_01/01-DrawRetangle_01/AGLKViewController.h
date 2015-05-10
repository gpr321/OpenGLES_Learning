//
//  AGLKViewController.h
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGLKView.h"

@interface AGLKViewController : UIViewController <GLKViewDelegate>
{
    CADisplayLink       *_displayLink;
}

// default is 30
@property (nonatomic,assign) NSInteger performFramesPerSecond;

@property (nonatomic,assign,readonly) NSInteger framesPerSeconds;

@property (nonatomic,assign,getter=isPause) BOOL pause;

@end
