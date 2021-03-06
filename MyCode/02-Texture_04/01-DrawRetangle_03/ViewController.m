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
#import "AGLKTextureLoader.h"

typedef struct {
    GLKVector3 positionCoords;
    GLKVector2 textTureCoords;
} SceneVertex;

@interface ViewController ()

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic,weak) AGLKContext *context;

@property (nonatomic,assign) GLuint vertexBufferID;

@property (nonatomic,strong) GLKTextureInfo *textureInfo1;
@property (nonatomic,strong) GLKTextureInfo *textureInfo2;

@end

@implementation ViewController

//static const SceneVertex vertices[] = {
//    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
//    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
//    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
//    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},   // second trangle
//    {{ 1.0f, -0.67f, 0.0f}, {0.0f, 1.0f}},
//    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}}
//};

static const SceneVertex vertices[] =
{
    {{-1.0f, -0.67f, 0.0f}, {0.0f, 0.0f}},  // first triangle
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f, -0.67f, 0.0f}, {1.0f, 0.0f}},  // second triangle
    {{-1.0f,  0.67f, 0.0f}, {0.0f, 1.0f}},
    {{ 1.0f,  0.67f, 0.0f}, {1.0f, 1.0f}},
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
    
    _vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices usage:GL_STATIC_DRAW];
    
    UIImage *image = [UIImage imageNamed:@"leaves.gif"];
    
    // GLKTextureLoaderOriginBottomLeft = yes : 垂直翻转图像数据,抵消图像原点和opengl原点之间的差异
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:@{GLKTextureLoaderOriginBottomLeft : @YES} error:NULL];
    
    self.textureInfo1 = textureInfo;
    
    image = [UIImage imageNamed:@"beetle.png"];
    
    textureInfo =  [GLKTextureLoader textureWithCGImage:image.CGImage options:@{GLKTextureLoaderOriginBottomLeft : @YES} error:NULL];
    self.textureInfo2 = textureInfo;
    
    // 开启标准混合模式
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    [self.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textTureCoords) shouldEnable:YES];
    
    self.baseEffect.texture2d0.name = self.textureInfo1.name;
    self.baseEffect.texture2d0.target = self.textureInfo1.target;
    [self.baseEffect prepareToDraw];

    [self.vertexBuffer drawWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertex:sizeof(vertices)/ sizeof(SceneVertex)];
    
    self.baseEffect.texture2d0.name = self.textureInfo2.name;
    self.baseEffect.texture2d0.target = self.textureInfo2.target;
    [self.baseEffect prepareToDraw];
    
    [self.vertexBuffer drawWithMode:GL_TRIANGLES startVertexIndex:0 numberOfVertex:sizeof(vertices)/ sizeof(SceneVertex)];
    
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
