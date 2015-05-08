//
//  AudioHistoryFilter.m
//  Messenger for Telegram
//
//  Created by keepcoder on 30.05.14.
//  Copyright (c) 2014 keepcoder. All rights reserved.
//

#import "AudioHistoryFilter.h"
#import "ChatHistoryController.h"
@implementation AudioHistoryFilter

static NSMutableArray * messageItems;
static NSMutableDictionary * messageKeys;

-(id)initWithController:(ChatHistoryController *)controller {
    if(self = [super initWithController:controller]) {
    }
    
    return self;
}

-(int)type {
    return HistoryFilterAudio;
}

+(int)type {
    return HistoryFilterAudio;
}

- (NSMutableDictionary *)messageKeys {
    return messageKeys;
}

- (NSMutableArray *)messageItems {
    return messageItems;
}

+ (NSMutableDictionary *)messageKeys {
    return messageKeys;
}

+ (NSMutableArray *)messageItems {
    return messageItems;
}


+(void)drop {
    [messageKeys removeAllObjects];
    [messageItems removeAllObjects];
}


+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageItems = [[NSMutableArray alloc] init];
        messageKeys = [[NSMutableDictionary alloc] init];
        
    });
}

-(void)remoteRequest:(BOOL)next peer_id:(int)peer_id callback:(void (^)(id response))callback {
    
    self.request = [RPCRequest sendRequest:[TLAPI_messages_search createWithPeer:[self.controller.conversation inputPeer] q:@"" filter:[TL_inputMessagesFilterAudio create] min_date:0 max_date:0 offset:0 max_id:self.controller.max_id limit:(int)self.controller.selectLimit] successHandler:^(RPCRequest *request, id response) {
        
        
        if(callback && self != nil) {
            callback(response);
        }
        
    } errorHandler:^(RPCRequest *request, RpcError *error) {
        
        if(callback) {
            callback(nil);
        }
        
    } timeout:10 queue:[ASQueue globalQueue].nativeQueue];
    
}

-(NSString *)description {
    return NSLocalizedString(@"Conversation.Filter.Audio", nil);
}

@end
