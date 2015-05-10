//
//  AGLKVertexAttribArrayBuffer.m
//  01-DrawRetangle_03
//
//  Created by mac on 15/5/10.
//  Copyright (c) 2015年 gpr. All rights reserved.
//

#import "AGLKVertexAttribArrayBuffer.h"
#import <GLKit/GLKit.h>

@interface AGLKVertexAttribArrayBuffer ()

@property (nonatomic,assign) GLuint vertexBufferID;

@property (nonatomic,assign) GLsizei stride;

@property (nonatomic,assign) GLsizeiptr size;

@end

@implementation AGLKVertexAttribArrayBuffer

- (void)dealloc{
    if ( 0 != _vertexBufferID ) {
        glDeleteBuffers(1, &_vertexBufferID);
        _vertexBufferID = 0;
    }
}

- (instancetype)initWithStride:(GLsizei)stride numberOfVertices:(GLsizei)count bytes:(const GLvoid *)dataPtr usage:(GLenum)usage{
    if ( self = [super init] ) {
        glGenBuffers(1, &_vertexBufferID);
        glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
        GLsizeiptr size = stride * count;
        _size = size;
        glBufferData(GL_ARRAY_BUFFER, size, dataPtr, usage);
    }
    return self;
}

- (void)prepareToDrawWithAttrib:(GLuint)index count:(GLint)count attribOffset:(GLsizeiptr)offset shouldEnable:(BOOL)shouldEnable{
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBufferID);
    
    if ( shouldEnable ) {
        glEnableVertexAttribArray(index);
    }

    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
    
}

- (void)drawWithMode:(GLenum)mode startVertexIndex:(GLint)first numberOfVertex:(GLsizei)count{
    NSAssert(_size >=
             ((first + count) * self.stride),
             @"Attempt to draw more vertex data than available.");
    glDrawArrays(mode, first, count);
}

@end
