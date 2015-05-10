//
//  ViewController.m
//  01-DrawRetangle_02
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    GLuint _vertexID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) EAGLContext *context;

@end

@implementation ViewController

typedef struct {
    GLKVector3 positionCoords;
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
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return _baseEffect;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    GLKView *view = (GLKView *)self.view;
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert(context != nil, @"api 2 is not avaiable");
    
    view.context = context;
    [EAGLContext setCurrentContext:context];
    self.context = context;
    
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glGenBuffers(1, &_vertexID);
    
    glBindBuffer(GL_ARRAY_BUFFER, _vertexID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    glClear(GL_COLOR_BUFFER_BIT);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(ScenceVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
}

- (void)viewDidUnload{
    [super viewDidUnload];
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if ( 0 != _vertexID ) {
        glDeleteBuffers(1, &_vertexID);
        _vertexID = 0;
    }
    
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
