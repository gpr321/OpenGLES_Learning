//
//  AGLKView.m
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKView.h"

@implementation AGLKView

+ (Class)layerClass{
    return [CAEAGLLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame context:(EAGLContext *)context{
    if ( self = [super initWithFrame:frame] ) {
        [self setUp];
        self.context = context;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if ( self = [super initWithCoder:aDecoder] ) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    layer.drawableProperties = @{
        kEAGLDrawablePropertyRetainedBacking : @NO,
        kEAGLDrawablePropertyColorFormat : kEAGLColorFormatRGBA8
        };
}

- (void)display{
    [EAGLContext setCurrentContext:self.context];
    glViewport(0, 0, (GLint)self.drawableWidth, (GLint)self.drawableHeight);
    [self drawRect:self.bounds];
    [self.context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)drawRect:(CGRect)rect{
    if ( [self.delegate respondsToSelector:@selector(glkView:drawInRect:)] ) {
        [self.delegate glkView:self drawInRect:rect];
    }
}

- (void)dealloc{
    if ( [EAGLContext currentContext] == _context ) {
        [EAGLContext setCurrentContext:nil];
    }
    _context = nil;
}

- (void)setContext:(EAGLContext *)context{
    if ( _context == context ) return;
    _context = context;
    [EAGLContext setCurrentContext:context];
    // delete any buffers
    if ( 0 != _defaultFrameBuffer ) {
        glDeleteFramebuffers(0, &_defaultFrameBuffer);
        _defaultFrameBuffer = 0;
    }
    
    if ( 0 != _colorRenderBuffer ) {
        glDeleteBuffers(0, &_colorRenderBuffer);
        _colorRenderBuffer = 0;
    }
    
    if ( _context == nil ) return;
    // config the context
    [EAGLContext setCurrentContext:context];
    
    glGenFramebuffers(1, &_defaultFrameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _defaultFrameBuffer);
    
    glGenRenderbuffers(1, &_colorRenderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
    
    // attach color render buffer to bound frame buffer
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, _colorRenderBuffer);
    [self layoutSubviews];
    
}

- (void)layoutSubviews{
    CAEAGLLayer *layer = (CAEAGLLayer *)self.layer;
    
    [EAGLContext setCurrentContext:self.context];
    
    [self.context renderbufferStorage:GL_RENDERBUFFER fromDrawable:layer];
    
    if ( 0 != _depthRenderBuffer ) {
        glDeleteRenderbuffers(1, &_depthRenderBuffer);
        _depthRenderBuffer = 0;
    }
    
    GLint currDrawableWidth = (GLint)self.drawableWidth;
    GLint currDrawableHeight = (GLint)self.drawableHeight;
    
    if ( self.drawbleDepthFormat != AGLKViewDrawableDepthFormatNone &&
        currDrawableHeight > 0 && currDrawableWidth > 0) {
        glGenRenderbuffers(1, &_depthRenderBuffer);
        glBindRenderbuffer(GL_RENDERBUFFER, _depthRenderBuffer);
        glRenderbufferStorage(GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, currDrawableWidth, currDrawableHeight);
        glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_FRAMEBUFFER, _depthRenderBuffer);
    }
    
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    
    if ( status != GL_COMPILE_STATUS ) {
        NSLog(@"fail to make complete frame buffer");
    }
    
    glBindRenderbuffer(GL_RENDERBUFFER, _colorRenderBuffer);
}

- (NSInteger)drawableWidth{
    GLint backingWidth;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_WIDTH, &backingWidth);
    return backingWidth;
}

- (NSInteger)drawableHeight{
    GLint backingHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER, GL_RENDERBUFFER_HEIGHT, &backingHeight);
    return backingHeight;
}

@end
