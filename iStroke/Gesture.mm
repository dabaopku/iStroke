//
//  Gesture.m
//  iStroke
//
//  Created by dabao on 12-2-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#include "Gesture.hh"

namespace iStroke
{
	
    Gesture::Gesture(PreStroke &ps,int trigger_,int button_,bool enableTimeout_)
        :button(button_),enableTimeout(enableTimeout_)
    {
        trigger=trigger_;

        if(ps.valid())
        {
            for(std::vector<Triple*>::iterator i=ps.begin();
                i!=ps.end();++i)
            {
				
            }
        }
    }
}    