

#include "TouchManager.h"
#include <math.h>

TouchManager::TouchManager()
    :lastX(0),lastY(0),lastX1(0),lastY1(0),lastX2(0),lastY2(0),
    lastTouchDist(0),deltaX(0),deltaY(0),scale(1)
{
   
}



void TouchManager::touchesBegan(float x, float y) {
    lastX = x ;
    lastY = y ;
    startX= x;
    startY= y;
    lastTouchDist = -1 ;
    flipAvailable = true ;
    touchSingle = true;
}



void TouchManager::touchesBegan(float x1, float y1, float x2, float y2) {
    float dist=distance( x1,  y1,  x2,  y2);
    float centerX = (x1 + x2) * 0.5f ;
    float centerY = (y1 + y2) * 0.5f ;
	
	lastX1 = x1 ;
    lastY1 = y1 ;
    lastX2 = x2 ;
    lastY2 = y2 ;
	
    lastX = centerX ;
    lastY = centerY ;
    startX= centerX;
    startY= centerY;
    lastTouchDist = dist ;
    flipAvailable = true ;
    touchSingle = false ;
}


void TouchManager::touchesMoved(CGPoint touches[],int num) 
{
    
    
    int index1 , index2 , minDist2 = 999999999 ;
	index1=0;
	index2=1;
    for( int i1 = 0 ; i1 < num ; i1 ++ )
	{
        CGPoint pp1 = touches[i1] ;
        
        for( int i2 = 0 ; i2 < num ; i2++ )
		{
            if( i1 == i2 ) continue ;
            
            CGPoint pp2 = touches[i2] ;
            
            int distTotal = ((lastX1-pp1.x)*(lastX1-pp1.x)+ (lastY1-pp1.y)*(lastY1-pp1.y))
            + ((lastX2-pp2.x)*(lastX2-pp2.x)+ (lastY2-pp2.y)*(lastY2-pp2.y));
            
            if( distTotal < minDist2 )
			{
                minDist2 = distTotal ;
                index1 = i1 ;
                index2 = i2 ;
            }
        }
    }
    
    if( minDist2 > 70*70*2 && num > 2 ) return ;
    
    CGPoint pt1 = touches[index1] ;
    CGPoint pt2 = touches[index2] ;
    
    touchesMoved(pt1.x, pt1.y, pt2.x, pt2.y);
}



void TouchManager::touchesMoved(float deviceX, float deviceY) {
    lastX = deviceX ;
    lastY = deviceY ;
    lastTouchDist = -1 ;
    touchSingle =true;
}



void TouchManager::touchesMoved(float x1, float y1, float x2, float y2) {
    float dist = distance(x1, y1, x2, y2);
    float centerX = (x1 + x2) * 0.5f ;
    float centerY = (y1 + y2) * 0.5f ;
    
    if( lastTouchDist > 0 )
	{
        scale = (float) pow( dist / lastTouchDist , 0.75 ) ;
        deltaX = calcShift( x1 - lastX1 , x2 - lastX2 ) ;
        deltaY = calcShift( y1 - lastY1 , y2 - lastY2 ) ;
    }
    else
    {
        scale =1;
        deltaX=0;
        deltaY=0;
    }
    
    lastX = centerX ;
    lastY = centerY ;
    lastX1 = x1 ;
    lastY1 = y1 ;
    lastX2 = x2 ;
    lastY2 = y2 ;
    lastTouchDist = dist ;
    touchSingle =false;
}



float TouchManager::getFlickDistance(){
    return distance(startX, startY, lastX, lastY);
}



float TouchManager::distance(float x1, float y1, float x2, float y2){
    return (float) sqrt( (x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) ) ;
}



float TouchManager::calcShift( float v1 , float v2 ){
    if( (v1>0) != (v2>0) ) return 0 ;
    
    float fugou = v1 > 0 ? 1 : -1 ;
    float a1 = abs( v1 ) ;
    float a2 = abs( v2 ) ;
    return fugou * ( ( a1 < a2 ) ? a1 : a2 ) ;
}





