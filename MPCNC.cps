/*

https://github.com/guffy1234/mpcnc_posts_processor

MPCNC posts processor for milling and laser/plasma cutting.

*/

//--------------------- Refactored Firmware ----------------------

description = "MPCNC Milling/Laser - Marlin 2.0, Grbl 1.1, RepRap";

var eFirmware = {
    MARLIN: 0,
    GRBL: 1,
    REPRAP: 2,
    prop: {
      0: {name: "Marlin 2.x", value: 0},
      1: {name: "Grbl 1.1", value: 1},
      2: {name: "RepRap", value: 2}
    }
  };

var firmware =  eFirmware.MARLIN; 

var eComment = {
    Off: 0,
    Important: 1,
    Info: 2,
    Debug: 3,
    prop: {
      0: {name: "Off", value: 0},
      1: {name: "Important", value: 1},
      2: {name: "Info", value: 2},
      3: {name: "Debug", value: 3}
    }
};

machineMode = undefined; //TYPE_MILLING, TYPE_JET

/*
mergeProperties(properties, properties3dPrinter);
mergeProperties(propertyDefinitions, propertyDefinitions3dPrinter);
*/

function flushMotions() {
  let fw = properties.jobSelectedFirmware;

  if (fw == eFirmware.GRBL) {
  }

  // Default
  else {
    writeBlock(mFormat.format(400));
  }
}

// Coolant
function CoolantA(on) {
  writeBlock(on ? properties.cl2_coolantAOn : properties.cl3_coolantAOff);
}

function CoolantB(on) {
  writeBlock(on ? properties.cl4_coolantBOn : properties.cl5_coolantBOff);
}


//--------------------- Common ----------------------

/*

https://github.com/flyfisher604/mpcnc_post_processor

MPCNC posts processor for milling and laser/plasma cutting.
  
*/

// Internal properties
certificationLevel = 2;
extension = "gcode";
setCodePage("ascii");
capabilities = CAPABILITY_MILLING | CAPABILITY_JET;

// vendor of MPCNC
vendor = "flyfisher604";
vendorUrl = "https://github.com/flyfisher604/mpcnc_post_processor";


// user-defined properties
properties = {
  jobSelectedFirmware : firmware,      // Firmware to use in special cases

  jobManualSpindlePowerControl: true,  // Spindle motor is controlled by manual switch 

  jobUseArcs: true,                    // Produce G2/G3 for arcs

  jobSetOriginOnStart: true,           // Set origin when gcode start (G92)
  jobGoOriginOnFinish: true,           // Go X0 Y0 Z0 at gcode end

  jobSequenceNumbers: false,           // show sequence numbers
  jobSequenceNumberStart: 10,          // first sequence number
  jobSequenceNumberIncrement: 1,       // increment for sequence numbers
  jobSeparateWordsWithSpace: true,     // specifies that the words should be separated with a white space 
  jobCommentLevel: eComment.Info,      // The level of comments included 

  fr0_TravelSpeedXY: 2500,             // High speed for travel movements X & Y (mm/min)
  fr1_TravelSpeedZ: 300,               // High speed for travel movements Z (mm/min)
  fr2_EnforceFeedrate: false,          // Add feedrate to each movement line
  frA_ScaleFeedrate: false,            // Will feedrated be scaled
  frB_MaxCutSpeedXY: 900,              // Max speed for cut movements X & Y (mm/min)
  frC_MaxCutSpeedZ: 180,               // Max speed for cut movements Z (mm/min)
  frD_MaxCutSpeedXYZ: 1000,            // Max feedrate after scaling

  mapD_RestoreFirstRapids: false,      // Map first G01 --> G00 
  mapE_RestoreRapids: false,           // Map G01 --> G00 for SafeTravelsAboveZ 
  mapF_SafeZ: 10,                      // G01 mapped to G00 if Z is >= jobSafeZRapid
  mapG_AllowRapidZ: true,              // Allow G01 --> G00 for vertical retracts and Z descents above safe

  toolChangeEnabled: true,          // Enable tool change code (bultin tool change requires LCD display)
  toolChangeX: 0,                   // X position for builtin tool change
  toolChangeY: 0,                   // Y position for builtin tool change
  toolChangeZ: 40,                  // Z position for builtin tool change
  toolChangeZProbe: true,           // Z probe after tool change
  toolChangeDisableZStepper: false, // disable Z stepper when change a tool

  probeOnStart: true,               // Execute probe gcode to align tool
  probeThickness: 0.8,              // plate thickness
  probeUseHomeZ: true,              // use G28 or G38 for probing 
  probeG38Target: -10,              // probing up to pos 
  probeG38Speed: 30,                // probing with speed 

  gcodeStartFile: "",               // File with custom Gcode for header/start (in nc folder)
  gcodeStopFile: "",                // File with custom Gcode for footer/end (in nc folder)
  gcodeToolFile: "",                // File with custom Gcode for tool change (in nc folder)
  gcodeProbeFile: "",               // File with custom Gcode for tool probe (in nc folder)

  cutterOnVaporize: 100,            // Persent of power to turn on the laser/plasma cutter in vaporize mode
  cutterOnThrough: 80,              // Persent of power to turn on the laser/plasma cutter in through mode
  cutterOnEtch: 40,                 // Persent of power to turn on the laser/plasma cutter in etch mode
  cutterMarlinMode: 106,            // Marlin mode laser/plasma cutter
  cutterMarlinPin: 4,               // Marlin laser/plasma cutter pin for M42

  cl0_coolantA_Mode: 0,             // Enable issuing g-codes for control Coolant channel A 
  cl1_coolantB_Mode: 0,             // Use issuing g-codes for control Coolant channel B 
  cl2_coolantAOn: "M42 P6 S255",    // GCode command to turn on Coolant channel A
  cl3_coolantAOff: "M42 P6 S0",     // Gcode command to turn off Coolant channel A
  cl4_coolantBOn: "M42 P11 S255",   // GCode command to turn on Coolant channel B
  cl5_coolantBOff: "M42 P11 S0",    // Gcode command to turn off Coolant channel B 

  DuetMillingMode: "M453 P2 I0 R30000 F200", // GCode command to setup Duet3d milling mode
  DuetLaserMode: "M452 P2 I0 R255 F200",     // GCode command to setup Duet3d laser mode
  
  GrblCutterMode: 4,                // GRBL mode laser/plasma cutter
};

propertyDefinitions = {

  jobSelectedFirmware: {
    title: "Job: Select CNC Firmware", description: "Control GCode create for specific firmware", group: 1,
    type: "integer", default_mm: 0, default_in: 0,
    values: [
      { title: eFirmware.prop[eFirmware.MARLIN].name, id: eFirmware.MARLIN },
      { title: eFirmware.prop[eFirmware.GRBL].name, id: eFirmware.GRBL },
      { title: eFirmware.prop[eFirmware.REPRAP].name, id: eFirmware.REPRAP },
    ]
  },

  jobManualSpindlePowerControl: {
    title: "Job: Manual Spindle On/Off", description: "Set Yes when your spindle motor is controlled by manual switch", group: 1,
    type: "boolean", default_mm: true, default_in: true
  },
  jobUseArcs: {
    title: "Job: Use Arcs", description: "Use G2/G3 g-codes fo circular movements", group: 1,
    type: "boolean", default_mm: true, default_in: true
  },

  jobMarlinEnforcFeFeedrate: {
    title: "Job: Marlin Enforce Feedrate", description: "Add feedrate to each movement g-code", group: 1,
    type: "boolean", default_mm: false, default_in: false
  },

  jobSetOriginOnStart: {
    title: "Job: Reset on start (G92)", description: "Set origin when gcode start (G92)", group: 1,
    type: "boolean", default_mm: true, default_in: true
  },
  jobGoOriginOnFinish: {
    title: "Job: Goto 0, 0 at end", description: "Go X0 Y0 at gcode end", group: 1,
    type: "boolean", default_mm: true, default_in: true
  },

  jobSequenceNumbers: {
    title: "Job: Line numbers", description: "Show sequence numbers", group: 1,
    type: "boolean", default_mm: false, default_in: false
  },
  jobSequenceNumberStart: {
    title: "Job: Line # start", description: "First sequence number", group: 1,
    type: "integer", default_mm: 10, default_in: 10
  },
  jobSequenceNumberIncrement: {
    title: "Job: Line # increment", description: "Increment for sequence numbers", group: 1,
    type: "integer", default_mm: 1, default_in: 1
  },
  jobSeparateWordsWithSpace: {
    title: "Job: Separate words", description: "Specifies that the words should be separated with a white space", group: 1,
    type: "boolean", default_mm: true, default_in: true
  },
  jobCommentLevel: {
    title: "Job: Comment Level", description: "Controls the comments include", group: 1,
    type: "integer", default_mm: 3, default_in: 3,
    values: [
      { title: eComment.prop[eComment.Off].name, id: eComment.Off },
      { title: eComment.prop[eComment.Important].name, id: eComment.Important },
      { title: eComment.prop[eComment.Info].name, id: eComment.Info },
      { title: eComment.prop[eComment.Debug].name, id: eComment.Debug },
    ]
  },
  
  fr0_TravelSpeedXY: {
    title: "Feed: Travel speed X/Y", description: "High speed for Rapid movements X & Y (mm/min; in/min)", group: 2,
    type: "spatial", default_mm: 2500, default_in: 100
  },
  fr1_TravelSpeedZ: {
    title: "Feed: Travel Speed Z", description: "High speed for Rapid movements z (mm/min; in/min)", group: 2,
    type: "spatial", default_mm: 300, default_in: 12
  },
  fr2_EnforceFeedrate: {
    title: "Feed: Enforce Feedrate", description: "Add feedrate to each movement g-code", group: 2,
    type: "boolean", default_mm: false, default_in: false
  },
  frA_ScaleFeedrate: {
    title: "Feed: Scale feedrate", description: "Scale feedrate based on X, Y, Z axis maximums", group: 2,
    type: "boolean", default_mm: false, default_in: false
  },
  frB_MaxCutSpeedXY: {
    title: "Feed: Max cut speed X or Y", description: "Max X or Y axis cut speed (mm/min; in/min)", group: 2,
    type: "spatial", default_mm: 900, default_in: 35.43
  },
  frC_MaxCutSpeedZ: {
    title: "Feed: Max cut speed Z", description: "Max Z axis cut speed (mm/min; in/min)", group: 2,
    type: "spatial", default_mm: 180, default_in: 7.08
  },
  frD_MaxCutSpeedXYZ: {
    title: "Feed: Max toolpath speed", description: "After scaling limit feedrate to this (mm/min; in/min)", group: 2,
    type: "spatial", default_mm: 1000, default_in: 39.37
  },


  mapD_RestoreFirstRapids: {
    title: "Map: First G1 -> G0 Rapids", description: "Convert first G1 of a cut to G0 Rapids", group: 3,
    type: "boolean", default_mm: false, default_in: false
  },
  mapE_RestoreRapids: {
    title: "Map: G1 -> G0 Rapids", description: "When safe, convert G1s to G0 Rapids", group: 3,
    type: "boolean", default_mm: false, default_in: false
  },
  mapF_SafeZ: {
    title: "Map: Safe Z for Rapids", description: "Z must be above or equal to this to map G01 --> G00", group: 3,
    type: "integer", default_mm: 10, default_in: 0.590551
  },
  mapG_AllowRapidZ: {
    title: "Map: Allow Rapid Z", description: "If G01 to Rapids allowed, then include vertical retracts and safe descents", group: 3,
    type: "boolean", default_mm: true, default_in: true
  },


  toolChangeEnabled: {
    title: "Change: Enabled", description: "Enable tool change code (bultin tool change requires LCD display)", group: 4,
    type: "boolean", default_mm: true, default_in: true
  },
  toolChangeX: {
    title: "Change: X", description: "X position for builtin tool change", group: 4,
    type: "spatial", default_mm: 0, default_in: 0
  },
  toolChangeY: {
    title: "Change: Y", description: "Y position for builtin tool change", group: 4,
    type: "spatial", default_mm: 0, default_in: 0
  },
  toolChangeZ: {
    title: "Change: Z ", description: "Z position for builtin tool change", group: 4,
    type: "spatial", default_mm: 40, default_in: 1.6
  },
  toolChangeZProbe: {
    title: "Change: Make Z Probe", description: "Z probe after tool change", group: 4,
    type: "boolean", default_mm: true, default_in: true
  },
  toolChangeDisableZStepper: {
    title: "Change: Disable Z stepper", description: "Disable Z stepper when change a tool", group: 4,
    type: "boolean", default_mm: false, default_in: false
  },

  probeOnStart: {
    title: "Probe: On job start", description: "Execute probe gcode on job start", group: 5,
    type: "boolean", default_mm: true, default_in: true
  },
  probeThickness: {
    title: "Probe: Plate thickness", description: "Plate thickness", group: 5,
    type: "spatial", default_mm: 0.8, default_in: 0.032
  },
  probeUseHomeZ: {
    title: "Probe: Use Home Z", description: "Use G28 or G38 for probing", group: 5,
    type: "boolean", default_mm: true, default_in: true
  },
  probeG38Target: {
    title: "Probe: G38 target", description: "Probing up to Z position", group: 5,
    type: "spatial", default_mm: -10, default_in: -0.5
  },
  probeG38Speed: {
    title: "Probe: G38 speed", description: "Probing with speed (mm/min; in/min)", group: 5,
    type: "spatial", default_mm: 30, default_in: 1.2
  },

  cutterOnVaporize: {
    title: "Laser: On - Vaporize", description: "Persent of power to turn on the laser/plasma cutter in vaporize mode", group: 6,
    type: "number", default_mm: 100, default_in: 100
  },
  cutterOnThrough: {
    title: "Laser: On - Through", description: "Persent of power to turn on the laser/plasma cutter in through mode", group: 6,
    type: "number", default_mm: 80, default_in: 80
  },
  cutterOnEtch: {
    title: "Laser: On - Etch", description: "Persent of power to on the laser/plasma cutter in etch mode", group: 6,
    type: "number", default_mm: 40, default_in: 40
  },
  cutterMarlinMode: {
    title: "Laser: Marlin/Reprap mode", description: "Marlin/Reprar mode of the laser/plasma cutter", group: 6,
    type: "integer", default_mm: 106, default_in: 106,
    values: [
      { title: "M106 S{PWM}/M107", id: 106 },
      { title: "M3 O{PWM}/M5", id: 3 },
      { title: "M42 P{pin} S{PWM}", id: 42 },
    ]
  },
  cutterMarlinPin: {
    title: "Laser: Marlin M42 pin", description: "Marlin custom pin number for the laser/plasma cutter", group: 6,
    type: "integer", default_mm: 4, default_in: 4
  },

  gcodeStartFile: {
    title: "Extern: Start File", description: "File with custom Gcode for header/start (in nc folder)", group: 7,
    type: "file", default_mm: "", default_in: ""
  },
  gcodeStopFile: {
    title: "Extern: Stop File", description: "File with custom Gcode for footer/end (in nc folder)", group: 7,
    type: "file", default_mm: "", default_in: ""
  },
  gcodeToolFile: {
    title: "Extern: Tool File", description: "File with custom Gcode for tool change (in nc folder)", group: 7,
    type: "file", default_mm: "", default_in: ""
  },
  gcodeProbeFile: {
    title: "Extern: Probe File", description: "File with custom Gcode for tool probe (in nc folder)", group: 7,
    type: "file", default_mm: "", default_in: ""
  },


  DuetMillingMode: {
    title: "Duet: Milling mode", description: "GCode command to setup Duet3d milling mode", group: 10,
    type: "string", default_mm: "M453 P2 I0 R30000 F200", default_in: "M453 P2 I0 R30000 F200"
  },
  DuetLaserMode: {
    title: "Duet: Laser mode", description: "GCode command to setup Duet3d laser mode", group: 10,
    type: "string", default_mm: "M452 P2 I0 R255 F200", default_in: "M452 P2 I0 R255 F200"
  },


  GrblCutterMode: {
    title: "GRBL: Laser mode", description: "GRBL mode of the laser/plasma cutter", group: 11,
    type: "integer", default_mm: 4, default_in: 4,
    values: [
        { title: "M4 S{PWM}/M5 dynamic power", id: 4 },
        { title: "M3 S{PWM}/M5 static power", id: 3 },
    ]
  },

  // Coolant

  cl0_coolantA_Mode: {
    title: "Coolant: A Mode", description: "Enable channel A when tool is set this coolant", group: 8,
    type: "integer", default_mm: 0, default_in: 0,
    values: [
      { title: "off", id: 0 },
      { title: "flood", id: 1 },
      { title: "mist", id: 2 },
      { title: "throughTool", id: 3 },
      { title: "air", id: 4 },
      { title: "airThroughTool", id: 5 },
      { title: "suction", id: 6 },
      { title: "floodMist", id: 7 },
      { title: "floodThroughTool", id: 8 }
    ]
  },
  cl1_coolantB_Mode: {
    title: "Coolant: B Mode", description: "Enable channel B when tool is set this coolant", group: 8,
    type: "integer", default_mm: 0, default_in: 0,
    values: [
      { title: "off", id: 0 },
      { title: "flood", id: 1 },
      { title: "mist", id: 2 },
      { title: "throughTool", id: 3 },
      { title: "air", id: 4 },
      { title: "airThroughTool", id: 5 },
      { title: "suction", id: 6 },
      { title: "floodMist", id: 7 },
      { title: "floodThroughTool", id: 8 }
    ]
  },
  cl2_coolantAOn: {
      title: "Coolant: A Enable", description: "GCode to turn On coolant channel A", group: 8,
      type: "enum", default_mm: "M42 P6 S255", default_in: "M42 P6 S255",
      values: [
        { title: "Mrln: M42 P6 S255", id: "M42 P6 S255" },
        { title: "Mrln: M42 P11 S255", id: "M42 P11 S255" },
        { title: "Grbl: M7 (mist)", id: "M7" },
        { title: "Grbl: M8 (flood)", id: "M8" }
      ]
  },
  cl3_coolantAOff: {
    title: "Coolant: A Disable", description: "Gcode to turn Off coolant A", group: 8,
    type: "enum", default_mm: "M42 P6 S0", default_in: "M42 P6 S0",
    values: [
      { title: "Mrln: M42 P6 S0", id: "M42 P6 S0" },
      { title: "Mrln: M42 P11 S0", id: "M42 P11 S0" },
      { title: "Grbl: M9 (off)", id: "M9" }
    ]
  },
  cl4_coolantBOn: {
    title: "Coolant: B Enable", description: "GCode to turn On coolant channel B", group: 8,
    type: "enum", default_mm: "M42 P11 S255", default_in: "M42 P11 S255",
    values: [
      { title: "Mrln: M42 P11 S255", id: "M42 P11 S255" },
      { title: "Mrln: M42 P6 S255", id: "M42 P6 S255" },
      { title: "Grbl: M7 (mist)", id: "M7" },
      { title: "Grbl: M8 (flood)", id: "M8" }
    ]
  },
  cl5_coolantBOff: {
    title: "Coolant: B Disable", description: "Gcode to turn Off coolant B", group: 8,
    type: "enum", default_mm: "M42 P11 S0", default_in: "M42 P11 S0",
    values: [
      { title: "Mrln: M42 P11 S0", id: "M42 P11 S0" },
      { title: "Mrln: M42 P6 S0", id: "M42 P6 S0" },
      { title: "Grbl: M9 (off)", id: "M9" }
    ]
  },
};

/*

https://github.com/guffy1234/mpcnc_posts_processor

MPCNC posts processor for milling and laser/plasma cutting.

*/

var sequenceNumber;

// Formats
var gFormat = createFormat({ prefix: "G", decimals: 1 });
var mFormat = createFormat({ prefix: "M", decimals: 0 });

var xyzFormat = createFormat({ decimals: (unit == MM ? 3 : 4) });
var xFormat = createFormat({ prefix: "X", decimals: (unit == MM ? 3 : 4) });
var yFormat = createFormat({ prefix: "Y", decimals: (unit == MM ? 3 : 4) });
var zFormat = createFormat({ prefix: "Z", decimals: (unit == MM ? 3 : 4) });
var iFormat = createFormat({ prefix: "I", decimals: (unit == MM ? 3 : 4) });
var jFormat = createFormat({ prefix: "J", decimals: (unit == MM ? 3 : 4) });
var kFormat = createFormat({ prefix: "K", decimals: (unit == MM ? 3 : 4) });

var speedFormat = createFormat({ decimals: 0 });
var sFormat = createFormat({ prefix: "S", decimals: 0 });

var pFormat = createFormat({ prefix: "P", decimals: 0 });
var oFormat = createFormat({ prefix: "O", decimals: 0 });

var feedFormat = createFormat({ decimals: (unit == MM ? 0 : 2) });
var fFormat = createFormat({ prefix: "F", decimals: (unit == MM ? 0 : 2) });

var toolFormat = createFormat({ decimals: 0 });
var tFormat = createFormat({ prefix: "T", decimals: 0 });

var taperFormat = createFormat({ decimals: 1, scale: DEG });
var secFormat = createFormat({ decimals: 3, forceDecimal: true }); // seconds - range 0.001-1000

// Linear outputs
var xOutput = createVariable({}, xFormat);
var yOutput = createVariable({}, yFormat);
var zOutput = createVariable({}, zFormat);
var fOutput = createVariable({ force: false }, fFormat);
var sOutput = createVariable({ force: true }, sFormat);

// Circular outputs
var iOutput = createReferenceVariable({}, iFormat);
var jOutput = createReferenceVariable({}, jFormat);
var kOutput = createReferenceVariable({}, kFormat);

// Modals
var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gPlaneModal = createModal({ onchange: function () { gMotionModal.reset(); } }, gFormat); // modal group 2 // G17-19
var gAbsIncModal = createModal({}, gFormat); // modal group 3 // G90-91
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G93-94
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21

// Arc support variables
minimumChordLength = spatial(0.01, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(180);
allowHelicalMoves = false;
allowedCircularPlanes = undefined;

// Writes the specified block.
function writeBlock() {
  if (properties.jobSequenceNumbers) {
    writeWords2("N" + sequenceNumber, arguments);
    sequenceNumber += properties.jobSequenceNumberIncrement;
  } else {
    writeWords(arguments);
  }
}

var currentFirmware;

// Called in every new gcode file
function onOpen() {
  let fw = properties.jobSelectedFirmware;

  if (fw == eFirmware.GRBL) {
    gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
    writeln("%");
  }
  else {
    gMotionModal = createModal({ force: true }, gFormat); // modal group 1 // G0-G3, ...
  }

  if (properties.fr2_EnforceFeedrate) {
    fOutput = createVariable({ force: true }, fFormat);
  }

  sequenceNumber = properties.jobSequenceNumberStart;
  if (!properties.jobSeparateWordsWithSpace) {
    setWordSeparator("");
  }
}

// Called at end of gcode file
function onClose() {
  let fw = properties.jobSelectedFirmware;

  writeComment(eComment.Important, " *** STOP begin ***");

  flushMotions();

  if (properties.gcodeStopFile == "") {
    onCommand(COMMAND_COOLANT_OFF);
    if (properties.jobGoOriginOnFinish) {
      rapidMovementsXY(0, 0);
    }
    onCommand(COMMAND_STOP_SPINDLE);

    end(true);  
    
    writeComment(eComment.Important, " *** STOP end ***");
  } else {
    loadFile(properties.gcodeStopFile);
  }

  if (fw == eFirmware.GRBL) {
    writeln("%");
  }
}

var cutterOnCurrentPower;
var forceSectionToStartWithRapid = false;

function onSection() {
  let fw = properties.jobSelectedFirmware;

  // Every section needs to start with a Rapid to get to the initial location.
  // In the hobby version Rapids have been elliminated and the first command is
  // a onLinear not a onRapid command. This results in not current position being
  // that same as the cut to position which means wecan't determine the direction
  // of the move. Without a direction vector we can't scale the feedrate or convert
  // onLinear moves back into onRapids. By ensuring the first onLinear is treated as 
  // a onRapid we have a currentPosition that is correct.

  forceSectionToStartWithRapid = true;

  // Write Start gcode of the documment (after the "onParameters" with the global info)
  if (isFirstSection()) {
    writeFirstSection();
  }

  writeComment(eComment.Important, " *** SECTION begin ***");

  // Do a tool change if tool changes are enabled and its not the first section and this section uses
  // a different tool then the previous section
  if (properties.toolChangeEnabled && !isFirstSection() && tool.number != getPreviousSection().getTool().number) {
    if (properties.gcodeToolFile == "") {
      // Post Processor does the tool change

      writeComment(eComment.Important, " --- Tool Change Start")
      toolChange();
      writeComment(eComment.Important, " --- Tool Change End")
    } else {
      // Users custom tool change gcode is used
      loadFile(properties.gcodeToolFile);
    }
  }

  // Machining type
  if (currentSection.type == TYPE_MILLING) {
    // Specific milling code
    writeComment(eComment.Info, " " + sectionComment + " - Milling - Tool: " + tool.number + " - " + tool.comment + " " + getToolTypeName(tool.type));
  }

  if (currentSection.type == TYPE_JET) {
    // Cutter mode used for different cutting power in PWM laser
    switch (currentSection.jetMode) {
      case JET_MODE_THROUGH:
        cutterOnCurrentPower = properties.cutterOnThrough;
        break;
      case JET_MODE_ETCHING:
        cutterOnCurrentPower = properties.cutterOnEtch;
        break;
      case JET_MODE_VAPORIZE:
        cutterOnCurrentPower = properties.cutterOnVaporize;
        break;
      default:
        error("Cutting mode is not supported.");
    }
    writeComment(eComment.Info, " " + sectionComment + " - Laser/Plasma - Cutting mode: " + getParameter("operation:cuttingMode"));
  }

  // Print min/max boundaries for each section
  vectorX = new Vector(1, 0, 0);
  vectorY = new Vector(0, 1, 0);
  writeComment(eComment.Info, "   X Min: " + xyzFormat.format(currentSection.getGlobalRange(vectorX).getMinimum()) + " - X Max: " + xyzFormat.format(currentSection.getGlobalRange(vectorX).getMaximum()));
  writeComment(eComment.Info, "   Y Min: " + xyzFormat.format(currentSection.getGlobalRange(vectorY).getMinimum()) + " - Y Max: " + xyzFormat.format(currentSection.getGlobalRange(vectorY).getMaximum()));
  writeComment(eComment.Info, "   Z Min: " + xyzFormat.format(currentSection.getGlobalZRange().getMinimum()) + " - Z Max: " + xyzFormat.format(currentSection.getGlobalZRange().getMaximum()));

  // Adjust the mode
  if (fw == eFirmware.REPRAP) {
    if (machineMode != currentSection.type) {
      switch (currentSection.type) {
          case TYPE_MILLING:
              writeBlock(properties.DuetMillingMode);
              break;
          case TYPE_JET:
              writeBlock(properties.DuetLaserMode);
              break;
      }
    }
  }

  machineMode = currentSection.type;
  
  onCommand(COMMAND_START_SPINDLE);
  onCommand(COMMAND_COOLANT_ON);

  // Display section name in LCD
  display_text(" " + sectionComment);
}

function resetAll() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
  fOutput.reset();
}

// Called in every section end
function onSectionEnd() {
  resetAll();
  writeComment(eComment.Important, " *** SECTION end ***");
  writeln("");
}

function onComment(message) {
  writeComment(eComment.Important, message);
}

var pendingRadiusCompensation = RADIUS_COMPENSATION_OFF;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

// Rapid movements
function onRapid(x, y, z) {
  forceSectionToStartWithRapid = false;

  rapidMovements(x, y, z);
}

function safeToRapid(x, y, z) {
  if (properties.mapE_RestoreRapids) {
    let zSafe = (z >= properties.mapF_SafeZ);

    // Destination z must be in safe zone.
    if (zSafe) {
      let cur = getCurrentPosition();
      let zConstant = (z == cur.z);
      let zUp = (z > cur.z);
      let xyConstant = ((x == cur.x) && (y == cur.y));
      let curZSafe = (cur.z >= properties.mapF_SafeZ);

      // Restore Rapids only when the target Z is safe and
      //   Case 1: Z is not changing, but XY are
      //   Case 2: Z is increasing, but XY constant

      // Z is not changing and we know we are in the safe zone
      if (zConstant) {
        return true;
      }

      // We include moves of Z up as long as xy are constant
      else if (properties.mapG_AllowRapidZ && zUp && xyConstant) {
        return true;
      }

      // We include moves of Z down as long as xy are constant and z always remains safe
      else if (properties.mapG_AllowRapidZ && (!zUp) && xyConstant && curZSafe) {
        return true;
      }
    }
  }

  return false;
}

// Feed movements
function onLinear(x, y, z, feed) {
  // If we are allowing Rapids to be recovered from Linear (cut) moves, which is
  // only required when F360 Personal edition is used, then if this Linear (cut)
  // move is the first operationin a Section (milling operation) then convert it
  // to a Rapid. This is OK because Sections normally begin with a Rapid to move
  // to the first cutting location but these Rapids were changed to Linears by
  // the personal edition. If this Rapid is not recovered and feedrate scaling
  // is enabled then the first move to the start of a section will be at the
  // slowest cutting feedrate, generally Z's feedrate.

  if (properties.mapD_RestoreFirstRapids && (forceSectionToStartWithRapid == true)) {
    writeComment(eComment.Important, " First G1 --> G0");

    forceSectionToStartWithRapid = false;
    onRapid(x, y, z);
  }
  else if (safeToRapid(x, y, z)) {
    writeComment(eComment.Important, " Safe G1 --> G0");

    onRapid(x, y, z);
  }
  else {
    linearMovements(x, y, z, feed, true);
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  forceSectionToStartWithRapid = false;

  error(localize("Multi-axis motion is not supported."));
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  forceSectionToStartWithRapid = false;

  error(localize("Multi-axis motion is not supported."));
}

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  forceSectionToStartWithRapid = false;

  if (pendingRadiusCompensation != RADIUS_COMPENSATION_OFF) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }
  circular(clockwise, cx, cy, cz, x, y, z, feed)
}

// Called on waterjet/plasma/laser cuts
var powerState = false;

function onPower(power) {
  if (power != powerState) {
    if (power) {
      writeComment(eComment.Important, " >>> LASER Power ON");

      laserOn(cutterOnCurrentPower);
    } else {
      writeComment(eComment.Important, " >>> LASER Power OFF");

      laserOff();
    }
    powerState = power;
  }
}

// Called on Dwell Manual NC invocation
function onDwell(seconds) {
  let fw = properties.jobSelectedFirmware;
  
  writeComment(eComment.Important, " >>> Dwell");
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }

  seconds = clamp(0.001, seconds, 99999.999);

    // Firmware is Grbl
  if (fw == eFirmware.GRBL) {
    writeBlock(gFormat.format(4), "P" + secFormat.format(seconds));
  }

  // Default
  else {
    writeBlock(gFormat.format(4), "S" + secFormat.format(seconds));
  }
}

// Called with every parameter in the documment/section
function onParameter(name, value) {

  // Write gcode initial info
  // Product version
  if (name == "generated-by") {
    writeComment(eComment.Important, value);
    writeComment(eComment.Important, " Posts processor: " + FileSystem.getFilename(getConfigurationPath()));
  }
  // Date
  if (name == "generated-at") writeComment(eComment.Important, " Gcode generated: " + value + " GMT");
  // Document
  if (name == "document-path") writeComment(eComment.Important, " Document: " + value);
  // Setup
  if (name == "job-description") writeComment(eComment.Important, " Setup: " + value);

  // Get section comment
  if (name == "operation-comment") sectionComment = value;
}

function onMovement(movement) {
  var jet = tool.isJetTool && tool.isJetTool();
  var id;

  switch (movement) {
    case MOVEMENT_RAPID:
      id = "MOVEMENT_RAPID";
      break;
    case MOVEMENT_LEAD_IN:
      id = "MOVEMENT_LEAD_IN";
      break;
    case MOVEMENT_CUTTING:
      id = "MOVEMENT_CUTTING";
      break;
    case MOVEMENT_LEAD_OUT:
      id = "MOVEMENT_LEAD_OUT";
      break;
    case MOVEMENT_LINK_TRANSITION:
      id = jet ? "MOVEMENT_BRIDGING" : "MOVEMENT_LINK_TRANSITION";
      break;
    case MOVEMENT_LINK_DIRECT:
      id = "MOVEMENT_LINK_DIRECT";
      break;
    case MOVEMENT_RAMP_HELIX:
      id = jet ? "MOVEMENT_PIERCE_CIRCULAR" : "MOVEMENT_RAMP_HELIX";
      break;
    case MOVEMENT_RAMP_PROFILE:
      id = jet ? "MOVEMENT_PIERCE_PROFILE" : "MOVEMENT_RAMP_PROFILE";
      break;
    case MOVEMENT_RAMP_ZIG_ZAG:
      id = jet ? "MOVEMENT_PIERCE_LINEAR" : "MOVEMENT_RAMP_ZIG_ZAG";
      break;
    case MOVEMENT_RAMP:
      id = "MOVEMENT_RAMP";
      break;
    case MOVEMENT_PLUNGE:
      id = jet ? "MOVEMENT_PIERCE" : "MOVEMENT_PLUNGE";
      break;
    case MOVEMENT_PREDRILL:
      id = "MOVEMENT_PREDRILL";
      break;
    case MOVEMENT_EXTENDED:
      id = "MOVEMENT_EXTENDED";
      break;
    case MOVEMENT_REDUCED:
      id = "MOVEMENT_REDUCED";
      break;
    case MOVEMENT_HIGH_FEED:
      id = "MOVEMENT_HIGH_FEED";
      break;
    case MOVEMENT_FINISH_CUTTING:
      id = "MOVEMENT_FINISH_CUTTING";
      break;
  }

  if (id == undefined) {
    id = String(movement);
  }

  writeComment(eComment.Info, " " + id);
}

var currentSpindleSpeed = 0;

function setSpindeSpeed(_spindleSpeed, _clockwise) {
  if (currentSpindleSpeed != _spindleSpeed) {
    if (_spindleSpeed > 0) {
      spindleOn(_spindleSpeed, _clockwise);
    } else {
      spindleOff();
    }
    currentSpindleSpeed = _spindleSpeed;
  }
}

function onSpindleSpeed(spindleSpeed) {
  setSpindeSpeed(spindleSpeed, tool.clockwise);
}

function onCommand(command) {
  if (properties.commentActivities) {
    var stringId = getCommandStringId(command);
    writeComment(eComment.Info, " " + stringId);
  }
  switch (command) {
    case COMMAND_START_SPINDLE:
      onCommand(tool.clockwise ? COMMAND_SPINDLE_CLOCKWISE : COMMAND_SPINDLE_COUNTERCLOCKWISE);
      return;
    case COMMAND_SPINDLE_CLOCKWISE:
      if (tool.jetTool)
        return;
      setSpindeSpeed(spindleSpeed, true);
      return;
    case COMMAND_SPINDLE_COUNTERCLOCKWISE:
      if (tool.jetTool)
        return;
      setSpindeSpeed(spindleSpeed, false);
      return;
    case COMMAND_STOP_SPINDLE:
      if (tool.jetTool)
        return;
      setSpindeSpeed(0, true);
      return;
    case COMMAND_COOLANT_ON:
      setCoolant(tool.coolant);
      return;
    case COMMAND_COOLANT_OFF:
      setCoolant(0);  //COOLANT_DISABLED
      return;
    case COMMAND_LOCK_MULTI_AXIS:
      return;
    case COMMAND_UNLOCK_MULTI_AXIS:
      return;
    case COMMAND_BREAK_CONTROL:
      return;
    case COMMAND_TOOL_MEASURE:
      if (tool.jetTool)
        return;
      probeTool();
      return;
    case COMMAND_STOP:
      writeBlock(mFormat.format(0));
      return;
  }
}

function writeFirstSection() {
  // dump tool information
  var toolZRanges = {};
  var vectorX = new Vector(1, 0, 0);
  var vectorY = new Vector(0, 1, 0);
  var ranges = {
    x: { min: undefined, max: undefined },
    y: { min: undefined, max: undefined },
    z: { min: undefined, max: undefined },
  };
  var handleMinMax = function (pair, range) {
    var rmin = range.getMinimum();
    var rmax = range.getMaximum();
    if (pair.min == undefined || pair.min > rmin) {
      pair.min = rmin;
    }
    if (pair.max == undefined || pair.max < rmin) {  // was pair.min - changed by DG 1/4/2021
      pair.max = rmax;
    }
  }

  var numberOfSections = getNumberOfSections();
  for (var i = 0; i < numberOfSections; ++i) {
    var section = getSection(i);
    var tool = section.getTool();
    var zRange = section.getGlobalZRange();
    var xRange = section.getGlobalRange(vectorX);
    var yRange = section.getGlobalRange(vectorY);
    handleMinMax(ranges.x, xRange);
    handleMinMax(ranges.y, yRange);
    handleMinMax(ranges.z, zRange);
    if (is3D()) {
      if (toolZRanges[tool.number]) {
        toolZRanges[tool.number].expandToRange(zRange);
      } else {
        toolZRanges[tool.number] = zRange;
      }
    }
  }

  writeComment(eComment.Info, " ");
  writeComment(eComment.Info, " Ranges table:");
  writeComment(eComment.Info, "   X: Min=" + xyzFormat.format(ranges.x.min) + " Max=" + xyzFormat.format(ranges.x.max) + " Size=" + xyzFormat.format(ranges.x.max - ranges.x.min));
  writeComment(eComment.Info, "   Y: Min=" + xyzFormat.format(ranges.y.min) + " Max=" + xyzFormat.format(ranges.y.max) + " Size=" + xyzFormat.format(ranges.y.max - ranges.y.min));
  writeComment(eComment.Info, "   Z: Min=" + xyzFormat.format(ranges.z.min) + " Max=" + xyzFormat.format(ranges.z.max) + " Size=" + xyzFormat.format(ranges.z.max - ranges.z.min));

  writeComment(eComment.Info, " ");
  writeComment(eComment.Info, " Tools table:");
  var tools = getToolTable();
  if (tools.getNumberOfTools() > 0) {
    for (var i = 0; i < tools.getNumberOfTools(); ++i) {
      var tool = tools.getTool(i);
      var comment = "  T" + toolFormat.format(tool.number) + " D=" + xyzFormat.format(tool.diameter) + " CR=" + xyzFormat.format(tool.cornerRadius);
      if ((tool.taperAngle > 0) && (tool.taperAngle < Math.PI)) {
        comment += " TAPER=" + taperFormat.format(tool.taperAngle) + "deg";
      }
      if (toolZRanges[tool.number]) {
        comment += " - ZMIN=" + xyzFormat.format(toolZRanges[tool.number].getMinimum());
      }
      comment += " - " + getToolTypeName(tool.type) + " " + tool.comment;
      writeComment(eComment.Info, comment);
    }
  }

    writeComment(eComment.Info, " ");

  writeComment(eComment.Important, " *** START begin ***");

  if (properties.gcodeStartFile == "") {
       Start();
  } else {
    loadFile(properties.gcodeStartFile);
  }

  writeComment(eComment.Important, " *** START end ***");
  writeComment(eComment.Important, " ");
}

// Output a comment
function writeComment(level, text) {
  if (level <= properties.jobCommentLevel) {
    let fw = properties.jobSelectedFirmware;

    if (fw == eFirmware.GRBL) {
      writeln("(" + String(text).replace(/[\(\)]/g, "") + ")");
    }
    else {
      writeln(";" + String(text).replace(/[\(\)]/g, ""));
    }
  }
}

// Rapid movements with G1 and differentiated travel speeds for XY
// Changes F360 current XY.
// No longer called for general Rapid only for probing, homing, etc.
function rapidMovementsXY(_x, _y) {
  let x = xOutput.format(_x);
  let y = yOutput.format(_y);

  if (x || y) {
    if (pendingRadiusCompensation != RADIUS_COMPENSATION_OFF) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    }
    else {
      let f = fOutput.format(propertyMmToUnit(properties.fr0_TravelSpeedXY));
      writeBlock(gMotionModal.format(0), x, y, f);
    }
  }
}

// Rapid movements with G1 and differentiated travel speeds for Z
// Changes F360 current Z
// No longer called for general Rapid only for probing, homing, etc.
function rapidMovementsZ(_z) {
  let z = zOutput.format(_z);

  if (z) {
    if (pendingRadiusCompensation != RADIUS_COMPENSATION_OFF) {
      error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    }
    else {
      let f = fOutput.format(propertyMmToUnit(properties.fr1_TravelSpeedZ));
      writeBlock(gMotionModal.format(0), z, f);
    }
  }
}

// Rapid movements with G1 uses the max travel rate (xy or z) and then relies on feedrate scaling
function rapidMovements(_x, _y, _z) {

  rapidMovementsZ(_z);
  rapidMovementsXY(_x, _y);
}

// Calculate the feedX, feedY and feedZ components

function limitFeedByXYZComponents(curPos, destPos, feed) {
  if (!properties.frA_ScaleFeedrate)
    return feed;

  var xyz = Vector.diff(destPos, curPos);       // Translate the cut so curPos is at 0,0,0
  var dir = xyz.getNormalized();                // Normalize vector to get a direction vector
  var xyzFeed = Vector.product(dir.abs, feed);  // Determine the effective x,y,z speed on each axis

  // Get the max speed for each axis
  let xyLimit = propertyMmToUnit(properties.frB_MaxCutSpeedXY);
  let zLimit = propertyMmToUnit(properties.frC_MaxCutSpeedZ);

  // Normally F360 begins a Section (a milling operation) with a Rapid to move to the beginning of the cut.
  // Rapids use the defined Travel speed and the Post Processor does not depend on the current location.
  // This function must know the current location in order to calculate the actual vector traveled. Without
  // the first Rapid the current location is the same as the desination location, which creates a 0 length
  // vector. A zero length vector is unusable and so a instead the slowest of the xyLimit or zLimit is used.
  //
  // Note: if Map: G1 -> Rapid is enabled in the Properties then if the first operation in a Section is a
  // cut (which it should always be) then it will be converted to a Rapid. This prevents ever getting a zero
  // length vector.
    if (xyz.length == 0) {
    var lesserFeed = (xyLimit < zLimit) ? xyLimit : zLimit;

    return lesserFeed;
  }

  // Force the speed of each axis to be within limits
  if (xyzFeed.z > zLimit) {
    xyzFeed.multiply(zLimit / xyzFeed.z);
  }

  if (xyzFeed.x > xyLimit) {
    xyzFeed.multiply(xyLimit / xyzFeed.x);
  }

  if (xyzFeed.y > xyLimit) {
    xyzFeed.multiply(xyLimit / xyzFeed.y);
  }

  // Calculate the new feedrate based on the speed allowed on each axis: feedrate = sqrt(x^2 + y^2 + z^2)
  // xyzFeed.length is the same as Math.sqrt((xyzFeed.x * xyzFeed.x) + (xyzFeed.y * xyzFeed.y) + (xyzFeed.z * xyzFeed.z))

  // Limit the new feedrate by the maximum allowable cut speed

  let xyzLimit = propertyMmToUnit(properties.frD_MaxCutSpeedXYZ);
  let newFeed = (xyzFeed.length > xyzLimit) ? xyzLimit : xyzFeed.length;

  if (Math.abs(newFeed - feed) > 0.01) {
    return newFeed;
  }
  else {
    return feed;
  }
}

// Linear movements
function linearMovements(_x, _y, _z, _feed) {
  if (pendingRadiusCompensation != RADIUS_COMPENSATION_OFF) {
    // ensure that we end at desired position when compensation is turned off
    xOutput.reset();
    yOutput.reset();
  }

  // Force the feedrate to be scaled (if enabled). The feedrate is projected into the
  // x, y, and z axis and each axis is tested to see if it exceeds its defined max. If
  // it does then the speed in all 3 axis is scaled proportionately. The resulting feedrate
  // is then capped at the maximum defined cutrate.

  let feed = limitFeedByXYZComponents(getCurrentPosition(), new Vector(_x, _y, _z), _feed);

  let x = xOutput.format(_x);
  let y = yOutput.format(_y);
  let z = zOutput.format(_z);
  let f = fOutput.format(feed);

  if (x || y || z) {
    if (pendingRadiusCompensation != RADIUS_COMPENSATION_OFF) {
      error(localize("Radius compensation mode is not supported."));
    } else {
      writeBlock(gMotionModal.format(1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      fOutput.reset(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
}

// Test if file exist/can read and load it
function loadFile(_file) {
  var folder = FileSystem.getFolderPath(getOutputPath()) + PATH_SEPARATOR;
  if (FileSystem.isFile(folder + _file)) {
    var txt = loadText(folder + _file, "utf-8");
    if (txt.length > 0) {
      writeComment(eComment.Info, " --- Start custom gcode " + folder + _file);
      write(txt);
      writeComment("eComment.Info,  --- End custom gcode " + folder + _file);
    }
  } else {
    writeComment(eComment.Important, " Can't open file " + folder + _file);
    error("Can't open file " + folder + _file);
  }
}

// Manage two channels of coolant by tracking which coolant is being using for
// a channel (0 = disabled). SetCoolant called with desired coolant to use or 0 to disable

var coolantChannelA = 0;
var coolantChannelB = 0;

function setCoolant(coolant) {
  let fw = properties.jobSelectedFirmware;

  // As long as we are not disabling coolant (= 0), then if either of the coolant
  // channels are already operating in the mode requested then there is
  // nothing to do
  if ((coolant != 0) &&
      ((coolantChannelA == coolant) || (coolantChannelB == coolant))) {
    return;
  }

  // F360 allows only 1 coolant to be defined on an operation. If a coolant channel
  // is active then disable it before we switch to the other
  if (coolantChannelA != 0) {
    writeComment((coolant == 0) ? eComment.Important: eComment.Info, " >>> Coolant Channel A: off");
    coolantChannelA = 0;
    CoolantA(false);
  }

  if (coolantChannelB != 0) {
    writeComment((coolant == 0) ? eComment.Important: eComment.Info, " >>> Coolant Channel B: off");
    coolantChannelB = 0;
    CoolantB(false);
  }

  // As long as we are not disabling coolant (coolant = 0), then check the coolant channels
  // and enable the one that provides the coolant requested. If neither do then
  // issue an warning
  if (coolant != 0) {
    if (properties.cl0_coolantA_Mode == coolant) {
      writeComment(eComment.Important, " >>> Coolant Channel A: " + propertyDefinitions.cl0_coolantA_Mode.values[coolant].title);
      coolantChannelA =  coolant;
      CoolantA(true);
    }
    else if (properties.cl1_coolantB_Mode == coolant) {
      writeComment(eComment.Important, " >>> Coolant Channel B: " + propertyDefinitions.cl1_coolantB_Mode.values[coolant].title);
      coolantChannelB =  coolant;
      CoolantB(true);
    }
    else {
      writeComment(eComment.Important, " >>> WARNING: Coolant Channels, none set for: " + coolant);
    }
  }
}

function propertyMmToUnit(_v) {
  return (_v / (unit == IN ? 25.4 : 1));
}

/*
function mergeProperties(to, from) {
  for (var attrname in from) {
    to[attrname] = from[attrname];
  }
}

function Firmware3dPrinterLike() {
  FirmwareBase.apply(this, arguments);
  this.spindleEnabled = false;
}

Firmware3dPrinterLike.prototype = Object.create(FirmwareBase.prototype);
Firmware3dPrinterLike.prototype.constructor = Firmware3dPrinterLike;
*/

function Start() {
  let fw = properties.jobSelectedFirmware;

  // Is Grbl?
  if (fw == eFirmware.GRBL) {
    writeBlock(gAbsIncModal.format(90)); // Set to Absolute Positioning
    writeBlock(gFeedModeModal.format(94));
    writeBlock(gPlaneModal.format(17));
    writeBlock(gUnitModal.format(unit == IN ? 20 : 21));
  }

  // Default
  else {
    writeComment(eComment.Info, "   Set Absolute Positioning");
    writeComment(eComment.Info, "   Units = " + (unit == IN ? "inch" : "mm"));
    writeComment(eComment.Info, "   Disable stepper timeout");
    if (properties.jobSetOriginOnStart) {
      writeComment(eComment.Info, "   Set current position = 0,0,0");
    }

    writeBlock(gAbsIncModal.format(90)); // Set to Absolute Positioning
    writeBlock(gUnitModal.format(unit == IN ? 20 : 21)); // Set the units
    writeBlock(mFormat.format(84), sFormat.format(0)); // Disable steppers timeout

    if (properties.jobSetOriginOnStart) {
      writeBlock(gFormat.format(92), xFormat.format(0), yFormat.format(0), zFormat.format(0)); // Set origin to initial position
    }

    if (properties.probeOnStart && tool.number != 0 && !tool.jetTool) {
      onCommand(COMMAND_TOOL_MEASURE);
    }
  }
}
function end() {
  let fw = properties.jobSelectedFirmware;

  // Is Grbl?
  if (fw == eFirmware.GRBL) {
    writeBlock(mFormat.format(30));
  }

  // Default
  else {
    display_text("Job end");
  }
}


function spindleOn(_spindleSpeed, _clockwise) {
  let fw = properties.jobSelectedFirmware;

  // Is Grbl?
  if (fw == eFirmware.GRBL) {
    writeComment(eComment.Important, " >>> Spindle Speed " + speedFormat.format(_spindleSpeed));
    writeBlock(mFormat.format(_clockwise ? 3 : 4), sOutput.format(spindleSpeed));
  }

  // Default
  else {
    if (properties.jobManualSpindlePowerControl) {
      // for manual any positive input speed assumed as enabled. so it's just a flag
      if (!this.spindleEnabled) {
        writeComment(eComment.Important, " >>> Spindle Speed: Manual");
        askUser("Turn ON " + speedFormat.format(_spindleSpeed) + "RPM", "Spindle", false);
      }
    } else {
      writeComment(eComment.Important, " >>> Spindle Speed " + speedFormat.format(_spindleSpeed));
      writeBlock(mFormat.format(_clockwise ? 3 : 4), sOutput.format(spindleSpeed));
    }
    this.spindleEnabled = true;
  }
}
function spindleOff() {
  let fw = properties.jobSelectedFirmware;

  // Is Grbl?
  if (fw == eFirmware.GRBL) {
    writeBlock(mFormat.format(5));
  }

  //Default
  else {
    if (properties.jobManualSpindlePowerControl) {
      writeBlock(mFormat.format(300), sFormat.format(300), pFormat.format(3000));
      askUser("Turn OFF spindle", "Spindle", false);
    } else {
      writeBlock(mFormat.format(5));
    }
    this.spindleEnabled = false;
  }
}

function laserOn(power) {
  let fw = properties.jobSelectedFirmware;
  var laser_pwm = power / 100 * 255;

  // Firmware is Grbl
  if (fw == eFirmware.GRBL) {
    writeBlock(mFormat.format(properties.GrblCutterMode), sFormat.format(laser_pwm));
  }

  // Default firmware
  else {
    switch (properties.cutterMarlinMode) {
      case 106:
        writeBlock(mFormat.format(106), sFormat.format(laser_pwm));
        break;
      case 3:
        if (fw = eFirmware.REPRAP) {
          writeBlock(mFormat.format(3), sFormat.format(laser_pwm));
        } else {
          writeBlock(mFormat.format(3), oFormat.format(laser_pwm));
        }
        break;
      case 42:
        writeBlock(mFormat.format(42), pFormat.format(properties.cutterMarlinPin), sFormat.format(laser_pwm));
        break;
    }
  }
}

function laserOff() {
  let fw = properties.jobSelectedFirmware;

  // Firmware is Grbl
  if (fw == eFirmware.GRBL) {
    writeBlock(mFormat.format(5));
  }

  // Default
  else {
    switch (properties.cutterMarlinMode) {
      case 106:
        writeBlock(mFormat.format(107));
        break;
      case 3:
        writeBlock(mFormat.format(5));
        break;
      case 42:
        writeBlock(mFormat.format(42), pFormat.format(properties.cutterMarlinPin), sFormat.format(0));
        break;
    }
  }
}

function display_text(txt) {
  let fw = properties.jobSelectedFirmware;

  // Firmware is Grbl
  if (fw == eFirmware.GRBL) {
    // Don't display text
  }

  // Default
  else {
    writeBlock(mFormat.format(117), (properties.jobSeparateWordsWithSpace ? "" : " ") + txt);
  }
}

function circular(clockwise, cx, cy, cz, x, y, z, feed) {
  if (!properties.jobUseArcs) {
    linearize(tolerance);
    return;
  }

  var start = getCurrentPosition();
  let fw = properties.jobSelectedFirmware;

  // Firmware is Grbl
  if (fw == eFirmware.GRBL) {
    if (isFullCircle()) {
        if (isHelical()) {
            linearize(tolerance);
            return;
        }
        switch (getCircularPlane()) {
            case PLANE_XY:
                writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), fOutput.format(feed));
                break;
            case PLANE_ZX:
                writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), fOutput.format(feed));
                break;
            case PLANE_YZ:
                writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), yOutput.format(y), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), fOutput.format(feed));
                break;
            default:
                linearize(tolerance);
        }
    } else {
        switch (getCircularPlane()) {
            case PLANE_XY:
                writeBlock(gPlaneModal.format(17), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), fOutput.format(feed));
                break;
            case PLANE_ZX:
                writeBlock(gPlaneModal.format(18), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), fOutput.format(feed));
                break;
            case PLANE_YZ:
                writeBlock(gPlaneModal.format(19), gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), fOutput.format(feed));
                break;
            default:
                linearize(tolerance);
        }
    }
  }

  // Default
  else {
    // Marlin supports arcs only on XY plane
    if (isFullCircle()) {
      if (isHelical()) {
        linearize(tolerance);
        return;
      }
      switch (getCircularPlane()) {
        case PLANE_XY:
          writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), fOutput.format(feed));
          break;
        default:
          linearize(tolerance);
      }
    } else {
      switch (getCircularPlane()) {
        case PLANE_XY:
          writeBlock(gMotionModal.format(clockwise ? 2 : 3), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), fOutput.format(feed));
          break;
        default:
          linearize(tolerance);
      }
    }
  }
}

function askUser(text, title, allowJog) {
  let fw = properties.jobSelectedFirmware;

  // Firmware is RepRap?
  if (fw == eFirmware.REPRAP) {
    var v1 = " P\"" + text + "\" R\"" + title + "\" S3";
    var v2 = allowJog ? " X1 Y1 Z1" : "";
    writeBlock(mFormat.format(291), (properties.jobSeparateWordsWithSpace ? "" : " ") + v1 + v2);
  }

  // Default
  else {
    writeBlock(mFormat.format(0), (properties.jobSeparateWordsWithSpace ? "" : " ") + text);
  }
}

function toolChange() {
  let fw = properties.jobSelectedFirmware;

  // Grbl tool change?
  if (fw == eFirmware.GRBL) {
    
    writeBlock(mFormat.format(6), tFormat.format(tool.number));
    writeBlock(gFormat.format(54));
  }

  // Default tool change
  else
  {
    flushMotions();

    // Go to tool change position
    onRapid(propertyMmToUnit(properties.toolChangeX), propertyMmToUnit(properties.toolChangeY), propertyMmToUnit(properties.toolChangeZ));
    
    flushMotions();
  
    // turn off spindle and coolant
    onCommand(COMMAND_COOLANT_OFF);
    onCommand(COMMAND_STOP_SPINDLE);
    if (!properties.jobManualSpindlePowerControl) {
      // Beep
      writeBlock(mFormat.format(300), sFormat.format(400), pFormat.format(2000));
    }
  
    // Disable Z stepper
    if (properties.toolChangeDisableZStepper) {
      askUser("Z Stepper will disabled. Wait for STOP!!", "Tool change", false);
      writeBlock(mFormat.format(17), 'Z'); // Disable steppers timeout
    }
    // Ask tool change and wait user to touch lcd button
    askUser("Tool " + tool.number + " " + tool.comment, "Tool change", true);
  
    // Run Z probe gcode
    if (properties.toolChangeZProbe && tool.number != 0) {
      onCommand(COMMAND_TOOL_MEASURE);
    }
  }
}

function probeTool() {
  let fw = properties.jobSelectedFirmware;

  // Is Grbl?
  if (fw == eFirmware.GRBL) {
  }

  // Default
  else {
    writeComment(eComment.Important, " Probe to Zero Z");
    writeComment(eComment.Info, "   Ask User to Attach the Z Probe");
    writeComment(eComment.Info, "   Do Probing");
    writeComment(eComment.Info, "   Set Z to probe thickness: " + zFormat.format(propertyMmToUnit(properties.probeThickness)))
    if (properties.toolChangeZ != "") {
      writeComment(eComment.Info, "   Retract the tool to " + propertyMmToUnit(properties.toolChangeZ));
    }
    writeComment(eComment.Info, "   Ask User to Remove the Z Probe");

    askUser("Attach ZProbe", "Probe", false);
    // refer http://marlinfw.org/docs/gcode/G038.html
    if (properties.probeUseHomeZ) {
      writeBlock(gFormat.format(28), 'Z');
    } else {
      writeBlock(gMotionModal.format(38.3), fFormat.format(propertyMmToUnit(properties.probeG38Speed)), zFormat.format(propertyMmToUnit(properties.probeG38Target)));
    }

    let z = zFormat.format(propertyMmToUnit(properties.probeThickness));
    writeBlock(gFormat.format(92), z); // Set origin to initial position
    
    resetAll();
    if (properties.toolChangeZ != "") { // move up tool to safe height again after probing
      rapidMovementsZ(propertyMmToUnit(properties.toolChangeZ), false);
    }
    
    flushMotions();

    askUser("Detach ZProbe", "Probe", false);
  }
}