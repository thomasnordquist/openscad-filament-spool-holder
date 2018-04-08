spoolDiameter=50;
bearingOuterDiameter=22;
bearingWidth=7; 
rodThickness=8.5; // 8mm + lot of clearance
filamenRollClearance=0.75; // Clearance allows the bearing to stick out a bit, multiple rows on the same rod will therefore only touch at their bearings, and therefore may roll independently

spoolRadius=spoolDiameter/2;
bearingOuterRadius=bearingOuterDiameter/2;


materialThickness=2;
spoolInset=3;
spoolOverlap=8;

zFightFix=0.01;
$fn=128;

module bearing() {
  translate([0,0,-0.5*zFightFix]) cylinder(r1=bearingOuterRadius, r2=bearingOuterRadius, h=bearingWidth-filamenRollClearance+zFightFix);
}

module rod() {
    rodRadius = rodThickness/2;
    height=30;
    translate([0,0,-zFightFix]) cylinder(r1=rodRadius, r2=rodRadius, height);
}

module spoolHolderDisk() {
  bearingHolderWidth = (bearingWidth-filamenRollClearance+materialThickness) - (materialThickness+spoolInset);
  union(){
      cylinder(r1=spoolRadius+spoolOverlap, r2=spoolRadius+spoolOverlap, h=materialThickness, $fn=8);
      translate([0, 0, materialThickness]) cylinder(r1=spoolRadius, r2=spoolRadius, h=spoolInset, $fn=8);
      
      
      translate([0, 0, materialThickness+spoolInset]) cylinder(r1=bearingOuterRadius+3, r2=bearingOuterRadius, h=bearingHolderWidth);
  }
}

module weightSavingCutouts() {
    cutouts = 8;
    angle = 360 / cutouts;
    for(i=[0:1:cutouts]) {
        rotate([0, 0, angle*i]) translate([33, 0, -1]) cylinder(r1=8, r2=8,h=40, $fn=8);
    }
}

difference() {
  spoolHolderDisk();
  bearing();
  weightSavingCutouts();
  rod();
}
