//
//  Stroke.mm
//  iStroke
//
//  Created by dabao on 12-2-10.
//  Copyright 2012年 PKU. All rights reserved.
//

#import "Stroke.hh"
#include <iostream>
#include <math.h>
using namespace std;

namespace iStroke
{
    const double Stroke::infinity=0.2;
    const double Stroke::eps=0.000001;
    
    Stroke::Stroke(int n)
    :isReady(NO)
    {
        assert(n>0);
        this->n=0;
        this->capacity=n;
        this->p=new Point[n];
    }
    
    Stroke::~Stroke()
    {
        if(p) delete []p;
        p=0;
    }

    void Stroke::addPoint(double x, double y)
    {
        if(capacity<=n)
            return;
        p[n].x=x;
        p[n].y=y;
        n++;        
    }
    
    inline static double angle_difference(double alpha, double beta)
    {
        // return 1.0 - cos((alpha - beta) * M_PI);
        double d = alpha - beta;
        if (d < -1.0)
            d += 2.0;
        else if (d > 1.0)
            d -= 2.0;
        return d;
    }
	
    void Stroke::finish()
    {
        assert(capacity>0);
        
        double total=0;
        p[0].t=0;
        for (int i=0; i<n-1; ++i) {
            total+=hypot(p[i+1].x-p[i].x, p[i+1].y-p[i].y);
            p[i+1].t=total;
        }
        for (int i=0; i<n; ++i) {
            p[i].t/=total;
        }
        
        double minX=p[0].x,minY=p[0].y,maxX=minX,maxY=minY;
        for(int i=0;i<n;++i)
        {
            if(p[i].x<minX) minX=p[i].x;
            else if(p[i].x>maxX) maxX=p[i].x;
            if(p[i].y<minY) minY=p[i].y;
            else if(p[i].y>maxY) maxY=p[i].y;
        }
        double scaleX=maxX-minX;
        double scaleY=maxY-minY;
        double scale=(scaleX>scaleY)?scaleX:scaleY;
        if(scale<0.001) scale=1;
        double midX=(minX+maxX)/2;
        double midY=(minY+maxY)/2;
        for (int i=0; i<n; ++i) {
            p[i].x=(p[i].x-midX)/scale+0.5;
            p[i].y=(p[i].y-midY)/scale+0.5;
        }
        
        for (int i=0; i<n-1; ++i) {
            p[i].dt=p[i+1].t-p[i].t;
            p[i].alpha=atan2(p[i+1].y-p[i].y, p[i+1].x-p[i].x)/M_PI;
        }
        
        isReady=YES;
    }
    
    int Stroke::size() const
    {
        return n;
    }
    
    double Stroke::x(int index) const
    {
        assert(index>=0 && index<n);
        return p[index].x;
    }
    double Stroke::y(int index) const
    {
        assert(index>=0 && index<n);
        return p[index].y;
    }
    Stroke::Point Stroke::point(int index) const
    {
        assert(index>=0 && index<n);
        return p[index];
    }
    double Stroke::time(int index) const
    {
        assert(index>=0 && index<n);
        return p[index].t;
    }
    double Stroke::angle(int index) const
    {
        assert(index>=0 && index<n);
        return p[index].alpha;
    }
    double Stroke::alpha(int index) const
    {
        assert(index>=0 && index<n);
        return p[index].alpha;
    }
    int Stroke::getCapacity() const
    {
        return capacity;
    }
    inline static double sqr(double x) { return x*x; }
    
    double Stroke::angleDiff(const Stroke &s, int i, int j) const
    {
        return fabs(angle_difference(angle(i), s.angle(j)));
    }
    
    /* To compare two gestures, we use dynamic programming to minimize (an
     * approximation) of the integral over square of the angle difference among
     * (roughly) all reparametrizations whose slope is always between 1/2 and 2.
     */
    double Stroke::compare(const Stroke &s,int *path_x, int *path_y) const
    {
        assert(isReady);
        assert(s.isReady);
        
        double **dist;
        int **prev_x;
        int **prev_y;
        dist=new double*[n];
        prev_x=new int*[n];
        prev_y=new int*[n];
        for(int i=0;i<n;++i)
        {
            dist[i]=new double[s.n];
            prev_x[i]=new int[s.n];
            prev_y[i]=new int[s.n];
        }
        
        for (int i = 0; i < n-1; i++)
            for (int j = 0; j < s.n-1; j++)
                dist[i][j] = Stroke::infinity;
        dist[n-1][s.n-1] = Stroke::infinity;
        dist[0][0] = 0.0;
        
        for (int x = 0; x < n-1; x++) {
            for (int y = 0; y < s.n-1; y++) {
                if (dist[x][y] >= Stroke::infinity)
                    continue;
                double tx  = p[x].t;
                double ty  = s.p[y].t;
                int max_x = x;
                int max_y = y;
                __block int k = 0;
                
                void (^step)(int,int)=
                    ^(int x2,int y2)
                    {
                        
                        double dtx = p[x2].t - tx;
                        double dty = s.p[y2].t - ty;
                        if (dtx >= dty * 2.2 || dty >= dtx * 2.2 || dtx < Stroke::eps || dty < Stroke::eps)
                            return;
                        k++;
                    
                        double d = 0.0;
                        int i = x, j = y;
                        double next_tx = (p[i+1].t - tx) / dtx;
                        double next_ty = (s.p[j+1].t - ty) / dty;
                        double cur_t = 0.0;
                    
                        for (;;) {
                            double ad = sqr(angle_difference(p[i].alpha, s.p[j].alpha));
                            double next_t = next_tx < next_ty ? next_tx : next_ty;
                            bool done = next_t >= 1.0 - Stroke::eps;
                            if (done)
                                next_t = 1.0;
                            d += (next_t - cur_t)*ad;
                            if (done)
                                break;
                            cur_t = next_t;
                            if (next_tx < next_ty)
                                next_tx = (p[++i+1].t - tx) / dtx;
                            else
                                next_ty = (s.p[++j+1].t - ty) / dty;
                        }
                        
                        double new_dist = dist[x][y] + d * (dtx + dty);
                        if (new_dist != new_dist) abort();
                    
                        if (new_dist >= dist[x2][y2])
                            return;
                    
                        prev_x[x2][y2] = x;
                        prev_y[x2][y2] = y;
                        dist[x2][y2] = new_dist;
                    };
                

                while (k < 4) {
                    if (p[max_x+1].t - tx > s.p[max_y+1].t - ty) {
                        max_y++;
                        if (max_y == s.n-1) {
                            step(n-1, s.n-1);
                            break;
                        }
                        for (int x2 = x+1; x2 <= max_x; x2++)
                            step(x2, max_y);
                    } else {
                        max_x++;
                        if (max_x == n-1) {
                            step(n-1, s.n-1);
                            break;
                        }
                        for (int y2 = y+1; y2 <= max_y; y2++)
                            step(max_x, y2);
                    }
                }
            }
        }

        
        double cost = dist[n-1][s.n-1];
        if (path_x && path_y) {
            if (cost < Stroke::infinity) {
                int x = n-1;
                int y = s.n-1;
                int k = 0;
                while (x || y) {
                    int old_x = x;
                    x = prev_x[x][y];
                    y = prev_y[old_x][y];
                    path_x[k] = x;
                    path_y[k] = y;
                    k++;
                }
            } else {
                path_x[0] = 0;
                path_y[0] = 0;
            }
        }
        
        for (int i=0; i<n; ++i) {
            delete []dist[i];
            delete []prev_x[i];
            delete []prev_y[i];
        }
        delete []dist;
        delete []prev_x;
        delete []prev_y;
        
        return (1.0-cost/infinity)*100;
    }
    
    ostream & operator<<(ostream & os,const Stroke & obj)
    {
        os<<obj.capacity<<" "<<obj.n<<" ";
        for (int i=0; i<obj.n;++i) {
            os<<obj.p[i].x<<" "<<obj.p[i].y<<" ";
        }
        return os;
    }
    
    istream & operator>>(istream & is,Stroke & obj)
    {
        is>>obj.capacity>>obj.n;
        for (int i=0; i<obj.n;++i) {
            is>>obj.p[i].x>>obj.p[i].y;
        }
        obj.finish();
        return is;
    }
    
    Stroke * Stroke::clone()
    {
        Stroke * res=new Stroke(this->capacity);
        for(int i=0;i<n;++i)
        {
            res->addPoint(p[i].x, p[i].y);
        }
        res->finish();
        return res;
    }
}
