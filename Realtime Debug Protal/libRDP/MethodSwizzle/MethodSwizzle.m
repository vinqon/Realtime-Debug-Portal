/*
 * MethodSwizzle.m
 *
 * Copyright (c) 2007-2011 Kent Sutherland
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MethodSwizzle.h"
#import <objc/runtime.h>

void MethodSwizzle(Class aClass, SEL orig_sel, SEL alt_sel) {
    Method orig_method = nil, alt_method = nil;
  
    // First, look for the methods
    orig_method = class_getInstanceMethod(aClass, orig_sel);
    alt_method = class_getInstanceMethod(aClass, alt_sel);
	
    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
        method_exchangeImplementations(orig_method, alt_method);
	}
}

void MethodSwizzleClass(Class aClass, SEL orig_sel, SEL alt_sel) {
    Method orig_method = nil, alt_method = nil;
	
    // First, look for the methods
    orig_method = class_getClassMethod(aClass, orig_sel);
    alt_method = class_getClassMethod(aClass, alt_sel);
	
    // If both are found, swizzle them
    if ((orig_method != nil) && (alt_method != nil)) {
        method_exchangeImplementations(orig_method, alt_method);
	}
}
