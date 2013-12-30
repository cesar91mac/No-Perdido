//
//  Connection.m
//  XMLParser
//
//  Created by Mauricio on 12/11/13.
//  Copyright (c) 2013 Mauricio. All rights reserved.
//

#import "Connection.h"

@implementation Connection

-(BOOL) response:(int)action parameters:(NSMutableDictionary*) array
{
    self.APIResult = @"NOYET";
    
    NSURL * url;
    
    if(action == 1)
        url = [NSURL URLWithString:@"http://localhost:8888/nomas/"];
    else if (action == 8)
        url = [NSURL URLWithString:@"http://appcatlan.comyr.com/nomas/location.php"];
    else
        url = [NSURL URLWithString:@"http://www.nomasperdido.com/cgi-bin/receivePost.php"];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *body;
    
    switch (action)
    {
            //Hecho
            //Inicio de sesion --- “email”, “password”
        case 1:
            body = [NSString stringWithFormat:@"action=login&email=%@&password=%@",[array objectForKey:@"email"],[array objectForKey:@"password"]];
            break;
            
            //Check
            //Hecho
            //Registro de usuario --- “email”, “firstname”, “lastname”, “password”, “phone1”
        case 2:
            body = [NSString stringWithFormat:@"action=register&email=%@&password=%@&firstname=%@&lastname=%@&phone1=%@&phone2=&phone3=&phone4=&phone5=",[array objectForKey:@"email"],[array objectForKey:@"password"],[array objectForKey:@"firstname"],[array objectForKey:@"lastname"],[array objectForKey:@"phone1"]];
            
            break;
            
            
            //Anadir telefono al usuario --- “count”, “phone” (varios números),  “email”
        case 3:
            body = [NSString stringWithFormat:@"action=add_new_users&email=%@&count=%@%@",[array objectForKey:@"email"],[array objectForKey:@"count"],[array objectForKey:@"saveCad"]];
            break;
            
            
            //Eliminar telefono del usuario --- “phoneN”, “email”
        case 4:
            body = [NSString stringWithFormat:@"action=delete_user&email=%@&count=%@%@",[array objectForKey:@"email"],[array objectForKey:@"count"],[array objectForKey:@"deleteCad"]];

            break;
            
            //Check
            //Hecho
            //Registrar mascota --- “email”, “name”, “phone”
        case 5:
            body = [NSString stringWithFormat:@"action=add_new_pet&email=%@&petname=%@&phone=%@",[array objectForKey:@"email"],[array objectForKey:@"petname"],[array objectForKey:@"phone"]];
            break;
            
            //Check
            //Hecho
            //Borrar mascota --- “email”, “phone”
        case 6:
            body = [NSString stringWithFormat:@"action=delete_pet&phone=%@&email=%@",[array objectForKey:@"phone"],[array objectForKey:@"email"]];
            break;
            
            //Check
            //Hecho
            //Editar Mascota --- "email", "phone", "new_phone", "petname"
        case 7:
            body = [NSString stringWithFormat:@"action=edit_pet&email=%@&new_phone=%@&petname=%@&phone=%@",[array objectForKey:@"email"],[array objectForKey:@"new_phone"],[array objectForKey:@"petname"],[array objectForKey:@"phone"]];
            break;
            
            //Localización
        case 8:
            body = [NSString stringWithFormat:@"action=get_pet_location&email=%@&phone=%@",[array objectForKey:@"email"],[array objectForKey:@"phone"]];
            break;
    }
    
    NSLog(@"%@",body);
    /*
    if(action == 3 || action == 4)
    {
        self.APIResult = @"0";
        return YES;
    }*/
    
    [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response,
                                                                                        NSData *data, NSError *error) {
        if (error == nil)
        {
            NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //NSLog(@"html [%@]", html);
            
            if(action == 1 || action == 8)
            {
                NSData *jsonData = [html dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error = [[NSError alloc]init];
                
                self.JSONResult = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
            }
            
            self.APIResult = html;
        }
        else
        {
            //NSLog(@"Error happened = %@",error);
            self.APIResult = @"ERROR";
        } }];
    
    return YES;
}

@end
