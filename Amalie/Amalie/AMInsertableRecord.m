//
//  AMInsertableRecord.m
//  Amalie
//
//  Created by Keith Staines on 23/07/2013.
//  Copyright (c) 2013 Keith Staines. All rights reserved.
//

#import "AMInsertableRecord.h"
#import "KSMWorksheet.h"
#import "KSMExpression.h"
#import "AMNameRules.h"

@interface AMInsertableRecord()
{

}

@property (readonly) AMNameRules * nameRules;

@end

@implementation AMInsertableRecord

-(void)deleteFromStore
{
    // TODO: Add code to delete the record from the store
}

- (id)init
{
    [NSException raise:@"Use the designated initializer." format:nil];
    return nil;
}

- (id)initWithName:(NSAttributedString*)attributedName
         nameRules:(AMNameRules*)nameRules
              uuid:(NSString *)uuid
              type:(AMInsertableType)type
{
    self = [super init];
    if (self) {
        _attributedName = attributedName;
        if (!_attributedName) {
            _attributedName = [nameRules suggestNameForType:type];
        }
        _uuid = uuid;
        _type = type;

    }
    return self;
}


-(BOOL)changeAttributedNameIfValid:(NSAttributedString*)proposedName
                             error:(NSError**)error
{
    BOOL isValid = [self.nameRules checkName:proposedName
                                 forType:self.type
                                   error:error];

    if (isValid) self.attributedName = proposedName;
    return isValid;
}

- (void)dealloc
{

}

@end
