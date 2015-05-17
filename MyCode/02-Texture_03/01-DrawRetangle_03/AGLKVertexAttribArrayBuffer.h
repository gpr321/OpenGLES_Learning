//
//  AGLKVertexAttribArrayBuffer.h
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface AGLKVertexAttribArrayBuffer : NSObject

- (instancetype)initWithStride:(GLsizei)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage;

- (void)prepareToDrawWithAttrib:(GLuint)index numberOfCoordinates:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable;

- (void)drawWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertex:(GLsizei)count;

- (void)reinitWithAttributeStride:(GLsizei)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr;

@end
