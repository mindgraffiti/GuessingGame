//
//  GuessingGame.m
//  GuessingGame
//
//  Created by Tracy Brandt Jr on 4/1/13.
//  Copyright (c) 2013 OneRedCup. All rights reserved.
//

#import "GuessingGame.h"
#define DEFAULT_MAX_CHOICES 9

@interface GuessingGame()
@property (nonatomic, readwrite) NSInteger answer;
@property (nonatomic, strong) NSDate *startTime;
-(void)initializeChoicesWithAnswer:(NSInteger)answer;
@end

@implementation GuessingGame

-(NSMutableArray *)choices{
    if(!_choices) _choices = [[NSMutableArray alloc] init];
    return _choices;
}
- (void)startGame
{
    self.canGuessAgain = YES;
    self.maxChoices = DEFAULT_MAX_CHOICES;
    self.answer = [self generateRandomAnswer];
    self.startTime = [NSDate date];
}
- (id)initWithMaxChoices:(NSInteger)maxChoices
{
    self = [super init];
    if (self) {
        self.canGuessAgain = YES;
        self.maxChoices = maxChoices;
        self.answer = [self generateRandomAnswer];
    }
    return self;
}

-(void)initializeChoicesWithAnswer:(NSInteger)answer{
    [self.choices removeAllObjects];
    NSLog(@"%d", answer);
    for (int i = 1; i <= self.maxChoices; i++) {
        Choice *choice = [[Choice alloc] init];
        choice.value = i;
        choice.isEnabled = YES;
        choice.isAnswer = i == answer;
        [self.choices addObject:choice];
    }
}

-(void)setAnswer:(NSInteger)answer
{
    _answer = answer;
    [self initializeChoicesWithAnswer:answer];
}

-(Choice *)choiceAtIndex:(NSUInteger)index{
    return (index < [self.choices count]) ? self.choices[index] : nil;
}

-(void)guess:(Choice *)choice{
    self.tries++;
    if(choice.isAnswer){
        self.duration = [[NSDate date] timeIntervalSinceDate:self.startTime];
        self.wins++;
        self.isWinner = YES;
    }else{
        self.canGuessAgain = self.tries < self.maxTries;
        if(!self.canGuessAgain){
            [self.choices setValue:[NSNumber numberWithBool:NO] forKey:@"isEnabled"];
        }else{
            choice.isEnabled = NO;
        }
    }
}

-(NSInteger)generateRandomAnswer{
    return (arc4random() % self.maxChoices) + 1;
}

-(void)resetGame{
    if(self.wins < self.maxWins){
        self.tries = 0;
        self.isWinner = NO;
        [self initializeChoicesWithAnswer:[self generateRandomAnswer]];
    }
    else{
        [self.choices setValue:[NSNumber numberWithBool:NO] forKey:@"isEnabled"];
    }
}

@end
