//
//  ViewController.m
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"

typedef struct {
    GLKVector3 positionCoords;
} SceneVertex;

@interface ViewController ()

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic,weak) AGLKContext *context;

@end

@implementation ViewController

static const SceneVertex vertices[] = {
    {{-0.5, -0.5, 0.0}},
    {{-0.5, 0.5, 0.0}},
    {{0.5, 0.5, 0.0}}
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
    
    AGLKContext *context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert(context, @"api2 is not avaiable");
    view.context = context;
    [AGLKContext setCurrentContext:context];
    
    context.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.context = context;
    
    _vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    [self.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition count:sizeof(vertices) / sizeof(SceneVertex) attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer drawWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertex:3];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    _vertexBuffer = nil;
    
    view.context = nil;
    [AGLKContext setCurrentContext:nil];
}

@end
