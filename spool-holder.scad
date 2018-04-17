use <lib/bearing.scad>;

spoolDiameter=57.5;

materialThickness=2;
spoolInset=3;
spoolOverlap=8;

useBearing = true; // false if only a rod is used
minimizeFrictionBetweenSpools = false;

// Rod only (without bearing)
rodDiameter = 8.1;

// Bearing
bearingOuterDiameter=22;
bearingWidth=7.05;
bearingHolderWidth = materialThickness;
bearingRollerClearanceDiameter=7;
bearingRollerDiameter = 12.1 + bearingRollerClearanceDiameter; // 12.1mm

filamenRollClearance = minimizeFrictionBetweenSpools ? 0.75 : 0; // Clearance allows the bearing to stick out a bit, multiple rows on the same rod will therefore only touch at their bearings, and therefore may roll independently

spoolRadius=spoolDiameter/2;
bearingOuterRadius=bearingOuterDiameter/2;

$fn=$preview ? 64 : 128;

// Using a zFight fix for previews
zFightFix=$preview ? 0.005 : 0;
zFightFix2x=zFightFix * 2;

module bearingHolderCutout() {
  bearingRadius = bearingRollerDiameter/2;
  height = 30;
  translate([0,0,-zFightFix]) cylinder(r1=bearingRadius, r2=bearingRadius, height);
}

module innerSpoolHolder() {
  segmentDividerCount=8;
  rimThickness = materialThickness*2;
  negativeSplineThickness = materialThickness*6;
  segmentAngle = 360 / segmentDividerCount;

  difference() {
    cylinder(r1=spoolRadius, r2=spoolRadius, h=spoolInset, $fn=8);
    translate([0, 0, zFightFix]) cylinder(r1=spoolRadius-rimThickness*1.5, r2=spoolRadius-materialThickness, h=spoolInset+(zFightFix2x), $fn=8);

    // Weight & Print time saver
    translate([0,0,zFightFix]) rotate([0, 0, segmentAngle/2]) {
      for(i=[0:1:segmentDividerCount-1]) {
        rotate([0, 0, i*segmentAngle]) translate([0, -negativeSplineThickness/2])
          cube([50, negativeSplineThickness, spoolInset+zFightFix]);
      }
    }
  }
}

module axleCutout() {
  if(useBearing) {
    translate([0, 0, -filamenRollClearance]) bearingCutout();
  } else {
    translate([0, 0, -filamenRollClearance]) rodCutout();
  }
}

module axleMount() {
  if (useBearing) {
    bearingSupport();
  } else {
    rodMountSupport();
  }
}

module bearingSupport() {
  bearingSupportHeight = bearingWidth + materialThickness;
  a = bearingSupportHeight - (materialThickness + spoolInset);
  difference() {
    union() {
      translate([0, 0, spoolInset-filamenRollClearance]) cylinder(r1=bearingOuterRadius+3, r2=bearingOuterRadius, h=a);
      cylinder(r1=bearingOuterRadius+3, r2=bearingOuterRadius+3, h=spoolInset-filamenRollClearance);
    }
    // Cutout that allows the bearing to be held in place but allows the bearing to move
    bearingHolderCutout();
  }
}

module rodMountSupport() {
  outerDiameter = rodDiameter + materialThickness;
  innerDiameter = rodDiameter;

  difference() {
    cylinder(r1 = outerDiameter / 3 * 2, r2 = outerDiameter / 2, h = spoolInset);
    zFight() cylinder(r = innerDiameter / 2, h = spoolInset);
  }
}

module bearingCutout() {
  cylinder(r=bearingOuterDiameter/2, h=bearingWidth);
}

module rodCutout() {
  cylinder(r=rodDiameter/2, h=bearingWidth);
}

module spoolHolderDisk() {
  bearingHolderWidth = (bearingWidth-filamenRollClearance+materialThickness) - (materialThickness+spoolInset);
  union(){
    cylinder(r1=spoolRadius+spoolOverlap, r2=spoolRadius+spoolOverlap, h=materialThickness, $fn=8);
    translate([0, 0, materialThickness]) innerSpoolHolder();
  }
}

module weightSavingCutouts() {
  cutouts = 8;
  angle = 360 / cutouts;
  radius = 8;
  distanceToCenter = spoolDiameter / 2 + radius;
  for(i=[0:1:cutouts]) {
    rotate([0, 0, angle*i]) translate([distanceToCenter, 0, -1]) cylinder(r=radius, h=7, $fn=8);
  }
}

module spoolHolder() {
  difference() {
    union() {
      difference() {
        spoolHolderDisk();
        weightSavingCutouts();
      }
      translate([0, 0, materialThickness]) axleMount(bearingHolderWidth);
    }
    zFight() axleCutout();
  }
}

// Preview ONLY

module assembledHolderPreview() {
  spoolHolder();
  if (useBearing) {
    color("silver") translate([0, 0, -filamenRollClearance]) bearing();
  }
}

module preview() {
  assembledHolderPreview();

  translate([0, 0, 50]) mirror([0, 0, 1]) assembledHolderPreview();
}
preview();
