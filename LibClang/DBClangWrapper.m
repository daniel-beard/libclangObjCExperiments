//
//  DBClangWrapper.m
//  LibClang
//
//  Created by Daniel Beard on 1/22/15.
//  Copyright (c) 2015 DanielBeard. All rights reserved.
//

#import "DBClangWrapper.h"
#include "clang-c/BuildSystem.h"
#include "clang-c/CXCompilationDatabase.h"
#include "clang-c/CXErrorCode.h"
#include "clang-c/CXString.h"
#include "clang-c/Documentation.h"
#include "clang-c/Index.h"
#include "clang-c/Platform.h"


@implementation DBClangWrapper

+ (void)startWithFileName:(NSString *)fileName {
    
    // Create index
    CXIndex index = clang_createIndex(0, 0);
    
    // Command line arguments
    /*
    const char *args[] = {
        "-I/usr/include",
        "-I."
    };
    int numArgs = sizeof(args) / sizeof(*args);*/
    
    // Load file to parse
    CXTranslationUnit tu = clang_parseTranslationUnit(index, fileName.UTF8String, NULL, 0, NULL, 0, CXTranslationUnit_None);
    
    // Get count of diagnostics
    unsigned diagnosticCount = clang_getNumDiagnostics(tu);
    
    // Loop through, fetch each diagnostic and print
    for (unsigned i=0; i < diagnosticCount; i++) {
        CXDiagnostic diagnostic = clang_getDiagnostic(tu, i);
        
        // Get line number and column from source location
        CXSourceLocation sourceLocation = clang_getDiagnosticLocation(diagnostic);
        unsigned int line = 0;
        unsigned int column = 0;
        clang_getSpellingLocation(sourceLocation, NULL, &line, &column, NULL);
        
        // Get what the diagnostic actually says
        CXString text = clang_getDiagnosticSpelling(diagnostic);
        
//        NSLog(@"%@:%@ %@", @(line), @(column), @(clang_getCString(text)));
    }
    
    //=========================================================================
    // Walk the tree
    //=========================================================================
    clang_visitChildrenWithBlock(clang_getTranslationUnitCursor(tu), ^enum CXChildVisitResult(CXCursor cursor, CXCursor parent) {
        
        // Ignore system headers
        if (clang_Location_isInSystemHeader(clang_getCursorLocation(cursor))) {
            return CXChildVisit_Continue;
        }
        
        if (clang_getCursorKind(cursor) == CXCursor_VarDecl) {
//        if (clang_getCursorKind(cursor) == CXCursor_ObjCPropertyDecl) {
//        if (clang_getCursorKind(cursor) == CXCursor_ObjCMessageExpr) {
            
            CXSourceRange range = clang_getCursorExtent(cursor);
            CXSourceLocation location = clang_getRangeStart(range);
            
            CXFile file;
            unsigned line;
            unsigned column;
            clang_getFileLocation(location, &file, &line, &column, NULL);
            
            // File name
            CXString filename = clang_getFileName(file);
            
            // Variable's name
            CXString name = clang_getCursorSpelling(cursor);
            
            // Print
            NSLog(@"%@:%@:%@ found variable %@", @(clang_getCString(filename)), @(line), @(column), @(clang_getCString(name)));
        }
        // We want to visit everthing, so tell Clang to recurse
        return CXChildVisit_Recurse;
    });
    
}

@end
