/*
* Copyright (c) 2006-2007 Erin Catto http://www.gphysics.com
*
* This software is provided 'as-is', without any express or implied
* warranty.  In no event will the authors be held liable for any damages
* arising from the use of this software.
* Permission is granted to anyone to use this software for any purpose,
* including commercial applications, and to alter it and redistribute it
* freely, subject to the following restrictions:
* 1. The origin of this software must not be misrepresented; you must not
* claim that you wrote the original software. If you use this software
* in a product, an acknowledgment in the product documentation would be
* appreciated but is not required.
* 2. Altered source versions must be plainly marked as such, and must not be
* misrepresented as being the original software.
* 3. This notice may not be removed or altered from any source distribution.
*/

#ifndef SPRINGS_H
#define SPRINGS_H

class Springs : public Test
{
public:
	b2Body* bodies[64];

	Springs()
	{
		{
			b2PolygonDef sd;
			sd.SetAsBox(50.0f, 10.0f);

			b2BodyDef bd;
			bd.type = b2BodyDef::e_staticBody;
			bd.position.Set(0.0f, -10.0f);
			b2Body* ground = m_world->Create(&bd);
			ground->Create(&sd);
		}

		{
			b2PolygonDef sd;
			sd.SetAsBox(3.0f,1.0f);
			sd.density = 5.0f;
			sd.friction = 0.3f;
			b2BodyDef bd;
			bd.type = b2BodyDef::e_dynamicBody;
			bd.isBullet = false;//true;
			
			bd.position.Set(-4.0f,50.0f);
			b2Body* body = m_world->Create(&bd);
			body->Create(&sd);
			body->SetMassFromShapes();
			body->SetAngularVelocity(5.0f);
			body->SetLinearVelocity(b2Vec2(4.0f,-10.0f));

			bd.position.Set(-30.0f,3.0f);
			body = m_world->Create(&bd);
			body->Create(&sd);
			body->SetMassFromShapes();
			body->SetLinearVelocity(b2Vec2(30.0f,5.0f));
			body->SetAngularVelocity(1.0f);

			bd.position.Set(30.0f,1.0f);
			body = m_world->Create(&bd);
			body->Create(&sd);
			body->SetMassFromShapes();
			body->SetAngularVelocity(-5.0f);
			body->SetLinearVelocity(b2Vec2(-30.0f,10.0f));		}

		{
			b2PolygonDef sd;
			sd.SetAsBox(0.55f, 0.55f);
			sd.density = 1.0f;
			sd.friction = 0.3f;
			sd.groupIndex = -1;

			for (int i = 0; i < 8; ++i)
			{
				for (int j = 0; j < 8; ++j){

					b2BodyDef bd;
					bd.type = b2BodyDef::e_dynamicBody;
	
					bd.isBullet = false;
					bd.allowSleep = false;
	
					bd.position.Set(j*1.02f, 2.51f + 1.02f * i);
					b2Body* body = m_world->Create(&bd);
					bodies[8*i+j] = body;
					body->Create(&sd);
					body->SetMassFromShapes();
				}
			}

		}
	}

	void Step(Settings* settings){
		Test::Step(settings);
		for (int i=0; i<8; ++i){
			for (int j=0; j<8; ++j){
				b2Vec2 zero(0.0f,0.0f);
				b2Vec2 down(0.0f, -0.5f);
				b2Vec2 up(0.0f, 0.5f);
				b2Vec2 right(0.5f, 0.0f);
				b2Vec2 left(-0.5f, 0.0f);
				int ind = i*8+j;
				int indr = ind+1;
				int indd = ind+8;
				float32 spring = 500.0f;
				float32 damp = 5.0f;
				if (j<7) {
					AddSpringForce(*(bodies[ind]),zero,*(bodies[indr]),zero,spring, damp, 1.0f);
					AddSpringForce(*(bodies[ind]),right,*(bodies[indr]),left,0.5f*spring, damp, 0.0f);
				}
				if (i<7) {
					AddSpringForce(*(bodies[ind]),zero,*(bodies[indd]),zero,spring, damp, 1.0f);
					AddSpringForce(*(bodies[ind]),up,*(bodies[indd]),down,0.5f*spring,damp,0.0f);
				}
				int inddr = indd + 1;
				int inddl = indd - 1;
				float32 drdist = sqrtf(2.0f);
				if (i < 7 && j < 7){
					AddSpringForce(*(bodies[ind]),zero,*(bodies[inddr]),zero,spring, damp, drdist);
				}
				if (i < 7 && j > 0){
					AddSpringForce(*(bodies[ind]),zero,*(bodies[inddl]),zero,spring, damp, drdist);
				}

				indr = ind+2;
				indd = ind+8*2;
				if (j<6) {
					AddSpringForce(*(bodies[ind]),zero,*(bodies[indr]),zero,spring, damp, 2.0f);
				}
				if (i<6) {
					AddSpringForce(*(bodies[ind]),zero,*(bodies[indd]),zero,spring,damp,2.0f);
				}

				inddr = indd + 2;
				inddl = indd - 2;
				drdist = sqrtf(2.0f)*2.0f;
				if (i < 6 && j < 6){
					AddSpringForce(*(bodies[ind]),zero,*(bodies[inddr]),zero,spring, damp, drdist);
				}
				if (i < 6 && j > 1){
					AddSpringForce(*(bodies[ind]),zero,*(bodies[inddl]),zero,spring, damp, drdist);
				}
			}
		}
	}
	
	void AddSpringForce(b2Body& bA, b2Vec2& localA, b2Body& bB, b2Vec2& localB, float32 k, float32 friction, float32 desiredDist) {
        b2Vec2 pA = bA.GetWorldPoint(localA);
        b2Vec2 pB = bB.GetWorldPoint(localB);
        b2Vec2 diff = pB - pA;
        //Find velocities of attach points
        b2Vec2 vA = bA.m_linearVelocity - b2Cross(bA.GetWorldVector(localA), bA.m_angularVelocity);
        b2Vec2 vB = bB.m_linearVelocity - b2Cross(bB.GetWorldVector(localB), bB.m_angularVelocity);
        b2Vec2 vdiff = vB-vA;
        float32 dx = diff.Normalize(); //normalizes diff and puts length into dx
        float32 vrel = vdiff.x*diff.x + vdiff.y*diff.y;
        float32 forceMag = -k*(dx-desiredDist) - friction*vrel;
        diff *= forceMag; // diff *= forceMag
        bB.ApplyForce(diff, bA.GetWorldPoint(localA));
		diff *= -1.0f;
        bA.ApplyForce(diff, bB.GetWorldPoint(localB));
        bA.WakeUp();
        bB.WakeUp();
    }

	static Test* Create()
	{
		return new Springs;
	}
};

#endif
