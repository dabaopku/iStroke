//
//  Stroke.hh
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//
#include <iostream>

namespace iStroke {
	class Stroke {
	public:
		Stroke(int n=100);
		~Stroke();
        Stroke * clone();
        
        // create
		void addPoint(double x, double y);
		void finish();

        //accessor
		int size() const;
        int getCapacity() const;
        
		struct Point {
			double x;
			double y;
			double t;
			double dt;
			double alpha;
		};
		Point point(int index) const;
        double x(int index) const;
        double y(int index) const;
		double time(int index) const;
		double angle(int index) const;
        double alpha(int index) const;
        
        //algoithm
		double compare(const Stroke & s,int *path_x=0, int *path_y=0) const;

		const static double infinity;
		const static double eps;

    private:
        bool isReady;
		int n;
		int capacity;		Point *p;
		double angleDiff(const Stroke & s, int i, int j) const;
        
    public:
        friend std::ostream & operator<<(std::ostream & os,const Stroke & obj);
        friend std::istream & operator>>(std::istream & is,Stroke & obj);
};

}
