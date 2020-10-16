void TexturedCube(PImage tex) {
  beginShape(QUADS);
  textureMode(NORMAL);
  texture(tex);
  
  float xc, yc, zc;
  xc = width/2.0;
  yc = height - 150;
  zc = a/2.0;
  
  // +Z "front" face
  vertex(pos[0][0][1].x - xc, pos[0][0][1].y - yc,  pos[0][0][1].z - zc, 0, 0);
  vertex(pos[1][0][1].x - xc, pos[1][0][1].y - yc,  pos[1][0][1].z - zc, 1, 0);
  vertex(pos[1][1][1].x - xc, pos[1][1][1].y - yc,  pos[1][1][1].z - zc, 1, 1);
  vertex(pos[0][1][1].x - xc, pos[0][1][1].y - yc,  pos[0][1][1].z - zc, 0, 1);

  // -Z "back" face
  vertex(pos[1][0][0].x - xc, pos[1][0][0].y - yc, pos[1][0][0].z - zc, 0, 0);
  vertex(pos[0][0][0].x - xc, pos[0][0][0].y - yc, pos[0][0][0].z - zc, 1, 0);
  vertex(pos[0][1][0].x - xc, pos[0][1][0].y - yc, pos[0][1][0].z - zc, 1, 1);
  vertex(pos[1][1][0].x - xc, pos[1][1][0].y - yc, pos[1][1][0].z - zc, 0, 1);

  // +Y "bottom" face
  vertex(pos[0][1][1].x - xc, pos[0][1][1].y - yc, pos[0][1][1].z - zc, 0, 0);
  vertex(pos[1][1][1].x - xc, pos[1][1][1].y - yc, pos[1][1][1].z - zc, 1, 0);
  vertex(pos[1][1][0].x - xc, pos[1][1][0].y - yc, pos[1][1][0].z - zc, 1, 1);
  vertex(pos[0][1][0].x - xc, pos[0][1][0].y - yc, pos[0][1][0].z - zc, 0, 1);

  // -Y "top" face
  vertex(pos[0][0][0].x - xc, pos[0][0][0].y - yc, pos[0][0][0].z - zc, 0, 0);
  vertex(pos[1][0][0].x - xc, pos[1][0][0].y - yc, pos[1][0][0].z - zc, 1, 0);
  vertex(pos[1][0][1].x - xc, pos[1][0][1].y - yc, pos[1][0][1].z - zc, 1, 1);
  vertex(pos[0][0][1].x - xc, pos[0][0][1].y - yc, pos[0][0][1].z - zc, 0, 1);

  // +X "right" face
  vertex(pos[1][0][1].x - xc, pos[1][0][1].y - yc, pos[1][0][1].z - zc, 0, 0);
  vertex(pos[1][0][0].x - xc, pos[1][0][0].y - yc, pos[1][0][0].z - zc, 1, 0);
  vertex(pos[1][1][0].x - xc, pos[1][1][0].y - yc, pos[1][1][0].z - zc, 1, 1);
  vertex(pos[1][1][1].x - xc, pos[1][1][1].y - yc, pos[1][1][1].z - zc, 0, 1);

  // -X "left" face
  vertex(pos[0][0][0].x - xc, pos[0][0][0].y - yc, pos[0][0][0].z - zc, 0, 0);
  vertex(pos[0][0][1].x - xc, pos[0][0][1].y - yc, pos[0][0][1].z - zc, 1, 0);
  vertex(pos[0][1][1].x - xc, pos[0][1][1].y - yc, pos[0][1][1].z - zc, 1, 1);
  vertex(pos[0][1][0].x - xc, pos[0][1][0].y - yc, pos[0][1][0].z - zc, 0, 1);

  endShape();
}
