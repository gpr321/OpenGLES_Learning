//
//  AGLKViewController.m
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKViewController.h"


@interface AGLKViewController ()

@end

@implementation AGLKViewController

static NSInteger const kAGLKDefaultFramesPerSecond = 30;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
        [self setUp];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setUp];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    AGLKView *view = (AGLKView *)self.view;
    NSAssert([view isKindOfClass:[AGLKView class]], @"view must be a kind of AGLKView");
    view.opaque = YES;
    view.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.pause = NO;
}

- (void)setUp{
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView)];
    self.performFramesPerSecond = kAGLKDefaultFramesPerSecond;
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    self.pause = NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
        return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
    } else {
        return YES;
    }
}

- (void)drawView{
    [(AGLKView *)self.view display];
}

- (void)setPerformFramesPerSecond:(NSInteger)performFramesPerSecond{
    _performFramesPerSecond = performFramesPerSecond;
    _displayLink.frameInterval = MAX(1, 60 / performFramesPerSecond);
}

- (NSInteger)framesPerSeconds{
    return 60 / _displayLink.frameInterval;
}

- (BOOL)isPause{
    return _displayLink.paused;
}

- (void)setPause:(BOOL)pause{
     _displayLink.paused = pause;
}

#pragma mark - GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

}

@end
