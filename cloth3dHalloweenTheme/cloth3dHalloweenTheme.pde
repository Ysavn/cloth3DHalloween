float dt;
int sz = 2;
int a = 100;
float k = 42;
float kv = 0.31;
int restLen = 100;
float mass = 0.6;
float boxL = 50;
Vec3 [][][] pos = new Vec3[sz][sz][sz];
Vec3 vel[][][] = new Vec3[sz][sz][sz];
Vec3 acc[][][] = new Vec3[sz][sz][sz];
Vec3 cols[] = new Vec3[8];
float COR2 = 0.25;
Vec3 gravity = new Vec3(0, 1200, 0);
PImage img1;
float rotx = PI/4;
float roty = PI/4;

//Obstacle position & velocity
float sphereR = 25;
float COR = 0.99;
float diffDist;
Vec3 obsVel;
Vec3 obsPos;

void updateAcc(int si, int sj, int sk, int ei, int ej, int ek, float restLen)
{
  Vec3 diff = pos[ei][ej][ek].minus(pos[si][sj][sk]);
  float stringF = -k*(diff.length() - restLen);
  
  Vec3 stringDir = diff.normalized();
  float projVbot = dot(vel[si][sj][sk], stringDir);
  float projVtop = dot(vel[ei][ej][ek], stringDir);
  float dampF = -kv*(projVtop - projVbot);
  
  Vec3 force = stringDir.times(stringF+dampF);
  
  acc[si][sj][sk].add(force.times(-1.0/mass));
  acc[ei][ej][ek].add(force.times(1.0/mass));
}

boolean withinDist(){
  
  Vec3 v1 = pos[0][0][1].minus(pos[0][0][0]);
  Vec3 v2 = pos[1][0][0].minus(pos[0][0][0]);
  Vec3 N = cross(v1, v2).normalized();
  Vec3 d1, d2, d3, d4;
  d1 = obsPos.minus(pos[0][0][0]);
  d2 = obsPos.minus(pos[1][0][0]);
  d3 = obsPos.minus(pos[0][0][1]);
  d4 = obsPos.minus(pos[1][0][1]);
  float dist1, dist2, dist3, dist4;
  dist1 = projAB(d1, N).length();
  dist2 = projAB(d2, N).length();
  dist3 = projAB(d3, N).length();
  dist4 = projAB(d4, N).length();
  diffDist = max(max(sphereR -dist1, sphereR - dist2), max(sphereR - dist3, sphereR - dist4));
  if(diffDist > 0){
    int sign = (random(1) > 0.5 ? 1 : -1);
    sphereAngDeltaY = random(0, PI/4);
    sphereAngDeltaY = sphereAngDeltaY * sign;
    return true;
  }
  return false;
  
}

float maxY = 0;

void update(float dt){
  
  for(int i=0;i<sz;i++)
  {
    for(int j=0;j<sz;j++)
    {
      for(int k=0;k<sz;k++)
      {
        acc[i][j][k] =  new Vec3(0, 0, 0);
      }
    }
  }
  
  for(int i=0;i<sz;i++)
  {
    for(int j=0;j<sz;j++)
    {
      for(int k=0;k<sz;k++)
      {
        if(i!=(sz-1)){
          updateAcc(i, j, k, i+1, j, k, restLen);
        }
        if(j!=(sz-1)){
          updateAcc(i, j, k, i, j+1, k, restLen);
        }
        if(k!=(sz-1)){
          updateAcc(i, j, k, i, j, k+1, restLen);
        }
      }
    }
  }
  
  float diagRestLen = sqrt(2) * restLen;
  for(int i=0;i<sz;i++)
  {
    for(int j=0;j<sz;j++)
    {
      updateAcc(i, 0, j, i, 1, j^1, diagRestLen);
      updateAcc(0, i, j, 1, i, j^1, diagRestLen);
      updateAcc(0, j, i, 1, j^1, i, diagRestLen);
    }
  }
  
  //collision 
  if(withinDist()){
    Vec3 v1 = pos[0][0][1].minus(pos[0][0][0]);
    Vec3 v2 = pos[1][0][0].minus(pos[0][0][0]);
    Vec3 N = cross(v1, v2).normalized(); //normal
    obsPos.subtract(N.times((diffDist + 0.01)));
    Vec3 velProj = projAB(obsVel, N);
    obsVel.subtract(velProj.times(1 + COR));
    
    float fact = (random(0.5) + 0.6) * COR2;
    for(int i=0;i<sz;i++){
      for(int k=0;k<sz;k++){
        vel[i][0][k].add(velProj.times(fact));
        //vel[i][1][k].add(velProj.times(COR2/2));
      }
    }
  }
  
  //mid-point integration
  
  obsVel.add(gravity.times(dt/2));
  obsPos.add(obsVel.times(dt));
  obsVel.add(gravity.times(dt/2));
  
  sphereAngY += sphereAngDeltaY * dt;
  
  for(int i=0;i<sz;i++)
  {
    for(int j=0;j<sz;j++)
    {
      for(int k=0;k<sz;k++)
      {
        float tmp = pos[i][j][k].y;
        vel[i][j][k].add(acc[i][j][k].times(dt/2));
        pos[i][j][k].add(vel[i][j][k].times(dt));
        vel[i][j][k].add(acc[i][j][k].times(dt/2));
        if(j==(sz-1)){
          pos[i][j][k].y = min(pos[i][j][k].y, tmp);
        }
        if(i==0 && j==0 && k==0) {
          maxY = max(maxY, pos[i][j][k].y);
        }
      }
    }
  }
  
}

void mouseDragged() {
  float rate = 0.01;
  roty += (mouseX-pmouseX) * rate;
}

void setup() {
  
  size(640,500,P3D);
  camera = new Camera();
  img1 = loadImage("neon_slime.png");
  img2 = loadImage("pumpkin.png");
  fill(255);
  stroke(color(44,48,32));
  obsPos = new Vec3(width/2, 100, a/2);
  obsVel = new Vec3(0, 0, 0);
  ptsW=20;
  ptsH=20;
  sphereAngY = PI;
  sphereAngDeltaY = 0;
  roty = 0;
  dt = 0.01;
  initializeSphere(ptsW, ptsH);
  
  for(int i=0;i<sz;i++)
  {
    for(int j=0;j<sz;j++)
    {
      for(int k=0;k<sz;k++)
      {
        pos[i][j][k] = new Vec3(i*a, j*a, k*a);
        pos[i][j][k].add(new Vec3(-a/2, -a/2, -a/2));
        pos[i][j][k].add(new Vec3(width/2.0, height - 150, a/2)); 
        vel[i][j][k] = new Vec3(0, 0, 0);
      }
    }
  }
  
}

void draw() {
  update(dt);
  for(int i=0;i<2;i++)
    camera.Update(1.0/frameRate);
  background(0);
  noStroke();
  fill(0, 120, 50);
  
  pushMatrix();
  translate(width/2.0, height - 150, a/2);
  rotateY(roty);
  TexturedCube(img1);
  popMatrix();
  
  pushMatrix();
  noStroke();
  fill(200, 0, 0);
  //translate(width/2.0, 0, a/2);
  translate(obsPos.x, obsPos.y, obsPos.z);
  //sphere(sphereR);
  rotateY(sphereAngY);
  //rotateY(roty);
  textureSphere(sphereR, sphereR, sphereR, img2);
  popMatrix();
  
}
