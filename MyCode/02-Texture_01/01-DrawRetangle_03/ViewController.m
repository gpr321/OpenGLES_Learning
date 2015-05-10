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
    GLKVector2 textTureCoords;
} SceneVertex;

@interface ViewController ()

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic,weak) AGLKContext *context;

@property (nonatomic,assign) GLuint vertexBufferID;

@end

@implementation ViewController

static const SceneVertex vertices[] = {
//    {{-0.5, -0.5, 0.0}},
//    {{-0.5, 0.5, 0.0}},
//    {{0.5, 0.5, 0.0}}
    {{-0.5, -0.5, 0.0}, {0.0f, 0.0f}},
    {{-0.5, 0.5, 0.0}, {1.0f, 0.0f}},
    {{0.5, 0.5, 0.0}, {0.0f, 1.0f}}
};

- (GLKBaseEffect *)baseEffect{
    if ( _baseEffect == nil ) {
        _baseEffect = [[GLKBaseEffect alloc] init];
        _baseEffect.useConstantColor = GL_TRUE;
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return _baseEffect;
}


//- (void)viewDidLoad{
//    [super viewDidLoad];
////    GLKView *view = (GLKView *)self.view;
////    
////    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
////    view.context = context;
////    [EAGLContext setCurrentContext:context];
////    
////    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
////    glGenBuffers(1, &_vertexBufferID);
////    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
////    
////    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
//    
//    // Verify the type of view created automatically by the
//    // Interface Builder storyboard
//    GLKView *view = (GLKView *)self.view;
//    NSAssert([view isKindOfClass:[GLKView class]],
//             @"View controller's view is not a GLKView");
//    
//    // Create an OpenGL ES 2.0 context and provide it to the
//    // view
//    view.context = [[EAGLContext alloc]
//                    initWithAPI:kEAGLRenderingAPIOpenGLES2];
//    
//    // Make the new context current
//    [EAGLContext setCurrentContext:view.context];
//    
//    // Create a base effect that provides standard OpenGL ES 2.0
//    // Shading Language programs and set constants to be used for
//    // all subsequent rendering
//    self.baseEffect = [[GLKBaseEffect alloc] init];
//    self.baseEffect.useConstantColor = GL_TRUE;
//    self.baseEffect.constantColor = GLKVector4Make(
//                                                   1.0f, // Red
//                                                   1.0f, // Green
//                                                   1.0f, // Blue
//                                                   1.0f);// Alpha
//    
//    // Set the background color stored in the current context
//    glClearColor(0.0f, 0.0f, 0.0f, 1.0f); // background color
//    
//    // Generate, bind, and initialize contents of a buffer to be
//    // stored in GPU memory
//    glGenBuffers(1,                // STEP 1
//                 &_vertexBufferID);
//    glBindBuffer(GL_ARRAY_BUFFER,  // STEP 2
//                 _vertexBufferID);
//    glBufferData(                  // STEP 3
//                 GL_ARRAY_BUFFER,  // Initialize buffer contents
//                 sizeof(vertices), // Number of bytes to copy
//                 vertices,         // Address of bytes to copy
//                 GL_STATIC_DRAW);  // Hint: cache in GPU memory
//}
//
//- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
//    [self.baseEffect prepareToDraw];
//    
//    glClear(GL_COLOR_BUFFER_BIT);
//    
//    glEnableVertexAttribArray(GLKVertexAttribPosition);
//    
//    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, offsetof(SceneVertex, positionCoords), NULL );
//    
//    glDrawArrays(GL_TRIANGLES, 0, 3);
//    
////    [self.baseEffect prepareToDraw];
//    
////    // Clear Frame Buffer (erase previous drawing)
////    glClear(GL_COLOR_BUFFER_BIT);
////    
////    // Enable use of positions from bound vertex buffer
////    glEnableVertexAttribArray(      // STEP 4
////                              GLKVertexAttribPosition);
////    
////    glVertexAttribPointer(          // STEP 5
////                          GLKVertexAttribPosition,
////                          3,                   // three components per vertex
////                          GL_FLOAT,            // data is floating point
////                          GL_FALSE,            // no fixed point scaling
////                          sizeof(SceneVertex), // no gaps in data
////                          NULL);               // NULL tells GPU to start at
////    // beginning of bound buffer
////    
////    // Draw triangles using the first three vertices in the
////    // currently bound vertex buffer
////    glDrawArrays(GL_TRIANGLES,      // STEP 6
////                 0,  // Start with first vertex in currently bound buffer
////                 3); // Use three vertices from currently bound buffer
//}
//
//- (void)viewDidUnload{
//    [super viewDidUnload];
//    GLKView *view = (GLKView *)self.view;
//    [EAGLContext setCurrentContext:view.context];
//    
//    if ( 0 != _vertexBufferID ) {
//        glDeleteBuffers(1, &_vertexBufferID);
//        _vertexBufferID = 0;
//    }
//    
//    view.context = nil;
//    [EAGLContext setCurrentContext:nil];
//}

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
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    [self.baseEffect prepareToDraw];
    
    [self.context clear:GL_COLOR_BUFFER_BIT];
    
    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition numberOfCoordinates:3 attribOffset:offsetof(SceneVertex, positionCoords) shouldEnable:YES];

    [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0 numberOfCoordinates:2 attribOffset:offsetof(SceneVertex, textTureCoords) shouldEnable:YES];
    
    
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
