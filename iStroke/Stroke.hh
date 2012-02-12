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

		void addPoint(double x, double y);
		void finish();

		int size() const;
		void point(int index, double &x, double &y) const;
		double time(int index) const;
		double angle(int index) const;
		double angleDiff(const Stroke & s, int i, int j) const;
		double compare(const Stroke & s,int *path_x=0, int *path_y=0) const;

		const static double infinity;
		const static double eps;

    private:
        bool isReady;
		int n;
		int capacity;
		struct Point {
			double x;
			double y;
			double t;
			double dt;
			double alpha;
		};
		Point *p;
        
    public:
        friend std::ostream & operator<<(std::ostream & os,const Stroke & obj);
        friend std::istream & operator>>(std::istream & is,Stroke & obj);
};

}
