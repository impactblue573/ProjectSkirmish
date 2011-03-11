//
//  Input.h
//  ProjectSkirmish
//
//  Created by Tony Luk on 30/12/10.
//  Copyright 2010 ImpactBlue Studios™. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Input : NSObject {

}

-(CGPoint)moveVector; 
-(bool) targetTapped;
-(CGPoint) tapPosition;

@end
