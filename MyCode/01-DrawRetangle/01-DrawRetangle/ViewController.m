//
//  ViewController.m
//  01-DrawRetangle
//
//  Created by mac on 15/5/8.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 positionCoords;
}ScenseVertex;

static const ScenseVertex vertices[] = {
    {{-0.5, 0.5, 0.0}},
    {{-0.5, -0.5, 0.0}},
    {{0.5, -0.5, 0.0}}
};

@interface ViewController ()
{
    GLuint _vertexBufID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) EAGLContext *context;

@end

@implementation ViewController

- (GLKBaseEffect *)baseEffect{
    if ( _baseEffect == nil ) {
        _baseEffect = [[GLKBaseEffect alloc] init];
        _baseEffect.useConstantColor = GL_TRUE;
        // use black for background color
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return _baseEffect;
}

- (EAGLContext *)context{
    if ( _context == nil ) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
        NSAssert( _context != nil , @"api 2 is not available");
        [EAGLContext setCurrentContext:_context];
    }
    return _context;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set the context to view
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    
    // set the background in current context
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // generate the buffer
    glGenBuffers(1, &_vertexBufID);
    
    // bind buffer param 1: what kind of buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufID);
    
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    // clear the frame buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    // enable
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(ScenseVertex), NULL);
    
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
}

- (void)viewDidUnload{
    [super viewDidUnload];
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    
    if ( 0 != _vertexBufID ) {
        glDeleteBuffers(1, &_vertexBufID);
        _vertexBufID = 0;
    }
    
    view.context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
