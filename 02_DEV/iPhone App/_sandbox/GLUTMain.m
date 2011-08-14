/* Copyright (c) 2007 Scott Lembcke
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
 
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <limits.h>

#include "OpenGL/gl.h"
#include "OpenGL/glu.h"
#include <GLUT/glut.h>

#import "ObjectiveChipmunk.h"
#import "ChipmunkDebugDraw.h"

#import "JellyBlob.h"

#define SLEEP_TICKS 16

ChipmunkSpace *space;
JellyBlob *blob;

ChipmunkMultiGrab *grabSet;
NSMutableArray *shapesToDraw;

static void
drawString(int x, int y, const char *str)
{
	glColor3f(0.0f, 0.0f, 0.0f);
	glRasterPos2i(x, y);
	
	for(int i=0, len=strlen(str); i<len; i++){
		if(str[i] == '\n'){
			y -= 16;
			glRasterPos2i(x, y);
		} else {
			glutBitmapCharacter(GLUT_BITMAP_HELVETICA_10, str[i]);
		}
	}
}

static void
drawInstructions()
{
	drawString(-300, 220,
		"Controls:\n"
		"Mouse to grab.\n"
		"Left/right arrows to roll.\n"
	);
}

static void
drawInfo()
{
//	char buffer[1024];
//	sprintf(buffer, "Shape count: %d", (int)[demo.space.shapes count]);
//	
//	drawString(0, 220, buffer);
}

static void
reshape(int width, int height)
{
	glViewport(0, 0, width, height);
	
	double scale = 0.5/cpfmin(width/640.0, height/480.0);
	double hw = width*scale;
	double hh = height*scale;
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrtho(-hw, hw, -hh, hh, -1.0, 1.0);
	glTranslated(0.5, 0.5, 0.0);
}

static void
display(void)
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		int steps = 2;
		cpFloat dt = 1.0f/60.0f/(cpFloat)steps;
		
		for(int i=0; i<steps; i++)[space step:dt];
	[pool release];
  
//	ChipmunkDebugDrawShapes(space.space);
//	ChipmunkDebugDrawConstraints(space.space);
	
	for(ChipmunkShape *shape in shapesToDraw){
		ChipmunkDebugDrawShape(shape.shape);
	}
	
	[blob draw];
	
	
	
	drawInstructions();
	drawInfo();
		
	glutSwapBuffers();
	glClear(GL_COLOR_BUFFER_BIT);
}

//static void
//keyboard(unsigned char key, int x, int y)
//{
//	if(key == '\r'){
//		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//		[demo release];
//		demo = [[DeformableDemo alloc] init];
//		[pool release];
//  }
//}

static cpVect
mouseToSpace(int x, int y)
{
	GLdouble model[16];
	glGetDoublev(GL_MODELVIEW_MATRIX, model);
	
	GLdouble proj[16];
	glGetDoublev(GL_PROJECTION_MATRIX, proj);
	
	GLint view[4];
	glGetIntegerv(GL_VIEWPORT, view);
	
	GLdouble mx, my, mz;
	gluUnProject(x, glutGet(GLUT_WINDOW_HEIGHT) - y, 0.0f, model, proj, view, &mx, &my, &mz);
	
	return cpv(mx, my);
}

static void
mouse(int x, int y)
{
	cpVect pos = mouseToSpace(x, y);
	[grabSet updateLocation:pos];
}

static void
click(int button, int state, int x, int y)
{
	if(button == GLUT_LEFT_BUTTON){
		cpVect pos = mouseToSpace(x, y);
		if(state == GLUT_DOWN){
			[grabSet beginLocation:pos];
		} else {
			[grabSet endLocation:pos];
		}
	}
}

static void
timercall(int value)
{
	glutTimerFunc(SLEEP_TICKS, timercall, 0);
		
	glutPostRedisplay();
}

static void
arrowKeyDownFunc(int key, int x, int y)
{
	if(key == GLUT_KEY_LEFT) blob.control += 1;
	else if(key == GLUT_KEY_RIGHT) blob.control -= 1;
}

static void
arrowKeyUpFunc(int key, int x, int y)
{
	if(key == GLUT_KEY_LEFT) blob.control -= 1;
	else if(key == GLUT_KEY_RIGHT) blob.control += 1;
}

static void
initGL(void)
{
	glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
	glClear(GL_COLOR_BUFFER_BIT);

	glEnableClientState(GL_VERTEX_ARRAY);
	
	glEnable(GL_LINE_SMOOTH);
	glEnable(GL_POINT_SMOOTH);

	glHint(GL_LINE_SMOOTH_HINT, GL_DONT_CARE);
	glHint(GL_POINT_SMOOTH_HINT, GL_DONT_CARE);
	
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}

static void
glutStuff(int argc, const char *argv[])
{
	glutInit(&argc, (char**)argv);
	
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGBA);
	
	glutInitWindowSize(640, 480);
	glutCreateWindow("Chipmunk Pro: Jelly Physics");
	
	initGL();
	
	glutReshapeFunc(reshape);
	glutDisplayFunc(display);
	glutTimerFunc(SLEEP_TICKS, timercall, 0);
	
	glutIgnoreKeyRepeat(1);
	glutSpecialFunc(arrowKeyDownFunc);
	glutSpecialUpFunc(arrowKeyUpFunc);

//	glutKeyboardFunc(keyboard);
	glutMotionFunc(mouse);
	glutMouseFunc(click);
}

int
main(int argc, const char **argv)
{
	glutStuff(argc, argv);
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		space = [[ChipmunkSpace alloc] init];
		space.gravity = cpv(0, -500);
		
		[space addBounds:CGRectMake(-320, -240, 640, 480) thickness:5 elasticity:1 friction:1 layers:NORMAL_LAYER group:CP_NO_GROUP collisionType:nil];
		
		grabSet = [[ChipmunkMultiGrab alloc] initForSpace:space withSmoothing:cpfpow(0.8, 60) withGrabForce:20000];
		grabSet.layers = GRABABLE_LAYER;
		
		blob = [[JellyBlob alloc] initWithPos:cpvzero radius:96 count:64];
		[space add:blob];
		
		// Add some other crap to play with
		shapesToDraw = [[NSMutableArray alloc] init];
		ChipmunkBody *body;
		ChipmunkShape *shape;
		
		body = [space add:[ChipmunkBody bodyWithMass:1 andMoment:cpMomentForBox(1, 100, 50)]];
		body.pos = cpv(100, 0);
		
		shape = [space add:[ChipmunkPolyShape boxWithBody:body width:100 height:50]];
		shape.friction = 0.7;
		[shapesToDraw addObject:shape];
		
		
		body = [space add:[ChipmunkBody bodyWithMass:1 andMoment:cpMomentForCircle(1, 0, 30, cpvzero)]];
		body.pos = cpv(-100, 0);
		
		shape = [space add:[ChipmunkCircleShape circleWithBody:body radius:30 offset:cpvzero]];
		shape.friction = 0.7;
		[shapesToDraw addObject:shape];
	[pool release];
	
	glutMainLoop();

	return 0;
}
