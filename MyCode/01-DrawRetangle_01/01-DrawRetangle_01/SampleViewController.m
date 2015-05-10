//
//  SampleViewController.m
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "SampleViewController.h"
#import <GLKit/GLKit.h>

@interface SampleViewController ()

@end

@implementation SampleViewController

typedef struct {
    GLKVector3      postionCoords;
} ScenceVertex;

static const ScenceVertex vertices[] = {
    {{-0.5, -0.5, 0}},
    {{-0.5, 0.5, 0}},
    {{0.5, 0.5, 0}}
};

- (GLKBaseEffect *)baseEffect{
    if ( _baseEffect == nil ) {
        _baseEffect = [[GLKBaseEffect alloc] init];
        _baseEffect.useConstantColor = GL_TRUE;
        // white
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return _baseEffect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AGLKView *view = (AGLKView *)self.view;
    NSAssert([view isKindOfClass:[AGLKView class]], @"view must be a kind of AGLView class");
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    NSAssert(context, @"api2 is not available");
    [EAGLContext setCurrentContext:context];
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &_vertexBufferID);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
   
}

- (void)viewDidUnload{
    [super viewDidLoad];
    
    if ( 0 != _vertexBufferID ) {
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }
    
    [(AGLKView *)self.view setContext:nil];
    [EAGLContext setCurrentContext:nil];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(ScenceVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

@end
