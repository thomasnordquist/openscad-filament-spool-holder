outerRingOuterDiameter = 22;
outerRingInnerDiameter = 19.2;

innerRingOuterDiameter = 12.1;
innerRingInnerDiameter = 8;

bearingBallCount = 10;
bearingBallGrooveDepth = 0.1;
bearingBallDiameter = 4.5;

bearingWidth = 7;

module zFight(factor = 1) {
  // Using a zFight fix for previews
  zFightFix=0.005;
  zFightFix2x=zFightFix * 2;
  translate([0, 0, -0.5 * factor * zFightFix]) scale([1,1,1+(zFightFix * factor)]) children();
}


module outerRing() {
  difference() {
    cylinder(r=outerRingOuterDiameter/2, h=bearingWidth);
    zFight() cylinder(r=outerRingInnerDiameter/2, h=bearingWidth);
  }
}

module innerRing() {
  difference() {
    cylinder(r=innerRingOuterDiameter/2, h=bearingWidth);
    zFight() cylinder(r=innerRingInnerDiameter/2, h=bearingWidth);
  }
}

module bearingBalls() {
  $fn = $fn / 4;

  angle = 360 / bearingBallCount;
  distanceToCenter = (innerRingOuterDiameter+outerRingInnerDiameter)/2/2;

  for(i=[0:1:bearingBallCount]) {
    rotate([0, 0, i*angle]) translate([-bearingBallDiameter/2, distanceToCenter, bearingWidth/2]) sphere(r=bearingBallDiameter/2, center=true);
  }
}

module bearing() {
  union() {
    outerRing();
    innerRing();
    bearingBalls();
  }
}

bearing();
