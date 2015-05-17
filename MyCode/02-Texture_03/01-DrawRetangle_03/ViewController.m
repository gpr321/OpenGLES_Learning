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

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value;

@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)parameterID value:(GLint)value{
    glBindTexture(self.target, self.name);
    
    glTexParameteri(self.target, parameterID, value);
}

@end

@interface ViewController ()

@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexBuffer;

@property (nonatomic,weak) AGLKContext *context;

@property (nonatomic,assign) GLuint vertexBufferID;

@property (nonatomic,assign) BOOL shouldUseLinearFilter;
@property (nonatomic,assign) BOOL shouldAnimate;
@property (nonatomic,assign) BOOL shouldRepeatTexture;
@property (nonatomic,assign) CGFloat sCoordinateOffset;

@end

@implementation ViewController

//static const SceneVertex vertices[] = {
//    {{-0.5, -0.5, 0.0}, {0.0f, 0.0f}},
//    {{-0.5, 0.5, 0.0}, {1.0f, 0.0f}},
//    {{0.5, 0.5, 0.0}, {0.0f, 1.0f}}
//};
static SceneVertex vertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

static const SceneVertex defaultVertices[] =
{
    {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] = {
    {-0.02f,  -0.01f, 0.0f},
    {0.01f,  -0.005f, 0.0f},
    {-0.01f,   0.01f, 0.0f},
};

- (GLKBaseEffect *)baseEffect{
    if ( _baseEffect == nil ) {
        _baseEffect = [[GLKBaseEffect alloc] init];
        _baseEffect.useConstantColor = GL_TRUE;
        _baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    }
    return _baseEffect;
}

- (void)update{
    [self updateAnimationVertexPosition];
    [self updateTextureParameters];
    
    [self.vertexBuffer reinitWithAttributeStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices)/ sizeof(SceneVertex) bytes:vertices];
}

- (void)updateAnimationVertexPosition{

    if ( self.shouldAnimate ) {
        int i = 0;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x += movementVectors[i].x;
            if ( vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0f ) {
                movementVectors[i].x = -movementVectors[i].x;
            }
            
            vertices[i].positionCoords.y += movementVectors[i].y;
            if ( vertices[i].positionCoords.y >= 1.0f || vertices[i].positionCoords.y <= -1.0f ) {
                movementVectors[i].y = -movementVectors[i].y;
            }
            
            vertices[i].positionCoords.z += movementVectors[i].z;
            if ( vertices[i].positionCoords.z >= 1.0f || vertices[i].positionCoords.z <= -1.0f ) {
                movementVectors[i].z = -movementVectors[i].z;
            }
        }
        
//        int    i;  // by convention, 'i' is current vertex index
//        
//        for(i = 0; i < 3; i++)
//        {
//            vertices[i].positionCoords.x += movementVectors[i].x;
//            if(vertices[i].positionCoords.x >= 1.0f ||
//               vertices[i].positionCoords.x <= -1.0f)
//            {
//                movementVectors[i].x = -movementVectors[i].x;
//            }
//            vertices[i].positionCoords.y += movementVectors[i].y;
//            if(vertices[i].positionCoords.y >= 1.0f ||
//               vertices[i].positionCoords.y <= -1.0f)
//            {
//                movementVectors[i].y = -movementVectors[i].y;
//            }
//            vertices[i].positionCoords.z += movementVectors[i].z;
//            if(vertices[i].positionCoords.z >= 1.0f ||
//               vertices[i].positionCoords.z <= -1.0f)
//            {
//                movementVectors[i].z = -movementVectors[i].z;
//            }
//        }
    } else {
        int i = 0;
        for (i = 0; i < 3; i++) {
            vertices[i].positionCoords.x = defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y = defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z = defaultVertices[i].positionCoords.z;
        }
    }
    
    {
        int i = 0;
        for (i = 0; i < 3; i++) {
            vertices[i].textTureCoords.s = defaultVertices[i].textTureCoords.s + self.sCoordinateOffset;
        }
    }
    
}

- (void)updateTextureParameters{
    GLuint shouldRepeat = self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE;
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S value:shouldRepeat];
    // GL_LINEAR
    GLuint shouldUseNearFliter = self.shouldUseLinearFilter ? GL_NEAREST :GL_LINEAR ;
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER value:shouldUseNearFliter];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 指定GLKView 的更新帧率
    self.preferredFramesPerSecond = 60;
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    self.shouldUseLinearFilter = YES;
    
    GLKView *view = (GLKView *)self.view;
    
    AGLKContext *context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    NSAssert(context, @"api2 is not avaiable");
    view.context = context;
    [AGLKContext setCurrentContext:context];
    
    context.clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    self.context = context;
    // 如果使用动画 vertex usage: GL_DYNAMIC_DRAW
    _vertexBuffer = [[AGLKVertexAttribArrayBuffer alloc] initWithStride:sizeof(SceneVertex) numberOfVertices:sizeof(vertices) / sizeof(SceneVertex) bytes:vertices usage:GL_DYNAMIC_DRAW];
    
    UIImage *image = [UIImage imageNamed:@"grid.png"];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:image.CGImage options:nil error:NULL];
    // AGLKTextureInfo *textureInfo = [AGLKTextureLoader targetWithCGImage:image.CGImage options:nil error:NULL];
    
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


- (IBAction)shouldLinearFilter:(UISwitch *)sender {
    self.shouldUseLinearFilter = [sender isOn];
}

- (IBAction)shouldRepeatTexture:(UISwitch *)sender {
    self.shouldRepeatTexture = [sender isOn];
}

- (IBAction)shouldAnimation:(UISwitch *)sender {
    self.shouldAnimate = [sender isOn];
}


- (void)viewDidUnload{
    [super viewDidUnload];
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    _vertexBuffer = nil;
    
    view.context = nil;
    [AGLKContext setCurrentContext:nil];
}


- (IBAction)takeSCooridinateFrom:(UISlider *)sender {
    self.sCoordinateOffset = sender.value;
}

@end
