//
//  TSDisplayContent.m
//  Triper_IOS
//
//  Created by Mac on 19.07.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSDisplayContent.h"

@implementation TSDisplayContent

+ (NSString *)displayContent:(NSInteger)tag
{
    NSString *content = nil;
    
    
    NSArray *mission = @[@"The mission of Catholic Charities is to provide service to people in need, to advocate for justice in social structures, and to call the entire church and other people of good will to do the same.",
                         @"The ASPCA Animal Behavior Center is dedicated to promoting balanced, respectful and enriched relations between people and pets through graduate and post-graduate programs for aspiring animal behaviorists; continuing behavioral education for shelter personnel, trainers, veterinarians, and other animal professionals; and the provision of practical, humane advice on pet behavior for owners",
                         @"The mission of Mothers Against Drunk Driving is to stop drunk driving, support the victims of this violent crime and prevent underage drinking",
                         @"The Children's Center mission is to complement the service and education objectives of the university by: -Providing education, care, and nurturing for the children of students, staff, faculty, and community members. -Utilizing culturally and developmentally appropriate practices",
                         @"People for the Ethical Treatment of Animals (PETA) is the largest animal rights organization in the world, with more than 3 million members and supporters"];
    
    NSArray *about = @[@"If you would convince a man that he does wrong, do right. But do not care to convince him. Men will believe what they see. Let them see",
                       @"I would rather be an artist than a leader. Ironically, a leader has to follow the rules",
                       @"To bring up a child in the way he should go, travel that way yourself once in a while",
                       @"Hide yourself in God, so when a man wants to find you he will have to go there first.",
                       @"I may do some good before I am dead be a sort of success as a frightful example of what not to do; and so illustrate a moral story",
                       @"We should never permit ourselves to do anything that we are not willing to see our children do. We should set them an example that we wish them to imitate",
                       @"If your actions were to boomerang back on you instantly, would you still act the same? Doing to others an act you’d rather not have done to you reveals a powerful internal conflict",
                       @"In his life Christ is an example showing us how to live in his death he is a sacrifice satisfying our sins in his resurrection a conqueror in his ascension a king in his intercession a high priest"];
    
    NSArray *background = @[@"A biography is the story of a real person’s life (so not a fictional character) written by someone other than that person. It can be a page or several books long (see the the biography of Mark Twain…) Biographies explore the events in a person’s life and find meaning within them",
                            @"These items could include books, letters, pictures, newspapers and newspaper clippings, magazines, internet articles, journals, videos, interviews, existing biographies, or an autobiography. Only use material that has permissions available to use in your research, especially if you are going to publish and distribute the biography (or else you could end up with a lawsuit on your hands).",
                            @"Interviewing people will breath life into your research--people you interview may be able to tell you stories that you can’t find in a history book. If you can't interview the person you're writing about, see if you can interview someone who knows or knew the subject. You can conduct the interview in person, by phone, or through e-mail. Remember to be courteous and professional",
                            @"This can be helpful in putting yourself in his or her shoes. Visualize witnessing what they witnessed. Imagine how they felt. Take pictures for the biography. If you can't visit the actual place, try to visit a place like it. Here are some ideas",
                            @"What was he or she passionate about? Whether it was botany, poetry, classical music, or architecture, immerse yourself in it. Try to discover why the subject enjoyed it. How did this subject influence his or her own work or life",
                            @"If it was a long time ago, do some homework on what life was like back then. Figure out what role your subject played in the society of his/her time. Also account for regional differences. What's frowned upon in one place may be celebrated 30 miles (48 km) away. This can shed light on the subject's decisions, and their consequences"];
    NSArray *interest = @[@"Reading", @"Traveling", @"Blogging", @"Collecting", @"Volunteer", @"Cooking", @"Child Care", @"Sports", @"Club Memberships", @"Music"];
    
    if (tag == 1) {
        content = [NSString stringWithFormat:@"%@", [mission objectAtIndex:arc4random_uniform(5)]];
    } else if (tag == 2) {
        content = [NSString stringWithFormat:@"%@", [about objectAtIndex:arc4random_uniform(8)]];
    } else if (tag == 3) {
        content = [NSString stringWithFormat:@"%@", [background objectAtIndex:arc4random_uniform(6)]];
    } else if (tag == 4) {
        NSInteger randomValue = arc4random_uniform(3);
        if (randomValue == 0) {
            content = [NSString stringWithFormat:@"%@", [interest objectAtIndex:arc4random_uniform(10)]];
        } else if (randomValue == 1) {
            content = [NSString stringWithFormat:@"%@, %@", [interest objectAtIndex:arc4random_uniform(10)],
                                                            [interest objectAtIndex:arc4random_uniform(10)]];
        } else if (randomValue == 2) {
            content = [NSString stringWithFormat:@"%@, %@, %@", [interest objectAtIndex:arc4random_uniform(10)],
                                                                [interest objectAtIndex:arc4random_uniform(10)],
                                                                [interest objectAtIndex:arc4random_uniform(10)]];
        }
    }
    return content;
}

@end
