//
//  Gesture.h
//  iStroke
//
//  Created by dabao on 12-2-11.
//  Copyright 2012年 PKU. All rights reserved.
//

#include <vector>

namespace iStroke
{
	class Triple
	    {
	    public:
	        float x;
	        float y;
	        TimeValue t;

	        Triple(float x_,float y_,TimeValue t_):x(x_),y(y_),t(t_){}
	        void update(float x_,float y_,TimeValue t_){x=x_;y=y_;t=t_;}
	    };

	    class PreStroke:public std::vector<Triple*>
	    {
	    public:
	        void add(Triple* p){ push_back(p);}
	        bool valid(){return size()>2;}
	    };

	    class Gesture
	    {
	    public:
	        struct Point
	        {
	            double x;
	            double y;
	            Point operator+(const Point &p) {
	                Point sum = { x + p.x, y + p.y };
	                return sum;
	            }
	            Point operator-(const Point &p) {
	                Point sum = { x - p.x, y - p.y };
	                return sum;
	            }
	            Point operator*(const double a) {
	                Point product = { x * a, y * a };
	                return product;
	            }
	        };

	        Gesture(PreStroke &ps,int trigger,int button,bool enableTimeout);
	    private:
	        int trigger;
	        int button;
	        bool enableTimeout;

	    };
}