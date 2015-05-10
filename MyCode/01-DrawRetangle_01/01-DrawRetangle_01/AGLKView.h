//
//  AGLKView.h
//  01-DrawRetangle_01
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <GLKit/GLKit.h>
@protocol AGLKViewDelegate;

typedef NS_ENUM(NSInteger, AGLKViewDrawableDepthFormat) {
    AGLKViewDrawableDepthFormatNone = 0,
    AGLKViewDrawableDepthFormat16
};

@interface AGLKView : UIView
{
    GLuint              _defaultFrameBuffer;
    GLuint              _colorRenderBuffer;
    GLuint              _depthRenderBuffer;
}

@property (nonatomic,weak) IBOutlet id<GLKViewDelegate> delegate;
@property (nonatomic,strong) EAGLContext *context;
@property (nonatomic,readonly) NSInteger drawableWidth;
@property (nonatomic,readonly) NSInteger drawableHeight;
@property (nonatomic,assign) AGLKViewDrawableDepthFormat drawbleDepthFormat;

- (void)display;

@end


@protocol AGLKViewDelegate <NSObject>

@required
- (void)glkView:(AGLKView *)view drawInRect:(CGRect)rect;

@end
