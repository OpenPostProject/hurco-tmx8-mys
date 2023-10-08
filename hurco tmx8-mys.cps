var modelType = "TMX8MYS";
description = "Hurco TMX8MYS";
// >>>>> INCLUDED FROM ../common/hurco mill-turn winmax.cps
//Save This line for editing purposes, comment out before merge
//var modelType = "TMX10MYS";

/**
  Copyright (C) 2012-2022 by Autodesk, Inc.
  All rights reserved.

  Hurco Mill/Turn post processor configuration.

  $Revision: 44087 43ff59acac2ccdd53640189224c9bca7a698e75c $
  $Date: 2023-08-28 23:04:40 $

  FORKID {D979ECEE-FE47-4151-A3AF-3754E4b5409E}
*/

///////////////////////////////////////////////////////////////////////////////
//                        MANUAL NC COMMANDS
//
// The following ACTION commands are supported by this post.
//
//     partEject                  - Manually eject the part
//     useXZCMode                 - Force XZC mode for next operation
//     usePolarMode               - Force Polar mode for next operation
//
///////////////////////////////////////////////////////////////////////////////

if (!description) {
  description = "Hurco Mill/Turn";
}
vendor = "Hurco";
vendorUrl = "https://www.hurco.com/";
legal = "Copyright (C) 2012-2022 by Autodesk, Inc.";
certificationLevel = 2;
minimumRevision = 45702;

if (!longDescription) {
  longDescription = subst("Preconfigured %1 post (WinMax) with support for mill-turn.", description);
}

extension = "LNC";
programNameIsInteger = true;
setCodePage("ascii");

capabilities = CAPABILITY_MILLING | CAPABILITY_TURNING;
tolerance = spatial(0.002, MM);

minimumChordLength = spatial(0.25, MM);
minimumCircularRadius = spatial(0.01, MM);
maximumCircularRadius = spatial(1000, MM);
minimumCircularSweep = toRad(0.01);
maximumCircularSweep = toRad(90); // reduced sweep due to G112 support
allowHelicalMoves = true;
allowedCircularPlanes = undefined; // allow any circular motion
allowSpiralMoves = false;
highFeedrate = (unit == IN) ? 240 : 6000;

// user-defined properties
properties = {
  controllerType: {
    title      : "Controller model",
    description: "Select the controller model",
    type       : "enum",
    group      : "configuration",
    values     : [
      {title:"V9", id:"v9"},
      {title:"V11", id:"v11"}
    ],
    value: "v11",
    scope: "post"
  },
  writeMachine: {
    title      : "Write machine",
    description: "Output the machine settings in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  writeTools: {
    title      : "Write tool list",
    description: "Output a tool list in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  maxTool: {
    title      : "Max tool number",
    description: "Defines the maximum tool number.",
    group      : "configuration",
    type       : "integer",
    range      : [0, 999999999],
    value      : 99,
    scope      : "post"
  },
  showSequenceNumbers: {
    title      : "Use sequence numbers",
    description: "'Yes' outputs sequence numbers on each block, 'Only on tool change' outputs sequence numbers on tool change blocks only, and 'No' disables the output of sequence numbers.",
    group      : "formats",
    type       : "enum",
    values     : [
      {title:"Yes", id:"true"},
      {title:"No", id:"false"},
      {title:"Only on tool change", id:"toolChange"}
    ],
    value: "toolChange",
    scope: "post"
  },
  sequenceNumberStart: {
    title      : "Start sequence number",
    description: "The number at which to start the sequence numbers.",
    group      : "formats",
    type       : "integer",
    value      : 1,
    scope      : "post"
  },
  sequenceNumberIncrement: {
    title      : "Sequence number increment",
    description: "The amount by which the sequence number is incremented by in each block.",
    group      : "formats",
    type       : "integer",
    value      : 1,
    scope      : "post"
  },
  optionalStop: {
    title      : "Optional stop",
    description: "Outputs optional stop code during when necessary in the code.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  separateWordsWithSpace: {
    title      : "Separate words with space",
    description: "Adds spaces between words if 'yes' is selected.",
    group      : "formats",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useRadius: {
    title      : "Radius arcs",
    description: "If yes is selected, arcs are outputted using radius values rather than IJK.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  maximumSpindleSpeed: {
    title      : "Max spindle speed",
    description: "Defines the maximum spindle speed allowed by your machines.",
    group      : "configuration",
    type       : "integer",
    range      : [0, 999999999],
    value      : 3500,
    scope      : "post"
  },
  useParametricFeed: {
    title      : "Parametric feed",
    description: "Specifies the feed value that should be output using a Q value.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  showNotes: {
    title      : "Show notes",
    description: "Writes operation notes as comments in the outputted code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useCycles: {
    title      : "Use cycles",
    description: "Specifies if canned drilling cycles should be used.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  unClampRotaryAxis: {
    title      : "Leave C-axis unclamped",
    description: "Unclamps the C-axis during milling/drilling operations.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "operation"
  },
  usePartCatcher: {
    title      : "Use part catcher",
    description: "Specifies whether part catcher code should be output.",
    group      : "configuration",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  partCatcherPosition: {
    title      : "Part catcher W pre-position location",
    description: "Position to place the W axis during the part catcher at cutoff. A W0 position will feed the axis from the home position",
    group      : "configuration",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  autoEject: {
    title      : "Auto eject",
    description: "Specifies whether the part should automatically eject at the end of a program.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useTailStock: {
    title       : "Use tailstock",
    description : "Specifies whether to use the tailstock or not.",
    group       : "configuration",
    type        : "boolean",
    presentation: "yesno",
    value       : false,
    scope       : "post"
  },
  gotChipConveyor: {
    title       : "Got chip conveyor",
    description : "Specifies whether to use a chip conveyor.",
    group       : "configuration",
    type        : "boolean",
    presentation: "yesno",
    value       : false,
    scope       : "post"
  },
  xAxisMinimum: {
    title      : "X-axis minimum limit",
    description: "Defines the lower limit of X-axis travel as a radius value.",
    group      : "configuration",
    type       : "spatial",
    range      : [-99999, 0],
    value      : 0,
    scope      : "post"
  },
  safePositionMethod: {
    title      : "Safe Retracts",
    description: "Select your desired retract option for the Z-axis. G28 option is only for v11 controls that support it.",
    group      : "homePositions",
    type       : "enum",
    values     : [
      {title:"G28", id:"G28"},
      {title:"G53", id:"G53"}
    ],
    value: "G53",
    scope: "post"
  },
  g53HomePositionX: {
    title      : "G53 home position X",
    description: "G53 X-axis home position.",
    group      : "homePositions",
    type       : "number",
    value      : 24,
    scope      : "post"
  },
  g53HomePositionZ: {
    title      : "G53 home position Z",
    description: "G53 Z-axis home position.",
    group      : "homePositions",
    type       : "number",
    value      : 0,
    scope      : "post"
  },
  transferUseTorque: {
    title      : "Stock-transfer torque control",
    description: "Use torque control for stock transfer.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  looping: {
    title       : "Use M98 looping",
    description : "Output program for M98 looping.",
    group       : "looping",
    type        : "boolean",
    presentation: "yesno",
    value       : false,
    scope       : "post"
  },
  numberOfRepeats: {
    title      : "Number of repeats",
    description: "How many times to loop the program.",
    group      : "looping",
    type       : "integer",
    range      : [0, 99999999],
    value      : 1,
    scope      : "post"
  },
  writeVersion: {
    title      : "Write version",
    description: "Write the version number in the header of the code.",
    group      : "formats",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useRigidTapping: {
    title      : "Use rigid tapping",
    description: "Select 'Yes' to enable, 'No' to disable.",
    group      : "preferences",
    type       : "boolean",
    value      : true,
    scope      : "post"
  },
  useYAxisForDrilling: {
    title      : "Position in Y for axial drilling",
    description: "Positions in Y for axial drilling options when it can instead of using the C-axis.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  },
  useSimpleThread: {
    title      : "Use simple threading cycle",
    description: "Enable to output G92 simple threading cycle, disable to output G76 standard threading cycle.",
    group      : "preferences",
    type       : "boolean",
    value      : false,
    scope      : "post"
  }
};

groupDefinitions = {
  looping: {title:"Looping", collapsed:true, order:25}
};

// wcs definiton
wcsDefinitions = {
  useZeroOffset: false,
  wcs          : [
    {name:"Standard", format:"G", range:[54, 59]}
  ]
};

var singleLineCoolant = false; // specifies to output multiple coolant codes in one line rather than in separate lines
// samples:
// {id: COOLANT_THROUGH_TOOL, on: 88, off: 89}
// {id: COOLANT_THROUGH_TOOL, on: [8, 88], off: [9, 89]}
// {id: COOLANT_THROUGH_TOOL, turret1:{on: [8, 88], off:[9, 89]}, turret2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, spindle1:{on: [8, 88], off:[9, 89]}, spindle2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, spindle1t1:{on: [8, 88], off:[9, 89]}, spindle1t2:{on:88, off:89}}
// {id: COOLANT_THROUGH_TOOL, on: "M88 P3 (myComment)", off: "M89"}
var coolants = [
  {id:COOLANT_FLOOD, on:8, off:9},
  {id:COOLANT_MIST, on:7, off:9},
  {id:COOLANT_THROUGH_TOOL, spindle1:{on:18, off:9}, spindle2:{on:118, off:9}},
  {id:COOLANT_AIR, spindle1:{on:16, off:17}, spindle2:{on:216, off:217}},
  {id:COOLANT_AIR_THROUGH_TOOL},
  {id:COOLANT_SUCTION},
  {id:COOLANT_FLOOD_MIST, on:10, off:9},
  {id:COOLANT_FLOOD_THROUGH_TOOL},
  {id:COOLANT_OFF, off:9}
];

var permittedCommentChars = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,=_-/";

var gFormat = createFormat({prefix:"G", decimals:1});
var mFormat = createFormat({prefix:"M", decimals:1});

var spatialFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var xFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true, scale:2}); // diameter mode & IS SCALING POLAR COORDINATES
var yFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var zFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var rFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true}); // radius
var iFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var abcFormat = createFormat({decimals:3, forceDecimal:true, scale:DEG});
var bFormat = createFormat({prefix:"(B=", suffix:")", decimals:3, forceDecimal:true, scale:DEG});  // TAG: make sure this prefix matches your machine "B-axis"
var cFormat; // defined in onOpen
var feedFormat = createFormat({decimals:(unit == MM ? 2 : 3), forceDecimal:true});
var pitchFormat = createFormat({decimals:6, forceDecimal:true});
var toolFormat = createFormat({decimals:0, width:4, zeropad:true});
var rpmFormat = createFormat({decimals:0});
var secFormat = createFormat({decimals:3, forceDecimal:true}); // seconds - range 0.001-99999.999
var milliFormat = createFormat({decimals:0}); // milliseconds // range 1-9999
var taperFormat = createFormat({decimals:1, scale:DEG});

var threadP1Format = createFormat({decimals:0, forceDecimal:false, trim:false, width:6, zeropad:true});
var threadPQFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
var dwellFormat = createFormat({prefix:"U", decimals:3, forceDecimal:true});

var peckFormat = createFormat({decimals:(unit == MM ? 3 : 4), forceDecimal:true});
// var peckFormat = createFormat({decimals:0, forceDecimal:false, trim:false, width:4, zeropad:true, scale:(unit == MM ? 1000 : 10000)});

var xOutput = createVariable({prefix:"X"}, xFormat);
var yOutput = createVariable({onchange:function() {yAxisIsRetracted = false;}, prefix:"Y"}, yFormat);
var zOutput = createVariable({prefix:"Z"}, zFormat);
var aOutput = createVariable({prefix:"A"}, abcFormat);
var bOutput = createVariable({}, bFormat);
var cOutput; // defined in onOpen
var subOutput = createVariable({prefix:"W", force:true}, spatialFormat);
var feedOutput = createVariable({prefix:"F"}, feedFormat);
var pitchOutput = createVariable({prefix:"F", force:true}, pitchFormat);
var sOutput = createVariable({prefix:"S", force:true}, rpmFormat);
var pOutput = createFormat({prefix:"P", decimals:3, forceDecimal:true});
var rOutput = createVariable({prefix:"R", force:true}, rFormat);
var threadP1Output = createVariable({prefix:"P", force:true}, threadP1Format);
var threadP2Output = createVariable({prefix:"P", force:true}, threadPQFormat);
var threadQOutput = createVariable({prefix:"Q", force:true}, threadPQFormat);
var threadROutput = createVariable({prefix:"R", force:true}, threadPQFormat);

// circular output
var iOutput = createReferenceVariable({prefix:"I", force:true}, iFormat);
var jOutput = createReferenceVariable({prefix:"J", force:true}, spatialFormat);
var kOutput = createReferenceVariable({prefix:"K", force:true}, spatialFormat);

var g92ROutput = createVariable({prefix:"R"}, zFormat); // no scaling
var peckOutput = createVariable({prefix:"Q", force:true}, peckFormat);

var gMotionModal = createModal({}, gFormat); // modal group 1 // G0-G3, ...
var gRadDiamModal = createModal({}, gFormat); // G7-G8
var gPlaneModal = createModal({onchange:function () {gMotionModal.reset();}}, gFormat); // modal group 2 // G17-19
var gFeedModeModal = createModal({}, gFormat); // modal group 5 // G98-99
var gSpindleModeModal = createModal({}, gFormat); // modal group 5 // G96-97
var gSpindleModal = createModal({}, mFormat); // M176/177 SPINDLE MODE
var gUnitModal = createModal({}, gFormat); // modal group 6 // G20-21
var gCycleModal = createModal({}, gFormat); // modal group 9 // G81, ...
//var gPolarModal = createModal({}, gFormat); // G12.1, G13.1
var gMapCodeModal = createModal({}, gFormat); // G101 - G110
var cAxisBrakeModal = createModal({}, mFormat);
var mInterferModal = createModal({}, mFormat);
var tailStockModal = createModal({}, mFormat);
var mCuttingModal = createModal({}, mFormat);

// fixed settings
var firstFeedParameter = 100;

// defined in defineMachine
var gotYAxis;
var yAxisMinimum;
var yAxisMaximum;
var gotSecondarySpindle;

var gotBAxis = false; // B-axis always requires customization to match the machine specific functions for doing rotations
var gotMultiTurret = false; // specifies if the machine has several turrets
var gotPolarInterpolation = true; // specifies if the machine has XY polar interpolation capabilities
var gotDoorControl = false;
var airCleanChuck = false; // use air to clean off chuck at part transfer and part eject

var SPINDLE_MAIN = 0;
var SPINDLE_SUB = 1;
var SPINDLE_LIVE = 2;

var POSX = 0;
var POXY = 1;
var POSZ = 2;
var NEGZ = -2;

var TRANSFER_PHASE = 0;
var TRANSFER_SPEED = 1;
var TRANSFER_STOP = 2;

// getSpindle parameters
var TOOL = false;
var PART = true;

// moveSubSpindle parameters
var HOME = 0;
var RAPID = 1;
var FEED = 2;
var TORQUE = 3;

// mapping modes
var MAP_POLAR = 101;
var MAP_AXIAL = 103;
var MAP_RADIAL = 104;
var MAP_TURNING = 109;
var MAP_POLAR_SUB = 105;
var MAP_AXIAL_SUB = 107;
var MAP_RADIAL_SUB = 108;
var MAP_TURNING_SUB = 110;

// collected state
var sequenceNumber;
var currentWorkOffset;
var currentMapMode;
var previousMapMode;
var optionalSection = false;
var forceSpindleSpeed = false;
var activeMovements; // do not use by default
var currentFeedId;
var previousSpindle = SPINDLE_MAIN;
var activeSpindle = SPINDLE_MAIN;
var partCutoff = false;
var transferUseTorque;
var reverseTap = false;
var showSequenceNumbers;
var forceXZCMode = false; // forces XZC output, activated by Action:useXZCMode
var forcePolarMode = false; // force Polar output, activated by Action:usePolarMode
var tapping = false;
var ejectRoutine = false;
var xAxisMinimum; // specifies the maximum range for the X-axis (RADIUS MODE VALUE)
var bestABCIndex = undefined;
var yAxisIsRetracted = true;
var headOffset = 0;
var previousABC = new Vector(0, 0, 0);

var machineState = {
  liveToolIsActive              : undefined,
  cAxisIsEngaged                : undefined,
  machiningDirection            : undefined,
  mainSpindleIsActive           : undefined,
  subSpindleIsActive            : undefined,
  mainSpindleBrakeIsActive      : undefined,
  subSpindleBrakeIsActive       : undefined,
  tailstockIsActive             : undefined,
  usePolarMode                  : undefined,
  useXZCMode                    : undefined,
  axialCenterDrilling           : undefined,
  currentBAxisOrientationTurning: new Vector(0, 0, 0),
  spindlesAreAttached           : false,
  stockTransferIsActive         : false
};

function getCode(code, spindle) {
  switch (code) {
  case "PART_CATCHER_ON":
    return 58;
  case "PART_CATCHER_OFF":
    return 59;
  case "TAILSTOCK_ON":
    machineState.tailstockIsActive = true;
    return 78;
  case "TAILSTOCK_OFF":
    machineState.tailstockIsActive = false;
    return 79;
  /*
  case "ENABLE_C_AXIS":
    machineState.cAxisIsEngaged = true;
    return (spindle == SPINDLE_MAIN) ? 40 : 40;
  case "DISABLE_C_AXIS":
    machineState.cAxisIsEngaged = false;
    return (spindle == SPINDLE_MAIN) ? 41 : 41;
  */
  case "ENABLE_TURNING":
    return 130;
  case "ENABLE_MILLING":
    return 131;
  case "POLAR_INTERPOLATION_ON": // XYZ Polar Map code
    return (spindle == SPINDLE_MAIN) ? MAP_POLAR : MAP_POLAR_SUB;
  //case "POLAR_INTERPOLATION_OFF":
  //return MAP_TURNING;
  case "ENABLE_Y_AXIS": // XYZ Linear Map Code
    previousMapMode = currentMapMode;
    switch (spindle) {
    case SPINDLE_MAIN:
      currentMapMode = machineState.machiningDirection == MACHINING_DIRECTION_RADIAL ? MAP_RADIAL : MAP_AXIAL;
      return currentMapMode;
    case SPINDLE_SUB:
      currentMapMode = machineState.machiningDirection == MACHINING_DIRECTION_RADIAL ? MAP_RADIAL_SUB : MAP_AXIAL_SUB;
      return currentMapMode;
    }
    break;
  case "LATHE_MAP": // Turning and XZC Axis Map Code
    previousMapMode = currentMapMode;
    switch (spindle) {
    case SPINDLE_MAIN:
      currentMapMode = MAP_TURNING;
      return currentMapMode;
    case SPINDLE_SUB:
      currentMapMode = (getProperty("controllerType") == "v9") ? MAP_TURNING : MAP_TURNING_SUB;
      return currentMapMode;
    }
    break;
  case "STOP_SPINDLE":
    switch (spindle) {
    case SPINDLE_MAIN:
      machineState.mainSpindleIsActive = false;
      return 5;
    case SPINDLE_SUB:
      machineState.subSpindleIsActive = false;
      return 105;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = false;
      return 35;
    }
    break;
  case "ORIENT_SPINDLE":
    return (spindle == SPINDLE_MAIN) ? 19 : 119;
  case "START_SPINDLE_CW":
    switch (spindle) {
    case SPINDLE_MAIN:
      machineState.mainSpindleIsActive = true;
      machineState.subSpindleIsActive = false;
      machineState.liveToolIsActive = false;
      return 3;
    case SPINDLE_SUB:
      machineState.subSpindleIsActive = true;
      machineState.mainSpindleIsActive = false;
      machineState.liveToolIsActive = false;
      return 103;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = true;
      machineState.mainSpindleIsActive = false;
      machineState.subSpindleIsActive = false;
      return 33;
    }
    break;
  case "START_SPINDLE_CCW":
    switch (spindle) {
    case SPINDLE_MAIN:
      machineState.mainSpindleIsActive = true;
      machineState.subSpindleIsActive = false;
      machineState.liveToolIsActive = false;
      return 4;
    case SPINDLE_SUB:
      machineState.subSpindleIsActive = true;
      machineState.mainSpindleIsActive = false;
      machineState.liveToolIsActive = false;
      return 104;
    case SPINDLE_LIVE:
      machineState.liveToolIsActive = true;
      machineState.mainSpindleIsActive = false;
      machineState.subSpindleIsActive = false;
      return 34;
    }
    break;
  case "FEED_MODE_MM_REV":
    return 95;
  case "FEED_MODE_MM_MIN":
    return 94;
  case "CONSTANT_SURFACE_SPEED_ON":
    return 96;
  case "CONSTANT_SURFACE_SPEED_OFF":
    return 97;
  case "LOCK_MULTI_AXIS":
    return (spindle == SPINDLE_MAIN) ? 132 : 232;
  case "UNLOCK_MULTI_AXIS":
    return (spindle == SPINDLE_MAIN) ? 134 : 234;
  case "CLAMP_CHUCK":
    return (spindle == SPINDLE_MAIN) ? 68 : 169;
  case "UNCLAMP_CHUCK":
    return (spindle == SPINDLE_MAIN) ? 69 : 168;
  case "SPINDLE_SYNCHRONIZATION_CW":
    return 203;
  case "SPINDLE_SYNCHRONIZATION_CCW":
    return 204;
  case "SPINDLE_SYNCHRONIZATION_OFF":
    return 205;
  case "ENABLE_OPEN_CHUCK":
    return (spindle == SPINDLE_MAIN) ? 231 : 241;
  case "TORQUE_SKIP_ON":
    return 186;
  case "TORQUE_SKIP_OFF":
    return 187;
  case "RIGID_TAPPING":
    return 29;
    /*
  case "INTERLOCK_BYPASS":
    return (spindle == SPINDLE_MAIN) ? 31 : 131;
*/
    /*
  case "INTERFERENCE_CHECK_OFF":
    return 110;
  case "INTERFERENCE_CHECK_ON":
    return 111;
*/
  case "AIR_BLAST_ON":
    return (spindle == SPINDLE_MAIN) ? 16 : 216;
  case "AIR_BLAST_OFF":
    return (spindle == SPINDLE_MAIN) ? 17 : 217;
  default:
    error(localize("Command " + code + " is not defined."));
    return 0;
  }
  return 0;
}

/** Returns the modulus. */
function getModulus(x, y) {
  return Math.sqrt(x * x + y * y);
}

/**
  Returns the C rotation for the given X and Y coordinates.
*/
function getC(x, y) {
  var direction;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    direction = (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    direction = (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  return Math.atan2(y, x) * direction;
}

/**
  Returns the C rotation for the given X and Y coordinates in the desired rotary direction.
*/
function getCClosest(x, y, _c, clockwise) {
  if (_c == Number.POSITIVE_INFINITY) {
    _c = 0; // undefined
  }
  if (!xFormat.isSignificant(x) && !yFormat.isSignificant(y)) { // keep C if XY is on center
    return _c;
  }
  var c = getC(x, y);
  if (clockwise != undefined) {
    if (clockwise) {
      while (c < _c) {
        c += Math.PI * 2;
      }
    } else {
      while (c > _c) {
        c -= Math.PI * 2;
      }
    }
  } else {
    min = _c - Math.PI;
    max = _c + Math.PI;
    while (c < min) {
      c += Math.PI * 2;
    }
    while (c > max) {
      c -= Math.PI * 2;
    }
  }
  return c;
}

function getCWithinRange(x, y, _c, clockwise) {
  var scale = cFormat.getScale() / Math.abs(cFormat.getScale());
  var c = getCClosest(x, y, _c, clockwise);

  var cyclicLimit;
  var cyclic;
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the U-axis
    cyclicLimit = machineConfiguration.getAxisU().getRange();
    cyclic = machineConfiguration.getAxisU().isCyclic();
  } else if (Vector.dot(machineConfiguration.getAxisV().getAxis(), new Vector(0, 0, 1)) != 0) {
    // C-axis is the V-axis
    cyclicLimit = machineConfiguration.getAxisV().getRange();
    cyclic = machineConfiguration.getAxisV().isCyclic();
  } else {
    error(localize("Unsupported rotary axis direction."));
    return 0;
  }

  // see if rewind is required
  forceRewind = false;
  if (cyclicLimit.isNonRange()) {
    return c;
  }
  if (scale == -1) {  // range needs to be in same orientation as C-axis output
    var limit = cyclicLimit[0];
    cyclicLimit = new Range(cyclicLimit[1] * scale, limit * scale);
  }
  if ((abcFormat.getResultingValue(c) < abcFormat.getResultingValue(cyclicLimit[0])) || (abcFormat.getResultingValue(c) > abcFormat.getResultingValue(cyclicLimit[1]))) {
    if (!cyclic) {
      forceRewind = true;
    }
    var midrange = cyclicLimit[0] == 0 ? Math.PI * 2 : (cyclicLimit[1] == 0 ? -Math.PI * 2 : 0);
    c = getCClosest(x, y, midrange); // find closest C to 0
    if ((abcFormat.getResultingValue(c) < abcFormat.getResultingValue(cyclicLimit[0])) || (abcFormat.getResultingValue(c) > abcFormat.getResultingValue(cyclicLimit[1]))) {
      midrange = cyclicLimit[0] + (cyclicLimit[1] - cyclicLimit[0]) / 2;
      c = getCClosest(x, y, midrange); // find closest C to midRange
    }
    if ((abcFormat.getResultingValue(c) < abcFormat.getResultingValue(cyclicLimit[0])) || (abcFormat.getResultingValue(c) > abcFormat.getResultingValue(cyclicLimit[1]))) {
      error(localize("Unable to find C-axis position within the defined range."));
      return 0;
    }
  }
  return c;
}

/**
  Returns the desired tolerance for the given section.
*/
function getTolerance() {
  var t = tolerance;
  if (hasParameter("operation:tolerance")) {
    if (t > 0) {
      t = Math.min(t, getParameter("operation:tolerance"));
    } else {
      t = getParameter("operation:tolerance");
    }
  }
  return t;
}

function formatSequenceNumber() {
  if (sequenceNumber > 99999) {
    sequenceNumber = getProperty("sequenceNumberStart");
  }
  var seqno = "N" + sequenceNumber;
  sequenceNumber += getProperty("sequenceNumberIncrement");
  return seqno;
}

/**
  Writes the specified block.
*/
function writeBlock() {
  var seqno = "";
  var opskip = "";
  if (showSequenceNumbers == "true") {
    seqno = formatSequenceNumber();
  }
  if (optionalSection) {
    opskip = "/";
  }
  var text = formatWords(arguments);
  if (text) {
    writeWords(opskip, seqno, text);
  }
}

function writeDebug(_text) {
  writeComment("DEBUG - " + _text);
  log("DEBUG - " + _text);
}

function formatComment(text) {
  return "(" + String(filterText(String(text).toUpperCase(), permittedCommentChars)).replace(/[()]/g, "") + ")";
}

/**
  Output a comment.
*/
function writeComment(text) {
  writeln(formatComment(text));
}

function getB(abc, section) {
  if (section.spindle == SPINDLE_PRIMARY) {
    return abc.y;
  } else {
    return Math.PI - abc.y;
  }
}

function writeCommentSeqno(text) {
  writeln(formatSequenceNumber() + formatComment(text));
}

function defineMachine() {
  if (modelType == "TMX10MYS") {
    gotYAxis = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -55 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 55 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = true;
  } else if (modelType == "TMX10MY") {
    gotYAxis = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -55 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 55 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = false;
  } else if (modelType == "TMX8MYS") {
    gotYAxis = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -55 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 55 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = true;
  } else if (modelType == "TMX8MY") {
    gotYAxis = true;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -55 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 55 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = false;
  } else if (modelType == "TMM10") {
    gotYAxis = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -0 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 0 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = false;
  } else if (modelType == "TMM8") {
    gotYAxis = false;
    yAxisMinimum = toPreciseUnit(gotYAxis ? -0 : 0, MM); // specifies the minimum range for the Y-axis
    yAxisMaximum = toPreciseUnit(gotYAxis ? 0 : 0, MM); // specifies the maximum range for the Y-axis
    gotSecondarySpindle = false;
  }
}

var machineConfigurationMainSpindle;
var machineConfigurationSubSpindle;

function onOpen() {
  // define machine
  defineMachine();

  if (getProperty("useRadius")) {
    maximumCircularSweep = toRad(90); // avoid potential center calculation errors for CNC
  }

  // Copy certain properties into global variables
  xAxisMinimum = getProperty("xAxisMinimum");
  showSequenceNumbers = getProperty("showSequenceNumbers");
  transferUseTorque = getProperty("transferUseTorque");

  if (true) {
    var bAxisMain = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[-0.001, 90.001], preference:0});
    var bAxisSub = createAxis({coordinate:1, table:false, axis:[0, -1, 0], range:[-0.001, 180.001], preference:0});
    if (getProperty("controllerType") == "v9") {
      cFormat = createFormat({decimals:3, scale:DEG, cyclicLimit:Math.PI * 2, cyclicSign:1});
      cOutput = createVariable({prefix:"C"}, cFormat);
      var cAxisMain = createAxis({coordinate:2, table:true, axis:[0, 0, -1], cyclic:true, preference:1}); // C axis is modal between primary and secondary spindle
      var cAxisSub = createAxis({coordinate:2, table:true, axis:[0, 0, -1], cyclic:true, preference:1}); // C axis is modal between primary and secondary spindle
    } else {
      cFormat = createFormat({decimals:3, scale:DEG});
      cOutput = createVariable({prefix:"C"}, cFormat);
      var cAxisMain = createAxis({coordinate:2, table:true, axis:[0, 0, 1], range:[0, 36000], cyclic:false, preference:1, reset:1}); // C axis is modal between primary and secondary spindle
      var cAxisSub = createAxis({coordinate:2, table:true, axis:[0, 0, 1], range:[0, 36000], cyclic:false, preference:1, reset:1}); // C axis is modal between primary and secondary spindle
    }

    machineConfigurationMainSpindle = gotBAxis ? new MachineConfiguration(bAxisMain, cAxisMain) : new MachineConfiguration(cAxisMain);
    machineConfigurationSubSpindle =  gotBAxis ? new MachineConfiguration(bAxisSub, cAxisSub) : new MachineConfiguration(cAxisSub);
  }

  machineConfiguration = new MachineConfiguration(); // creates an empty configuration to be able to set eg vendor information

  machineConfiguration.setVendor("Hurco");
  machineConfiguration.setModel(modelType);

  yOutput.disable();

  aOutput.disable();
  if (!gotBAxis) {
    bOutput.disable();
  }

  if (highFeedrate <= 0) {
    error(localize("You must set 'highFeedrate' because axes are not synchronized for rapid traversal."));
    return;
  }

  if (getProperty("safePositionMethod") == "G28" && getProperty("controllerType") != "v11") {
    error(localize("G28 Safe Retracts option is only allowed with v11 controller."));
  }

  if (!getProperty("separateWordsWithSpace")) {
    setWordSeparator("");
  }

  sequenceNumber = getProperty("sequenceNumberStart");
  writeln("%");

  if (programName) {
    var programId;
    try {
      programId = getAsInt(programName);
    } catch (e) {
      error(localize("Program name must be a number."));
      return;
    }
    if (!((programId >= 1) && (programId <= 9999))) {
      error(localize("Program number is out of range."));
      return;
    }
    var oFormat = createFormat({width:4, zeropad:true, decimals:0});
    if (programComment) {
      writeln("O" + oFormat.format(programId) + " (" + filterText(String(programComment).toUpperCase(), permittedCommentChars) + ")");
    } else {
      writeln("O" + oFormat.format(programId));
    }
  } else {
    error(localize("Program name has not been specified."));
    return;
  }

  if (getProperty("writeVersion")) {
    if ((typeof getHeaderVersion == "function") && getHeaderVersion()) {
      writeComment(localize("post version") + ": " + getHeaderVersion());
    }
    if ((typeof getHeaderDate == "function") && getHeaderDate()) {
      writeComment(localize("post modified") + ": " + getHeaderDate());
    }
  }

  // dump machine configuration
  var vendor = machineConfiguration.getVendor();
  var model = machineConfiguration.getModel();
  var description = machineConfiguration.getDescription();

  if (getProperty("writeMachine") && (vendor || model || description)) {
    writeComment(localize("Machine"));
    if (vendor) {
      writeComment("  " + localize("vendor") + ": " + vendor);
    }
    if (model) {
      writeComment("  " + localize("model") + ": " + model);
    }
    if (description) {
      writeComment("  " + localize("description") + ": "  + description);
    }
  }

  // dump tool information
  if (getProperty("writeTools")) {
    var zRanges = {};
    if (is3D()) {
      var numberOfSections = getNumberOfSections();
      for (var i = 0; i < numberOfSections; ++i) {
        var section = getSection(i);
        var zRange = section.getGlobalZRange();
        var tool = section.getTool();
        if (zRanges[tool.number]) {
          zRanges[tool.number].expandToRange(zRange);
        } else {
          zRanges[tool.number] = zRange;
        }
      }
    }

    var tools = getToolTable();
    if (tools.getNumberOfTools() > 0) {
      for (var i = 0; i < tools.getNumberOfTools(); ++i) {
        var tool = tools.getTool(i);
        var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
        var comment = "T" + toolFormat.format(tool.number * 100 + compensationOffset % 100) + " " +
          (tool.diameter != 0 ? "D=" + spatialFormat.format(tool.diameter) + " " : "") +
          (tool.isTurningTool() ? localize("NR") + "=" + spatialFormat.format(tool.noseRadius) : localize("CR") + "=" + spatialFormat.format(tool.cornerRadius)) +
          (tool.taperAngle > 0 && (tool.taperAngle < Math.PI) ? " " + localize("TAPER") + "=" + taperFormat.format(tool.taperAngle) + localize("deg") : "") +
          (zRanges[tool.number] ? " - " + localize("ZMIN") + "=" + spatialFormat.format(zRanges[tool.number].getMinimum()) : "") +
          " - " + localize(getToolTypeName(tool.type));
        writeComment(comment);
      }
    }
  }

  if (false) {
    // check for duplicate tool number
    for (var i = 0; i < getNumberOfSections(); ++i) {
      var sectioni = getSection(i);
      var tooli = sectioni.getTool();
      for (var j = i + 1; j < getNumberOfSections(); ++j) {
        var sectionj = getSection(j);
        var toolj = sectionj.getTool();
        if (tooli.number == toolj.number) {
          if (spatialFormat.areDifferent(tooli.diameter, toolj.diameter) ||
              spatialFormat.areDifferent(tooli.cornerRadius, toolj.cornerRadius) ||
              abcFormat.areDifferent(tooli.taperAngle, toolj.taperAngle) ||
              (tooli.numberOfFlutes != toolj.numberOfFlutes)) {
            error(
              subst(
                localize("Using the same tool number for different cutter geometry for operation '%1' and '%2'."),
                sectioni.hasParameter("operation-comment") ? sectioni.getParameter("operation-comment") : ("#" + (i + 1)),
                sectionj.hasParameter("operation-comment") ? sectionj.getParameter("operation-comment") : ("#" + (j + 1))
              )
            );
            return;
          }
        }
      }
    }
  }

  // support program looping for bar work
  if (getProperty("looping")) {
    if (getProperty("numberOfRepeats") < 1) {
      error(localize("numberOfRepeats must be greater than 0."));
      return;
    }

    writeln("");
    writeln("");
    writeComment(localize("Local Looping"));
    writeln("");
    writeBlock(mFormat.format(98), "O" + getProperty("numberOfRepeats") + oFormat.format(programId + 1));
    writeBlock(mFormat.format(30));
    writeln("");
    writeln("");
    writeln("O" + oFormat.format(programId + 1) + " (START MAIN PROGRAM)");
  }

  if (getProperty("safePositionMethod") == "G53") {
    var minRetract = toPreciseUnit(16, IN);
    if (getProperty("g53HomePositionX") < minRetract) {
      error(subst(localize("G53 home position X must be at least %1"), minRetract) +
      (unit == IN ? "in." : "mm."));
      return;
    }
    writeBlock("#500=" + spatialFormat.format(getProperty("g53HomePositionX")), "(PARAMETER FOR X TOOL CHANGE POSITION)");
    writeBlock("#501=" + spatialFormat.format(getProperty("g53HomePositionZ")), "(PARAMETER FOR Z TOOL CHANGE POSITION)");
  }

  switch (unit) {
  case IN:
    writeBlock(gUnitModal.format(20));
    break;
  case MM:
    writeBlock(gUnitModal.format(21));
    break;
  }

  writeBlock(gFormat.format(90), gFormat.format(40), gCycleModal.format(80));
  onCommand(COMMAND_CLOSE_DOOR);

  if (getProperty("gotChipConveyor")) {
    onCommand(COMMAND_START_CHIP_TRANSPORT);
  }

  // automatically eject part at end of program
  if (getProperty("autoEject")) {
    ejectRoutine = true;
  }
}

function onComment(message) {
  writeComment(message);
}

/** Force output of X, Y, and Z. */
function forceXYZ() {
  xOutput.reset();
  yOutput.reset();
  zOutput.reset();
}

/** Force output of A, B, and C. */
function forceABC() {
  aOutput.reset();
  bOutput.reset();
  cOutput.reset();
}

function forceFeed() {
  currentFeedId = undefined;
  previousDPMFeed = 0;
  feedOutput.reset();
}

/** Force output of X, Y, Z, A, B, C, and F on next output. */
function forceAny() {
  forceXYZ();
  forceABC();
  forceFeed();
}

function forceUnlockMultiAxis() {
  cAxisBrakeModal.reset();
}

function FeedContext(id, description, feed) {
  this.id = id;
  this.description = description;
  this.feed = feed;
}

function getFeed(f) {
  if (activeMovements) {
    var feedContext = activeMovements[movement];
    if (feedContext != undefined) {
      if (!feedFormat.areDifferent(feedContext.feed, f)) {
        if (feedContext.id == currentFeedId) {
          return ""; // nothing has changed
        }
        forceFeed();
        currentFeedId = feedContext.id;
        return "F#" + (firstFeedParameter + feedContext.id);
      }
    }
    currentFeedId = undefined; // force Q feed next time
  }
  return feedOutput.format(f); // use feed value
}

function initializeActiveFeeds() {
  activeMovements = new Array();
  var movements = currentSection.getMovements();
  var feedPerRev = currentSection.feedMode == FEED_PER_REVOLUTION;

  var id = 0;
  var activeFeeds = new Array();
  if (hasParameter("operation:tool_feedCutting")) {
    if (movements & ((1 << MOVEMENT_CUTTING) | (1 << MOVEMENT_LINK_TRANSITION) | (1 << MOVEMENT_EXTENDED))) {
      var feedContext = new FeedContext(id, localize("Cutting"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_CUTTING] = feedContext;
      if (!hasParameter("operation:tool_feedTransition")) {
        activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
      }
      activeMovements[MOVEMENT_EXTENDED] = feedContext;
    }
    ++id;
    if (movements & (1 << MOVEMENT_PREDRILL)) {
      feedContext = new FeedContext(id, localize("Predrilling"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeMovements[MOVEMENT_PREDRILL] = feedContext;
      activeFeeds.push(feedContext);
    }
    ++id;
  }

  if (hasParameter("operation:finishFeedrate")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var finishFeedrateRel;
      if (hasParameter("operation:finishFeedrateRel")) {
        finishFeedrateRel = getParameter("operation:finishFeedrateRel");
      } else if (hasParameter("operation:finishFeedratePerRevolution")) {
        finishFeedrateRel = getParameter("operation:finishFeedratePerRevolution");
      }
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? finishFeedrateRel : getParameter("operation:finishFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting")) {
    if (movements & (1 << MOVEMENT_FINISH_CUTTING)) {
      var feedContext = new FeedContext(id, localize("Finish"), feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_FINISH_CUTTING] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedEntry")) {
    if (movements & (1 << MOVEMENT_LEAD_IN)) {
      var feedContext = new FeedContext(id, localize("Entry"), feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_IN] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LEAD_OUT)) {
      var feedContext = new FeedContext(id, localize("Exit"), feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LEAD_OUT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:noEngagementFeedrate")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(id, localize("Direct"), feedPerRev ? getParameter("operation:noEngagementFeedrateRel") : getParameter("operation:noEngagementFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  } else if (hasParameter("operation:tool_feedCutting") &&
             hasParameter("operation:tool_feedEntry") &&
             hasParameter("operation:tool_feedExit")) {
    if (movements & (1 << MOVEMENT_LINK_DIRECT)) {
      var feedContext = new FeedContext(
        id,
        localize("Direct"),
        Math.max(
          feedPerRev ? getParameter("operation:tool_feedCuttingRel") : getParameter("operation:tool_feedCutting"),
          feedPerRev ? getParameter("operation:tool_feedEntryRel") : getParameter("operation:tool_feedEntry"),
          feedPerRev ? getParameter("operation:tool_feedExitRel") : getParameter("operation:tool_feedExit")
        )
      );
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_DIRECT] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:reducedFeedrate")) {
    if (movements & (1 << MOVEMENT_REDUCED)) {
      var feedContext = new FeedContext(id, localize("Reduced"), feedPerRev ? getParameter("operation:reducedFeedrateRel") : getParameter("operation:reducedFeedrate"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_REDUCED] = feedContext;
    }
    ++id;
  }

  if (hasParameter("operation:tool_feedRamp")) {
    if (movements & ((1 << MOVEMENT_RAMP) | (1 << MOVEMENT_RAMP_HELIX) | (1 << MOVEMENT_RAMP_PROFILE) | (1 << MOVEMENT_RAMP_ZIG_ZAG))) {
      var feedContext = new FeedContext(id, localize("Ramping"), feedPerRev ? getParameter("operation:tool_feedRampRel") : getParameter("operation:tool_feedRamp"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_RAMP] = feedContext;
      activeMovements[MOVEMENT_RAMP_HELIX] = feedContext;
      activeMovements[MOVEMENT_RAMP_PROFILE] = feedContext;
      activeMovements[MOVEMENT_RAMP_ZIG_ZAG] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedPlunge")) {
    if (movements & (1 << MOVEMENT_PLUNGE)) {
      var feedContext = new FeedContext(id, localize("Plunge"), feedPerRev ? getParameter("operation:tool_feedPlungeRel") : getParameter("operation:tool_feedPlunge"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_PLUNGE] = feedContext;
    }
    ++id;
  }
  if (true) { // high feed
    if ((movements & (1 << MOVEMENT_HIGH_FEED)) || (highFeedMapping != HIGH_FEED_NO_MAPPING)) {
      var feed;
      if (hasParameter("operation:highFeedrateMode") && getParameter("operation:highFeedrateMode") != "disabled") {
        feed = getParameter("operation:highFeedrate");
      } else {
        feed = this.highFeedrate;
      }
      var feedContext = new FeedContext(id, localize("High Feed"), feed);
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_HIGH_FEED] = feedContext;
      activeMovements[MOVEMENT_RAPID] = feedContext;
    }
    ++id;
  }
  if (hasParameter("operation:tool_feedTransition")) {
    if (movements & (1 << MOVEMENT_LINK_TRANSITION)) {
      var feedContext = new FeedContext(id, localize("Transition"), getParameter("operation:tool_feedTransition"));
      activeFeeds.push(feedContext);
      activeMovements[MOVEMENT_LINK_TRANSITION] = feedContext;
    }
    ++id;
  }

  for (var i = 0; i < activeFeeds.length; ++i) {
    var feedContext = activeFeeds[i];
    writeBlock("#" + (firstFeedParameter + feedContext.id) + "=" + feedFormat.format(feedContext.feed), formatComment(feedContext.description));
  }
}

var currentWorkPlaneABC = undefined;

function forceWorkPlane() {
  currentWorkPlaneABC = undefined;
}

function setWorkPlane(abc) {
  // milling only

  if (!machineConfiguration.isMultiAxisConfiguration()) {
    return; // ignore
  }

  if (!((currentWorkPlaneABC == undefined) ||
        abcFormat.areDifferent(abc.x, currentWorkPlaneABC.x) ||
        abcFormat.areDifferent(abc.y, currentWorkPlaneABC.y) ||
        abcFormat.areDifferent(abc.z, currentWorkPlaneABC.z))) {
    return; // no change
  }

  setYAxisMode(false); // Must be in a C axis mode
  gPlaneModal.reset();
  writeBlock(
    gMotionModal.format(0),
    conditional(machineConfiguration.isMachineCoordinate(0), aOutput.format(abc.x)),
    conditional(machineConfiguration.isMachineCoordinate(1), bOutput.format(abc.y)),
    conditional(machineConfiguration.isMachineCoordinate(2), cOutput.format(abc.z))
  );

  currentWorkPlaneABC = abc;
  previousABC = abc;
}

function getBestABCIndex(section) {
  var fitFlag = false;
  var index = undefined;
  for (var i = 0; i < 6; ++i) {
    fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
    if (fitFlag) {
      index = i;
      break;
    }
  }
  return index;
}

function getBestABC(section, workPlane, which) {
  var W = workPlane;
  var abc = machineConfiguration.getABC(W);
  if (which == undefined) { // turning, XZC, Polar modes
    return abc;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    var axis = machineConfiguration.getAxisU(); // C-axis is the U-axis
  } else {
    var axis = machineConfiguration.getAxisV(); // C-axis is the V-axis
  }
  if (axis.isEnabled() && axis.isTable()) {
    var ix = axis.getCoordinate();
    var rotAxis = axis.getAxis();
    if (isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ||
        isSameDirection(machineConfiguration.getDirection(abc), Vector.product(rotAxis, -1))) {
      var direction = isSameDirection(machineConfiguration.getDirection(abc), rotAxis) ? 1 : -1;
      var box = section.getGlobalBoundingBox();
      switch (which) {
      case 1:
        x = box.lower.x + ((box.upper.x - box.lower.x) / 2);
        y = box.lower.y + ((box.upper.y - box.lower.y) / 2);
        break;
      case 2:
        x = box.lower.x;
        y = box.lower.y;
        break;
      case 3:
        x = box.upper.x;
        y = box.lower.y;
        break;
      case 4:
        x = box.upper.x;
        y = box.upper.y;
        break;
      case 5:
        x = box.lower.x;
        y = box.upper.y;
        break;
      default:
        var R = machineConfiguration.getRemainingOrientation(abc, W);
        x = R.right.x;
        y = R.right.y;
        break;
      }
      abc.setCoordinate(ix, getCWithinRange(x, y, previousABC.z));
    }
  }
  return abc;
}

var closestABC = false; // choose closest machine angles
var currentMachineABC;

function getWorkPlaneMachineABC(section, workPlane) {
  var W = workPlane; // map to global frame

  var abc;
  if (machineState.isTurningOperation && gotBAxis) {
    var both = machineConfiguration.getABCByDirectionBoth(workPlane.forward);
    abc = both[0];
    if (both[0].z != 0) {
      abc = both[1];
    }
  } else {
    abc = getBestABC(section, workPlane, bestABCIndex);
    if (closestABC) {
      if (currentMachineABC) {
        abc = machineConfiguration.remapToABC(abc, currentMachineABC);
      } else {
        abc = machineConfiguration.getPreferredABC(abc);
      }
    } else {
      abc = machineConfiguration.getPreferredABC(abc);
    }
  }

  try {
    abc = machineConfiguration.remapABC(abc);
    currentMachineABC = abc;
  } catch (e) {
    error(
      localize("Machine angles not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " " + bFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + cFormat.format(abc.z))
    );
    return abc;
  }

  var direction = machineConfiguration.getDirection(abc);
  if (!isSameDirection(direction, W.forward)) {
    error(localize("Orientation not supported."));
    return abc;
  }

  if (machineState.isTurningOperation && gotBAxis) { // remapABC can change the B-axis orientation
    if (abc.z != 0) {
      error(localize("Could not calculate a B-axis turning angle within the range of the machine."));
      return abc;
    }
  }

  if (!machineConfiguration.isABCSupported(abc)) {
    error(
      localize("Work plane is not supported") + ":"
      + conditional(machineConfiguration.isMachineCoordinate(0), " A" + abcFormat.format(abc.x))
      + conditional(machineConfiguration.isMachineCoordinate(1), " " + bFormat.format(abc.y))
      + conditional(machineConfiguration.isMachineCoordinate(2), " C" + cFormat.format(abc.z))
    );
    return abc;
  }

  var tcp = false;
  if (tcp) {
    setRotation(W); // TCP mode
  } else {
    var O = machineConfiguration.getOrientation(abc);
    var R = machineConfiguration.getRemainingOrientation(abc, W);
    if (isSameDirection(machineConfiguration.getSpindleAxis().abs, new Vector(1, 0, 0)) && gotYAxis) {
      R = R.multiply(Matrix.getYRotation(toRad(90)));
    }
    setRotation(R);
  }

  return abc;
}

function getBAxisOrientationTurning(section) {
  // THIS CODE IS NOT TESTED.
  var toolAngle = hasParameter("operation:tool_angle") ? getParameter("operation:tool_angle") : 0;
  var toolOrientation = section.toolOrientation;
  if (toolAngle && toolOrientation != 0) {
    error(localize("You cannot use tool angle and tool orientation together in operation " + "\"" + (getParameter("operation-comment")) + "\""));
  }

  var angle = toRad(toolAngle) + toolOrientation;

  var axis = new Vector(0, 1, 0);
  var mappedAngle = (currentSection.spindle == SPINDLE_PRIMARY ? (Math.PI / 2 - angle) : (Math.PI / 2 - angle));
  var mappedWorkplane = new Matrix(axis, mappedAngle);
  var abc = getWorkPlaneMachineABC(section, mappedWorkplane);

  return abc;
}

function getSpindle(partSpindle) {
  // safety conditions
  if (getNumberOfSections() == 0) {
    return SPINDLE_MAIN;
  }
  if (getCurrentSectionId() < 0) {
    if (machineState.liveToolIsActive && !partSpindle) {
      return SPINDLE_LIVE;
    } else {
      return getSection(getNumberOfSections() - 1).spindle;
    }
  }

  // Turning is active or calling routine requested which spindle part is loaded into
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || partSpindle) {
    return currentSection.spindle;
  //Milling is active
  } else {
    return SPINDLE_LIVE;
  }
}

function getSecondarySpindle() {
  var spindle = getSpindle(PART);
  return (spindle == SPINDLE_MAIN) ? SPINDLE_SUB : SPINDLE_MAIN;
}

/** Invert YZC axes as required. */
function invertAxes(activate, resetAxes) {
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || resetAxes) { // turning mode
    yFormat.setScale(activate ? -1 : 1);
    zFormat.setScale(activate ? -1 : 1);
    iFormat.setScale(1);
  } else { // milling
    if (machineState.machiningDirection != MACHINING_DIRECTION_RADIAL || currentSection.isMultiAxis() || !gotYAxis) { // Axial tools
      yFormat.setScale(activate ? -1 : 1);
      zFormat.setScale(activate ? -1 : 1);
      iFormat.setScale(1);
    } else { // Radial tools
      yFormat.setScale(activate ? 1 : -1);
      zFormat.setScale(1);
      iFormat.setScale(activate ? 1 : -1);
    }
  }
  cFormat.setScale(DEG * (activate ? -1 : 1));
  if (getProperty("controllerType") == "v9") {
    cFormat.setCyclicMapping(cFormat.getCyclicLimit(), activate ? -1 : 1);
  }

  // Create variables
  yOutput = createVariable({prefix:"Y"}, yFormat);
  zOutput = createVariable({prefix:"Z"}, zFormat);
  cOutput = createVariable({prefix:"C"}, cFormat);
  iOutput = createReferenceVariable({prefix:"I", force:true}, iFormat);
  jOutput = createReferenceVariable({prefix:"J", force:true}, yFormat);
  kOutput = createReferenceVariable({prefix:"K", force:true}, zFormat);
  if (!gotYAxis || !yAxisIsEnabled) {
    yOutput.disable();
  }
}

/** determines if the axes in the given plane are mirrored */
function isMirrored(plane) {
  plane = plane == -1 ? getCompensationPlane(previousABC, false, false) : plane;
  switch (plane) {
  case PLANE_XY:
    if ((xFormat.getScale() * yFormat.getScale()) < 0) {
      return true;
    }
    break;
  case PLANE_YZ:
    if ((yFormat.getScale() * zFormat.getScale()) < 0) {
      return true;
    }
    break;
  case PLANE_ZX:
    if ((zFormat.getScale() * xFormat.getScale()) < 0) {
      return true;
    }
    break;
  }
  return false;
}

function isPerpto(a, b) {
  return Math.abs(Vector.dot(a, b)) < (1e-7);
}

function setSpindleOrientationTurning(section) {
  var J; // cutter orientation
  var R; // cutting quadrant
  var leftHandTool = (hasParameter("operation:tool_hand") && (getParameter("operation:tool_hand") == "L" || getParameter("operation:tool_holderType") == 0));
  if (hasParameter("operation:machineInside")) {
    if (getParameter("operation:machineInside") == 0) {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 3 : 4;
    } else {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 2 : 1;
    }
  } else {
    if ((hasParameter("operation-strategy") && getParameter("operation-strategy") == "turningFace") ||
      (hasParameter("operation-strategy") && getParameter("operation-strategy") == "turningPart")) {
      R = (currentSection.spindle == SPINDLE_PRIMARY) ? 3 : 4;
    } else {
      error(subst(localize("Failed to identify spindle orientation for operation \"%1\"."), getOperationComment()));
      return;
    }
  }
  if (leftHandTool) {
    J = (currentSection.spindle == SPINDLE_PRIMARY) ? 2 : 1;
  } else {
    J = (currentSection.spindle == SPINDLE_PRIMARY) ? 1 : 2;
  }
  writeComment("Post processor is not customized, add code for cutter orientation and cutting quadrant here if needed.");
}

var bAxisOrientationTurning = new Vector(0, 0, 0);

function onSection() {
  // Detect machine configuration
  machineConfiguration = (currentSection.spindle == SPINDLE_PRIMARY) ? machineConfigurationMainSpindle : machineConfigurationSubSpindle;
  if (!gotBAxis) {
    if ((getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) && !currentSection.isMultiAxis()) {
      machineConfiguration.setSpindleAxis(new Vector(0, 0, 1));
    } else {
      machineConfiguration.setSpindleAxis(new Vector(1, 0, 0));
    }
  } else {
    machineConfiguration.setSpindleAxis(new Vector(0, 0, 1)); // set the spindle axis depending on B0 orientation
  }

  // retract / reconfigure
  var performRewinds = !machineConfiguration.getAxisU().isCyclic(); // set to true to enable the rewind/reconfigure logic
  if (performRewinds) {
    machineConfiguration.enableMachineRewinds(); // enables the retract/reconfigure logic
    safeRetractDistance = (unit == IN) ? 1 : 25; // additional distance to retract out of stock, can be overridden with a property
    safeRetractFeed = (unit == IN) ? 20 : 500; // retract feed rate
    safePlungeFeed = (unit == IN) ? 10 : 250; // plunge feed rate
    machineConfiguration.setSafeRetractDistance(safeRetractDistance);
    machineConfiguration.setSafeRetractFeedrate(safeRetractFeed);
    machineConfiguration.setSafePlungeFeedrate(safePlungeFeed);
    var stockExpansion = new Vector(toPreciseUnit(0.1, IN), toPreciseUnit(0.1, IN), toPreciseUnit(0.1, IN)); // expand stock XYZ values
    machineConfiguration.setRewindStockExpansion(stockExpansion);
  }

  setMachineConfiguration(machineConfiguration);
  currentSection.optimizeMachineAnglesByMachine(machineConfiguration, 1); // map tip mode

  // Define Machining modes
  tapping = hasParameter("operation:cycleType") &&
    ((getParameter("operation:cycleType") == "tapping") ||
     (getParameter("operation:cycleType") == "right-tapping") ||
     (getParameter("operation:cycleType") == "left-tapping") ||
     (getParameter("operation:cycleType") == "tapping-with-chip-breaking"));

  var forceToolAndRetract = optionalSection && !currentSection.isOptional();
  optionalSection = currentSection.isOptional();
  bestABCIndex = undefined;

  machineState.isTurningOperation = (currentSection.getType() == TYPE_TURNING);
  if (machineState.isTurningOperation && gotBAxis) {
    bAxisOrientationTurning = getBAxisOrientationTurning(currentSection);
  }
  var insertToolCall = forceToolAndRetract || isFirstSection() ||
    currentSection.getForceToolChange && currentSection.getForceToolChange() ||
    (tool.number != getPreviousSection().getTool().number) ||
    (tool.compensationOffset != getPreviousSection().getTool().compensationOffset) ||
    (tool.diameterOffset != getPreviousSection().getTool().diameterOffset) ||
    (tool.lengthOffset != getPreviousSection().getTool().lengthOffset);

  var retracted = false; // specifies that the tool has been retracted to the safe plane

  var newWorkOffset = isFirstSection() ||
    (getPreviousSection().workOffset != currentSection.workOffset); // work offset changes
  var newWorkPlane = isFirstSection() ||
    !isSameDirection(getPreviousSection().getGlobalFinalToolAxis(), currentSection.getGlobalInitialToolAxis()) ||
    (machineState.isTurningOperation &&
      abcFormat.areDifferent(bAxisOrientationTurning.x, machineState.currentBAxisOrientationTurning.x) ||
      abcFormat.areDifferent(bAxisOrientationTurning.y, machineState.currentBAxisOrientationTurning.y) ||
      abcFormat.areDifferent(bAxisOrientationTurning.z, machineState.currentBAxisOrientationTurning.z));

  partCutoff = hasParameter("operation-strategy") &&
    (getParameter("operation-strategy") == "turningPart");

  updateMachiningMode(currentSection); // sets the needed machining mode to machineState (usePolarMode, useXZCMode, axialCenterDrilling)

  // Get the active spindle
  var newSpindle = true;
  var tempSpindle = getSpindle(TOOL);
  if (isFirstSection()) {
    previousSpindle = tempSpindle;
    goHome(false);
  }
  newSpindle = tempSpindle != previousSpindle;

  headOffset = tool.getBodyLength();
  // End the previous section if a new tool is selected
  if (!isFirstSection() && insertToolCall &&
      !(machineState.stockTransferIsActive && partCutoff)) {
    onCommand(COMMAND_COOLANT_OFF);
    if (machineState.stockTransferIsActive) {
      // writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF", getSpindle(PART))));
    } else {
      if (previousSpindle == SPINDLE_LIVE) {
        onCommand(COMMAND_STOP_SPINDLE);
      } else {
        // Stop the spindle
        if (newSpindle) {
          onCommand(COMMAND_STOP_SPINDLE);
        }
      }
    }
    goHome(false);
    setYAxisMode(false);
    if (getProperty("optionalStop")) {
      onCommand(COMMAND_OPTIONAL_STOP);
      gMotionModal.reset();
    }
  }
  // Consider part cutoff as stockTransfer operation
  if (!(machineState.stockTransferIsActive && partCutoff)) {
    machineState.stockTransferIsActive = false;
  }

  // Output the operation description
  writeln("");
  if (hasParameter("operation-comment")) {
    var comment = getParameter("operation-comment");
    if (comment) {
      if (insertToolCall && getProperty("showSequenceNumbers") == "toolChange") {
        writeCommentSeqno(comment);
      } else {
        writeComment(comment);
      }
    }
  }

  // invert axes as required
  if (getSpindle(PART) == SPINDLE_SUB || machineState.machiningDirection == MACHINING_DIRECTION_RADIAL) {
    invertAxes(getSpindle(PART) == SPINDLE_SUB, false);
  }

  if (insertToolCall) {
    goHome(true);
  }

  // Setup WCS code
  if ((currentSection.workOffset != currentWorkOffset) || insertToolCall) {
    writeBlock(currentSection.wcs);
    currentWorkOffset = currentSection.workOffset;
  }

  if (insertToolCall) {
    retracted = true;
    onCommand(COMMAND_COOLANT_OFF);

    /** Handle multiple turrets. */
    if (gotMultiTurret) {
      var activeTurret = tool.turret;
      if (activeTurret == 0) {
        warning(localize("Turret has not been specified. Using Turret 1 as default."));
        activeTurret = 1; // upper turret as default
      }
      switch (activeTurret) {
      case 1:
        // add specific handling for turret 1
        break;
      case 2:
        // add specific handling for turret 2
        break;
      default:
        error(localize("Turret is not supported."));
        return;
      }
    }

    var compensationOffset = tool.isTurningTool() ? tool.compensationOffset : tool.lengthOffset;
    if (compensationOffset > 99) {
      error(localize("Compensation offset is out of range."));
      return;
    }

    if (tool.number > getProperty("maxTool")) {
      warning(localize("Tool number exceeds maximum value."));
    }

    if (tool.number == 0) {
      error(localize("Tool number cannot be 0"));
      return;
    }

    gMotionModal.reset();
    writeBlock("T" + toolFormat.format(tool.number * 100 + compensationOffset));
    if (tool.comment) {
      writeComment(tool.comment);
    }

    if (gotSecondarySpindle) {
      if (getSpindle(PART) == SPINDLE_SUB) {
        moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
      }
    }
    gMapCodeModal.reset();
    if (gotYAxis) {
      // To move tool if there is a Y offset
      setYAxisMode(true, false);
      yOutput.reset();
      gMotionModal.reset();
      writeBlock(gMotionModal.format(0), yOutput.format(0));
    }
    setYAxisMode(false);
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      mCuttingModal.reset();
      writeBlock(mCuttingModal.format(getCode("ENABLE_TURNING")));
    }
    gPlaneModal.reset();
  }
  if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
    setRadiusDiameterMode("diameter", insertToolCall);
    previousABC = new Vector(0, 0, 0); // Reset C angle when turning
  } else { // milling
    setRadiusDiameterMode("radius", insertToolCall);
  }

  // Get active feedrate mode
  if (insertToolCall) {
    gFeedModeModal.reset();
    mCuttingModal.reset();
  }
  // Live Spindle is active
  if (tempSpindle == SPINDLE_LIVE) {
    switch (getMachiningDirection(currentSection)) {
    case MACHINING_DIRECTION_AXIAL:
      break;
    case MACHINING_DIRECTION_RADIAL:
      break;
    case MACHINING_DIRECTION_INDEXING:
      break;
    default:
      error(subst(localize("Unsupported machining direction for operation " + "\"" + "%1" + "\"" + "."), getOperationComment()));
      return;
    }
    if (insertToolCall) {
      writeBlock(mCuttingModal.format(getCode("ENABLE_MILLING", getSpindle(PART))));
      cOutput.reset();
    }
  }

  if (getProperty("usePartCatcher") && partCutoff && currentSection.partCatcher) {
    gFeedModeModal.reset();
  }
  var feedMode;
  if ((currentSection.feedMode == FEED_PER_REVOLUTION) || tapping) {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_REV", getSpindle(TOOL)));
  } else {
    feedMode = gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL)));
  }
  writeBlock(feedMode);

  // Write out notes
  if (getProperty("showNotes") && hasParameter("notes")) {
    var notes = getParameter("notes");
    if (notes) {
      var lines = String(notes).split("\n");
      var r1 = new RegExp("^[\\s]+", "g");
      var r2 = new RegExp("[\\s]+$", "g");
      for (line in lines) {
        var comment = lines[line].replace(r1, "").replace(r2, "");
        if (comment) {
          writeComment(comment);
        }
      }
    }
  }

  var spindleChanged = tool.type != TOOL_PROBE /*&& !stockTransferIsActive */&&
  (insertToolCall || forceSpindleSpeed || isSpindleSpeedDifferent() || newSpindle);

  if (spindleChanged) {
    forceSpindleSpeed = false;
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      if (spindleSpeed > getProperty("maximumSpindleSpeed")) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation " + "\"" + "%1" + "\"" + "."), getOperationComment()));
      }
    } else {
      if (spindleSpeed > 4000) {
        warning(subst(localize("Spindle speed exceeds maximum value for operation " + "\"" + "%1" + "\"" + "."), getOperationComment()));
      }
    }

    // Turn spindle on
    gSpindleModeModal.reset();
    startSpindle(false, true, getFramePosition(currentSection.getInitialPosition()));
  }

  var abc;
  if (machineConfiguration.isMultiAxisConfiguration()) {
    if (machineState.isTurningOperation) {
      if (gotBAxis) {
        cancelTransformation();
        // handle B-axis support for turning operations here
        abc = bAxisOrientationTurning;
        //setSpindleOrientationTurning();
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
      }
    } else {
      if (currentSection.isMultiAxis()) {
        forceWorkPlane();
        cancelTransformation();
        abc = currentSection.getInitialToolAxisABC();
      } else {
        abc = getWorkPlaneMachineABC(currentSection, currentSection.workPlane);
      }
    }
  } else { // pure 3D
    var remaining = currentSection.workPlane;
    if (!isSameDirection(remaining.forward, new Vector(0, 0, 1))) {
      error(localize("Tool orientation is not supported by the CNC machine."));
      return;
    }
    setRotation(remaining);
  }

  // Activate part catcher for part cutoff section
  if (getProperty("usePartCatcher") && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(true);
    writeBlock(feedMode);
  }

  // command stop for manual tool change, useful for quick change live tools
  if (insertToolCall && tool.manualToolChange) {
    onCommand(COMMAND_STOP);
    writeBlock("(" + "MANUAL TOOL CHANGE TO T" + toolFormat.format(tool.number * 100 + compensationOffset) + ")");
  }

  // Engage tailstock
  if (getProperty("useTailStock")) {
    if (machineState.axialCenterDrilling || (getSpindle(PART) == SPINDLE_SUB) ||
       ((getSpindle(TOOL) == SPINDLE_LIVE) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL))) {
      if (currentSection.tailstock) {
        warning(localize("Tail stock is not supported for secondary spindle or Z-axis milling."));
      }
      if (machineState.tailstockIsActive) {
        writeBlock(tailStockModal.format(getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
      }
    } else {
      writeBlock(tailStockModal.format(currentSection.tailstock ? getCode("TAILSTOCK_ON", SPINDLE_MAIN) : getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
    }
  }

  // Output spindle codes
  if (newSpindle) {
    // select spindle if required
  }

  if (insertToolCall) {
    forceAny();
  }
  gMotionModal.reset();
  if (currentSection.isMultiAxis()) {
    if (!insertToolCall && gotYAxis && yAxisIsEnabled && (currentMapMode != MAP_TURNING && currentMapMode != MAP_TURNING_SUB)) {
      writeBlock(gMotionModal.format(0), yOutput.format(0));
      gMotionModal.reset();
    }
    setYAxisMode(false);
    cAxisBrakeModal.reset(); // For XCZ to unclamp
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
    writeBlock(gMotionModal.format(0), aOutput.format(abc.x), bOutput.format(abc.y), cOutput.format(abc.z));
    previousABC = abc;
    forceWorkPlane();
    cancelTransformation();
  } else {
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      if (gotBAxis) {
        bOutput.reset();
        writeBlock(gMotionModal.format(0), bOutput.format(getB(abc, currentSection)));
        machineState.currentBAxisOrientationTurning = abc;
      }
    } else if (!machineState.useXZCMode && !machineState.usePolarMode) {
      setWorkPlane(abc);
    }
  }
  // activate Y-axis
  if (!currentSection.isMultiAxis()) {
    if (!machineState.usePolarMode && !machineState.useXZCMode && tempSpindle == SPINDLE_LIVE) {
      setYAxisMode(true, true);
    }
  }
  if (machineState.isTurningOperation || machineState.axialCenterDrilling || currentSection.isMultiAxis()) {
    writeBlock(gPlaneModal.format(18));
  } else if (!machineState.usePolarMode) {
    writeBlock(gPlaneModal.format(getG17Code()));
  }
  if (getProperty("unClampRotaryAxis") && (!machineState.isTurningOperation && !machineState.axialCenterDrilling)) {
    cAxisBrakeModal.reset();
    onCommand(COMMAND_UNLOCK_MULTI_AXIS);
  }

  gMotionModal.reset();
  var initialPosition = getFramePosition(currentSection.getInitialPosition());

  if (insertToolCall || retracted || (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
    gMotionModal.reset();
    if (machineState.useXZCMode || machineState.usePolarMode) {
      writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
      var c = getCWithinRange(initialPosition.x, initialPosition.y, previousABC.z);
      writeBlock(
        gMotionModal.format(0),
        xOutput.format(getModulus(initialPosition.x, initialPosition.y)),
        conditional(gotYAxis, yOutput.format(0)),
        conditional(machineState.useXZCMode, cOutput.format(c))
      );
      if (machineState.useXZCMode) {
        previousABC.setZ(c);
      }
    } else {
      if (machineState.isTurningOperation || machineState.machiningDirection != MACHINING_DIRECTION_RADIAL || currentSection.isMultiAxis() || !gotYAxis) {
        writeBlock(gMotionModal.format(0), zOutput.format(initialPosition.z));
        writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x), gotYAxis && yAxisIsEnabled ? yOutput.format(initialPosition.y) : "");
      } else {
        writeBlock(gMotionModal.format(0), xOutput.format(initialPosition.x));
        writeBlock(gMotionModal.format(0), gotYAxis && yAxisIsEnabled ? yOutput.format(initialPosition.y) : "", zOutput.format(initialPosition.z));
      }
    }
  }

  // Turn on coolant
  setCoolant(tool.coolant);

  // Write out maximum spindle speed
  if (insertToolCall && !machineState.stockTransferIsActive) {
    if ((tool.maximumSpindleSpeed > 0) && (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED)) {
      var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, getProperty("maximumSpindleSpeed")) : getProperty("maximumSpindleSpeed");
      writeBlock(gFormat.format(92), sOutput.format(maximumSpindleSpeed));
      sOutput.reset();
    }
  }

  // enable SFM spindle speed
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    startSpindle(false, false);
  }

  if (machineState.usePolarMode) {
    setPolarMode(true); // enable polar interpolation mode
  }
  if (getProperty("useParametricFeed") &&
      hasParameter("operation-strategy") &&
      (getParameter("operation-strategy") != "drill") && // legacy
      !(currentSection.hasAnyCycle && currentSection.hasAnyCycle())) {
    if (!insertToolCall &&
        activeMovements &&
        (getCurrentSectionId() > 0) &&
        ((getPreviousSection().getPatternId() == currentSection.getPatternId()) && (currentSection.getPatternId() != 0))) {
      // use the current feeds
    } else {
      initializeActiveFeeds();
    }
  } else {
    activeMovements = undefined;
  }

  previousSpindle = tempSpindle;
  activeSpindle = tempSpindle;

  if (false) { // DEBUG
    for (var key in machineState) {
      writeComment(key + " : " + machineState[key]);
    }
    writeComment("Tapping = " + tapping);
    // writeln("(" + (getMachineConfigurationAsText(machineConfiguration)) + ")");
  }
}

/** Returns true if the toolpath fits within the machine XY limits for the given C orientation. */
function doesToolpathFitInXYRange(abc) {
  var xMin = xAxisMinimum * Math.abs(xFormat.getScale());
  var yMin = yAxisMinimum * Math.abs(yFormat.getScale());
  var yMax = yAxisMaximum * Math.abs(yFormat.getScale());
  var c = 0;
  if (abc) {
    c = abc.z;
  }
  if (Vector.dot(machineConfiguration.getAxisU().getAxis(), new Vector(0, 0, 1)) != 0) {
    c *= (machineConfiguration.getAxisU().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the U-axis
  } else {
    c *= (machineConfiguration.getAxisV().getAxis().getCoordinate(2) >= 0) ? 1 : -1; // C-axis is the V-axis
  }

  var dx = new Vector(Math.cos(c), Math.sin(c), 0);
  var dy = new Vector(Math.cos(c + Math.PI / 2), Math.sin(c + Math.PI / 2), 0);

  if (currentSection.getGlobalRange) {
    var xRange = currentSection.getGlobalRange(dx);
    var yRange = currentSection.getGlobalRange(dy);

    if (false) { // DEBUG
      writeComment(
        "toolpath X minimum= " + xFormat.format(xRange[0]) + ", " + "Limit= " + xMin + ", " +
        "within range= " + (xFormat.getResultingValue(xRange[0]) >= xMin)
      );
      writeComment(
        "toolpath Y minimum= " + yFormat.getResultingValue(yRange[0]) + ", " + "Limit= " + yMin + ", " +
        "within range= " + (yFormat.getResultingValue(yRange[0]) >= yMin)
      );
      writeComment(
        "toolpath Y maximum= " + (yFormat.getResultingValue(yRange[1]) + ", " + "Limit= " + yMax) + ", " +
        "within range= " + (yFormat.getResultingValue(yRange[1]) <= yMax)
      );
      writeln("");
    }

    if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if ((yFormat.getResultingValue(yRange[0]) >= yMin) &&
          (yFormat.getResultingValue(yRange[1]) <= yMax)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    } else { // G17 plane
      if ((xFormat.getResultingValue(xRange[0]) >= xMin) &&
          (yFormat.getResultingValue(yRange[0]) >= yMin) &&
          (yFormat.getResultingValue(yRange[1]) <= yMax)) {
        return true; // toolpath does fit in XY range
      } else {
        return false; // toolpath does not fit in XY range
      }
    }
  } else {
    if (revision < 40000) {
      warning(localize("Please update to the latest release to allow XY linear interpolation instead of polar interpolation."));
    }
    return false; // for older versions without the getGlobalRange() function
  }
}

var MACHINING_DIRECTION_AXIAL = 0;
var MACHINING_DIRECTION_RADIAL = 1;
var MACHINING_DIRECTION_INDEXING = 2;

function getMachiningDirection(section) {
  var forward = section.isMultiAxis() ? section.getGlobalInitialToolAxis() : section.workPlane.forward;
  if (isSameDirection(forward, new Vector(0, 0, 1))) {
    machineState.machiningDirection = MACHINING_DIRECTION_AXIAL;
    return MACHINING_DIRECTION_AXIAL;
  } else if (Vector.dot(forward, new Vector(0, 0, 1)) < 1e-7) {
    machineState.machiningDirection = MACHINING_DIRECTION_RADIAL;
    return MACHINING_DIRECTION_RADIAL;
  } else {
    machineState.machiningDirection = MACHINING_DIRECTION_INDEXING;
    return MACHINING_DIRECTION_INDEXING;
  }
}

function updateMachiningMode(section) {
  machineState.axialCenterDrilling = false; // reset
  machineState.usePolarMode = false; // reset
  machineState.useXZCMode = false; // reset

  if ((section.getType() == TYPE_MILLING) && !section.isMultiAxis()) {
    if (getMachiningDirection(section) == MACHINING_DIRECTION_AXIAL) {
      if (section.hasParameter("operation-strategy") && (section.getParameter("operation-strategy") == "drill")) {
        if (section.hasParameter("operation:cycleType") &&
            ((section.getParameter("operation:cycleType") == "circular-pocket-milling") ||
            (section.getParameter("operation:cycleType") == "bore-milling") ||
            (section.getParameter("operation:cycleType") == "thread-milling"))) {
          if (gotPolarInterpolation && !forceXZCMode) {
            machineState.usePolarMode = true;
          } else {
            machineState.useXZCMode = true;
          }
        // drilling axial
        } else if ((section.getNumberOfCyclePoints() == 1) &&
            !xFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).x) &&
            !yFormat.isSignificant(getGlobalPosition(section.getInitialPosition()).y) &&
            (spatialFormat.format(section.getFinalPosition().x) == 0) &&
            !doesCannedCycleIncludeYAxisMotion(section)) { // catch drill issue for old versions
          // single hole on XY center
          if (section.getTool().isLiveTool && section.getTool().isLiveTool()) {
            // use live tool
          } else {
            // use main spindle for axialCenterDrilling
            machineState.axialCenterDrilling = true;
          }
        } else {
          // several holes not on XY center
          bestABCIndex = getBestABCIndex(section);
          if (getProperty("useYAxisForDrilling") && (bestABCIndex != undefined) && !doesCannedCycleIncludeYAxisMotion(section)) {
            // use XYZ-mode
          } else { // use XZC mode
            machineState.useXZCMode = true;
            bestABCIndex = undefined;
          }
        }
      } else { // milling
        if (gotPolarInterpolation && forcePolarMode) { // polar mode is requested by user
          machineState.usePolarMode = true;
        } else if (forceXZCMode) { // XZC mode is requested by user
          machineState.useXZCMode = true;
        } else { // see if toolpath fits in XY-range
          fitFlag = false;
          bestABCIndex = undefined;
          for (var i = 0; i < 6; ++i) {
            fitFlag = doesToolpathFitInXYRange(getBestABC(section, section.workPlane, i));
            if (fitFlag) {
              bestABCIndex = i;
              break;
            }
          }
          if (!fitFlag) { // does not fit, set polar/XZC mode
            if (gotPolarInterpolation) {
              machineState.usePolarMode = true;
            } else {
              machineState.useXZCMode = true;
            }
          }
        }
      }
    } else if (getMachiningDirection(section) == MACHINING_DIRECTION_RADIAL) { // G19 plane
      if (!gotYAxis) {
        if (!section.isMultiAxis() && (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || doesCannedCycleIncludeYAxisMotion(section))) {
          error(subst(localize("Y-axis motion is not possible without a Y-axis for operation \"%1\"."), getOperationComment()));
          return;
        }
      } else {
        if (!doesToolpathFitInXYRange(machineConfiguration.getABC(section.workPlane)) || forceXZCMode) {
          error(subst(localize("Toolpath exceeds the maximum ranges for operation \"%1\"."), getOperationComment()));
          return;
        }
      }
      // C-coordinates come from setWorkPlane or is within a multi axis operation, we cannot use the C-axis for non wrapped toolpathes (only multiaxis works, all others have to be into XY range)
    } else {
      // useXZCMode & usePolarMode is only supported for axial machining, keep false
    }
  } else {
    // turning or multi axis, keep false
  }

  if (machineState.axialCenterDrilling) {
    cOutput.disable();
  } else {
    cOutput.enable();
  }

  var checksum = 0;
  checksum += machineState.usePolarMode ? 1 : 0;
  checksum += machineState.useXZCMode ? 1 : 0;
  checksum += machineState.axialCenterDrilling ? 1 : 0;
  validate(checksum <= 1, localize("Internal post processor error."));
}

function doesCannedCycleIncludeYAxisMotion(section) {
  // these cycles have Y axis motions which are not detected by getGlobalRange()
  var hasYMotion = false;
  if (section.hasParameter("operation:strategy") && (section.getParameter("operation:strategy") == "drill")) {
    switch (section.getParameter("operation:cycleType")) {
    case "thread-milling":
    case "bore-milling":
    case "circular-pocket-milling":
      hasYMotion = true; // toolpath includes Y-axis motion
      break;
    case "back-boring":
    case "fine-boring":
      var shift = getParameter("operation:boringShift");
      if (shift != spatialFormat.format(0)) {
        hasYMotion = true; // toolpath includes Y-axis motion
      }
      break;
    default:
      hasYMotion = false; // all other cycles do not have Y-axis motion
    }
  }
  return hasYMotion;
}

function getOperationComment() {
  var operationComment = hasParameter("operation-comment") && getParameter("operation-comment");
  return operationComment;
}

function setRadiusDiameterMode(mode, force) {
  var comment = "";
  if (force) {
    gRadDiamModal.reset();
    comment = mode + " programing";
  }
  if (mode == "diameter") {
    writeBlock(gRadDiamModal.format(8), conditional(comment, formatComment(comment)));
    xFormat.setScale(2);
  } else {
    writeBlock(gRadDiamModal.format(7), conditional(comment, formatComment(comment)));
    if (getSpindle(PART) == SPINDLE_SUB) {
      xFormat.setScale(1);
    } else {
      if (!(machineState.machiningDirection == MACHINING_DIRECTION_RADIAL) || currentSection.isMultiAxis() || !gotYAxis) { // Axial tools
        xFormat.setScale(1);
      } else { // Radial tools
        xFormat.setScale(-1);
      }
    }
  }
  xOutput = createVariable({prefix:"X"}, xFormat);
}

function setPolarMode(activate) {
  if (activate) {
    setYAxisMode(false); // Needed for same tool
    cOutput.enable();
    cOutput.reset();

    var cAngle = 0;
    var initialPosition = getFramePosition(currentSection.getInitialPosition());
    if (xFormat.isSignificant(initialPosition.x) || yFormat.isSignificant(initialPosition.y)) {
      cAngle = getCWithinRange(initialPosition.x, initialPosition.y);
    }

    writeBlock(gMotionModal.format(0), cOutput.format(cAngle));
    writeBlock(gMapCodeModal.format(getCode("POLAR_INTERPOLATION_ON", getSpindle(PART)))); // command for polar interpolation
    gPlaneModal.reset();
    writeBlock(gPlaneModal.format(getG17Code()));
    yOutput.enable(); // required for G12.1
    cOutput.disable();
  } else {
    if (!gotYAxis) {
      yOutput.disable();
    }
    cOutput.enable();
  }
}

var yAxisIsEnabled = false;
function setYAxisMode(activate, resetOrigin) {
  if (gotYAxis && activate) {
    var mappingCode = getCode("ENABLE_Y_AXIS", getSpindle(PART)); // getCode sets mapping mode
    if (getProperty("controllerType") == "v9" && (previousMapMode != MAP_RADIAL || previousMapMode != MAP_RADIAL_SUB) && resetOrigin) {
      writeBlock(gFormat.format(25), "Q" + zFormat.format(0));
    }
    writeBlock(gMapCodeModal.format(mappingCode)); // G103/G104 Main and G107/G108 Sub sets G17 Plane
    yOutput.enable();
    yAxisIsEnabled = true;
    yAxisIsRetracted = false;
    writeBlock(mCuttingModal.format(getCode("ENABLE_MILLING", getSpindle(PART))));
  } else { // Lathe/XZC map mode
    writeBlock(gMapCodeModal.format(getCode("LATHE_MAP", getSpindle(PART))));
    yOutput.disable();
    yAxisIsEnabled = false;
  }
}

function goHome(onlyX) {
  var method = getProperty("safePositionMethod") == "G53" ? 53 : 28;
  if (!onlyX) { // Sends XYZ to machine home, then Z to tool change position
    if (gotYAxis) {
      gMapCodeModal.reset();
      mCuttingModal.reset();
      setYAxisMode(true, false);
    }
    writeBlock(gFormat.format(28), "U" + xFormat.format(0), conditional(gotYAxis, "V" + yFormat.format(0)));
    yAxisIsRetracted = true;
    setYAxisMode(false);
    writeBlock(mCuttingModal.format(getCode("ENABLE_TURNING")));
    gMotionModal.reset();
    writeBlock(gMotionModal.format(0), gFormat.format(method), method == 28 ? "W" + zFormat.format(0) : "Z#501");
  } else { // Bring X to tool change position
    gMotionModal.reset();
    setRadiusDiameterMode("diameter", true);
    writeBlock(gMotionModal.format(0), gFormat.format(method), method == 28 ? "U" + xFormat.format(0) : "X#500");
  }
}

function onDwell(seconds) {
  if (seconds > 99999.999) {
    warning(localize("Dwelling time is out of range."));
  }
  writeBlock(gFormat.format(4), dwellFormat.format(seconds));
}

var pendingRadiusCompensation = -1;

function onRadiusCompensation() {
  pendingRadiusCompensation = radiusCompensation;
}

function getCompensationPlane(abc, returnCode, outputPlane) {
  var plane;
  if (machineState.isTurningOperation) {
    plane = PLANE_ZX;
  } else if (machineState.usePolarMode) {
    plane = PLANE_XY;
  } else {
    var found = false;
    if (!found) {
      if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1))) {
        plane = PLANE_XY;
      } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
        plane = gotYAxis ? PLANE_XY : PLANE_ZY;
      } else {
        if (returnCode) {
          if (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL) {
            plane = PLANE_XY;
          } else {
            plane = PLANE_ZX;
          }
        } else {
          plane = -1;
          if (outputPlane) {
            error(localize("Tool orientation is not supported for radius compensation."));
            return -1;
          }
        }
      }
    }
  }
  var code = plane == -1 ? -1 : (plane == PLANE_XY ? getG17Code() : (plane == PLANE_ZX ? 18 : 19));
  if (outputPlane) {
    writeBlock(gPlaneModal.format(code));
  }
  return returnCode ? code : plane;
}

var resetFeed = false;

function getHighfeedrate(radius) {
  if (currentSection.feedMode == FEED_PER_REVOLUTION) {
    if (toDeg(radius) <= 0) {
      radius = toPreciseUnit(0.1, MM);
    }
    var rpm = spindleSpeed; // rev/min
    if (currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
      var O = 2 * Math.PI * radius; // in/rev
      rpm = tool.surfaceSpeed / O; // in/min div in/rev => rev/min
    }
    return highFeedrate / rpm; // in/min div rev/min => in/rev
  }
  return highFeedrate;
}

function onRapid(_x, _y, _z) {
  if (machineState.useXZCMode) {
    var start = getCurrentPosition();
    var dxy = getModulus(_x - start.x, _y - start.y);
    if (true || (dxy < getTolerance())) {
      var x = xOutput.format(getModulus(_x, _y));
      var currentC = getCWithinRange(_x, _y, previousABC.z);
      var z = zOutput.format(_z);
      if (pendingRadiusCompensation >= 0) {
        error(localize("Radius compensation mode cannot be changed at rapid traversal."));
        return;
      }
      if (forceRewind) {
        rewindTable(start, currentC, highFeedrate);
      }
      var c = cOutput.format(currentC);
      writeBlock(gMotionModal.format(0), x, c, z);
      previousABC.setZ(currentC);
      forceFeed();
      return;
    }

    onExpandedLinear(_x, _y, _z, highFeedrate);
    return;
  }

  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  if (x || y || z) {
    // var useG1 = (((x ? 1 : 0) + (y ? 1 : 0) + (z ? 1 : 0)) > 1) || machineState.usePolarMode;
    var useG1 = machineState.usePolarMode;
    var highFeed = getHighfeedrate(_x);
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var plane = getCompensationPlane(previousABC, false, true);
      var ccLeft = isMirrored(plane) ? 42 : 41;
      var ccRight = isMirrored(plane) ? 41 : 42;
      if (useG1) {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(
            gMotionModal.format(1),
            gFormat.format(ccLeft),
            x, y, z, getFeed(highFeed)
          );
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(
            gMotionModal.format(1),
            gFormat.format(ccRight),
            x, y, z, getFeed(highFeed)
          );
          break;
        default:
          writeBlock(gMotionModal.format(1), gFormat.format(40), x, y, z, getFeed(highFeed));
        }
      } else {
        switch (radiusCompensation) {
        case RADIUS_COMPENSATION_LEFT:
          writeBlock(
            gMotionModal.format(0),
            gFormat.format(ccLeft),
            x, y, z
          );
          break;
        case RADIUS_COMPENSATION_RIGHT:
          writeBlock(
            gMotionModal.format(0),
            gFormat.format(ccRight),
            x, y, z
          );
          break;
        default:
          writeBlock(gMotionModal.format(0), gFormat.format(40), x, y, z);
        }
      }
    } else {
      if (false) {
        // axes are not synchronized
        writeBlock(gMotionModal.format(1), x, y, z, getFeed(highFeed));
        resetFeed = false;
      } else {
        writeBlock(gMotionModal.format(0), x, y, z);
        // forceFeed();
      }
    }
  }
}

/** Calculate the distance of a point to a line segment. */
function pointLineDistance(startPt, endPt, testPt) {
  var delta = Vector.diff(endPt, startPt);
  distance = Math.abs(delta.y * testPt.x - delta.x * testPt.y + endPt.x * startPt.y - endPt.y * startPt.x) /
    Math.sqrt(delta.y * delta.y + delta.x * delta.x); // distance from line to point
  if (distance < 1e-4) { // make sure point is in line segment
    var moveLength = Vector.diff(endPt, startPt).length;
    var startLength = Vector.diff(startPt, testPt).length;
    var endLength = Vector.diff(endPt, testPt).length;
    if ((startLength > moveLength) || (endLength > moveLength)) {
      distance = Math.min(startLength, endLength);
    }
  }
  return distance;
}

/** Refine segment for XC mapping. */
function refineSegmentXC(startX, startC, endX, endC, maximumDistance) {
  var rotary = machineConfiguration.getAxisU(); // C-axis
  var startPt = rotary.getAxisRotation(startC).multiply(new Vector(startX, 0, 0));
  var endPt = rotary.getAxisRotation(endC).multiply(new Vector(endX, 0, 0));

  var testX = startX + (endX - startX) / 2; // interpolate as the machine
  var testC = startC + (endC - startC) / 2;
  var testPt = rotary.getAxisRotation(testC).multiply(new Vector(testX, 0, 0));

  var delta = Vector.diff(endPt, startPt);
  var distf = pointLineDistance(startPt, endPt, testPt);

  if (distf > maximumDistance) {
    return false; // out of tolerance
  } else {
    return true;
  }
}

function rewindTable(startXYZ, rewindC, feed) {
  if (!cFormat.areDifferent(rewindC, previousABC.z)) {
    error(localize("Rewind position not found."));
    return;
  }
  writeComment("REWIND: C-axis is rewinding due to limit.");
  writeBlock(gMotionModal.format(1), zOutput.format(currentSection.getInitialPosition().z), getFeed(feed));
  gMotionModal.reset();
  xOutput.reset();

  var x = getModulus(startXYZ.x, startXYZ.y);
  if (true) {
    writeBlock(gMotionModal.format(1), xOutput.format(x), getFeed(highFeedrate));
    writeBlock(gMotionModal.format(0), cOutput.format(rewindC));
  } else {
    writeBlock(gMotionModal.format(1), xOutput.format(x), cOutput.format(rewindC), getFeed(highFeedrate));
  }
  writeBlock(gMotionModal.format(1), zOutput.format(startXYZ.z), getFeed(feed));

  forceRewind = false;
  writeComment("End of rewind");
}

function onLinear(_x, _y, _z, feed) {
  if (machineState.useXZCMode) {
    if (pendingRadiusCompensation >= 0) {
      error(subst(localize("Radius compensation is not supported for operation \"%1\". You have to use polar interpolation mode for radius compensation."), getOperationComment()));
      return;
    }
    if (maximumCircularSweep > toRad(179)) {
      error(localize("Maximum circular sweep must be below 179 degrees."));
      return;
    }

    var localTolerance = getTolerance() / 4;

    var startXYZ = getCurrentPosition();
    var startX = getModulus(startXYZ.x, startXYZ.y);
    var startZ = startXYZ.z;
    var startC = previousABC.z;

    var endXYZ = new Vector(_x, _y, _z);
    var endX = getModulus(endXYZ.x, endXYZ.y);
    var endZ = endXYZ.z;
    var endC = getCWithinRange(endXYZ.x, endXYZ.y, startC);

    var currentXYZ = endXYZ; var currentX = endX; var currentZ = endZ; var currentC = endC;
    var centerXYZ = machineConfiguration.getAxisU().getOffset();

    var refined = true;
    var crossingRotary = false;
    forceOptimized = false; // tool tip is provided to DPM calculations
    while (refined) { // stop if we dont refine
      // check if we cross center of rotary axis
      var _start = new Vector(startXYZ.x, startXYZ.y, 0);
      var _current = new Vector(currentXYZ.x, currentXYZ.y, 0);
      var _center = new Vector(centerXYZ.x, centerXYZ.y, 0);
      if ((xFormat.getResultingValue(pointLineDistance(_start, _current, _center)) == 0) &&
          (xFormat.getResultingValue(Vector.diff(_start, _center).length) != 0) &&
          (xFormat.getResultingValue(Vector.diff(_current, _center).length) != 0)) {
        var ratio = Vector.diff(_center, _start).length / Vector.diff(_current, _start).length;
        currentXYZ = centerXYZ;
        currentXYZ.z = startZ + (endZ - startZ) * ratio;
        currentX = getModulus(currentXYZ.x, currentXYZ.y);
        currentZ = currentXYZ.z;
        currentC = startC;
        crossingRotary = true;
      } else { // check if move is out of tolerance
        refined = false;
        while (!refineSegmentXC(startX, startC, currentX, currentC, localTolerance)) { // move is out of tolerance
          refined = true;
          currentXYZ = Vector.lerp(startXYZ, currentXYZ, 0.75);
          currentX = getModulus(currentXYZ.x, currentXYZ.y);
          currentZ = currentXYZ.z;
          currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
          if (Vector.diff(startXYZ, currentXYZ).length < 1e-5) { // back to start point, output error
            if (forceRewind) {
              break;
            } else {
              warning(localize("Linear move cannot be mapped to rotary XZC motion."));
              break;
            }
          }
        }
      }

      currentC = getCWithinRange(currentXYZ.x, currentXYZ.y, startC);
      if (forceRewind) {
        var rewindC = getCClosest(startXYZ.x, startXYZ.y, currentC);
        xOutput.reset(); // force X for repositioning
        rewindTable(startXYZ, rewindC, feed);
        previousABC.setZ(rewindC);
      }
      var x = xOutput.format(currentX);
      var c = cOutput.format(currentC);
      var z = zOutput.format(currentZ);
      if (x || c || z) {
        writeBlock(gMotionModal.format(1), x, c, z, getFeed(feed));
      }
      setCurrentPosition(currentXYZ);
      previousABC.setZ(currentC);
      if (crossingRotary) {
        writeBlock(gMotionModal.format(1), cOutput.format(endC), getFeed(feed)); // rotate at X0 with endC
        previousABC.setZ(endC);
        forceFeed();
      }
      startX = currentX; startZ = currentZ; startC = crossingRotary ? endC : currentC; startXYZ = currentXYZ; // loop start point
      currentX = endX; currentZ = endZ; currentC = endC; currentXYZ = endXYZ; // loop end point
      crossingRotary = false;
    }
    forceOptimized = undefined;
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    resetFeed = true;
    var threadPitch = getParameter("operation:threadPitch");
    var threadsPerInch = 1.0 / threadPitch; // per mm for metric
    writeBlock(gMotionModal.format(33), xOutput.format(_x), yOutput.format(_y), zOutput.format(_z), pitchOutput.format(1 / threadsPerInch));
    return;
  }
  if (resetFeed) {
    resetFeed = false;
    forceFeed();
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var f = getFeed(feed);
  if (x || y || z) {
    if (pendingRadiusCompensation >= 0) {
      pendingRadiusCompensation = -1;
      var plane = getCompensationPlane(previousABC, false, true);
      var ccLeft = isMirrored(plane) ? 42 : 41;
      var ccRight = isMirrored(plane) ? 41 : 42;
      switch (radiusCompensation) {
      case RADIUS_COMPENSATION_LEFT:
        writeBlock(
          gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
          gFormat.format(ccLeft),
          x, y, z, f
        );
        break;
      case RADIUS_COMPENSATION_RIGHT:
        writeBlock(
          gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1),
          gFormat.format(ccRight),
          x, y, z, f
        );
        break;
      default:
        writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), gFormat.format(40), x, y, z, f);
      }
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), x, y, z, f);
    }
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(isSpeedFeedSynchronizationActive() ? 32 : 1), f);
    }
  }
}

function onRapid5D(_x, _y, _z, _a, _b, _c) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation mode cannot be changed at rapid traversal."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);
  if (false) {
    // axes are not synchronized
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, getFeed(highFeedrate));
  } else {
    writeBlock(gMotionModal.format(0), x, y, z, a, b, c);
    forceFeed();
  }
  previousABC = new Vector(_a, _b, _c);
}

function onLinear5D(_x, _y, _z, _a, _b, _c, feed) {
  if (!currentSection.isOptimizedForMachine()) {
    error(localize("Multi-axis motion is not supported for XZC mode."));
    return;
  }
  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for 5-axis move."));
    return;
  }
  var x = xOutput.format(_x);
  var y = yOutput.format(_y);
  var z = zOutput.format(_z);
  var a = aOutput.format(_a);
  var b = bOutput.format(_b);
  var c = cOutput.format(_c);

  var f = getFeed(feed);

  if (x || y || z || a || b || c) {
    writeBlock(gMotionModal.format(1), x, y, z, a, b, c, f);
  } else if (f) {
    if (getNextRecord().isMotion()) { // try not to output feed without motion
      forceFeed(); // force feed on next line
    } else {
      writeBlock(gMotionModal.format(1), f);
    }
  }
  previousABC = new Vector(_a, _b, _c);
}

// Start of onRewindMachine logic
/** Allow user to override the onRewind logic. */
function onRewindMachineEntry(_a, _b, _c) {
  return false;
}

/** Retract to safe position before indexing rotaries. */
function onMoveToSafeRetractPosition() {
}

/** Rotate axes to new position above reentry position */
function onRotateAxes(_x, _y, _z, _a, _b, _c) {
  // position rotary axes
  xOutput.disable();
  yOutput.disable();
  zOutput.disable();
  forceG0 = true;
  invokeOnRapid5D(_x, _y, _z, _a, _b, _c);
  setCurrentABC(new Vector(_a, _b, _c));
  xOutput.enable();
  if (yAxisIsEnabled) {
    yOutput.enable();
  }
  zOutput.enable();
}

/** Return from safe position after indexing rotaries. */
function onReturnFromSafeRetractPosition(_x, _y, _z) {
  onExpandedRapid(_x, _y, _z);
}
// End of onRewindMachine logic

function onCircular(clockwise, cx, cy, cz, x, y, z, feed) {
  var directionCode;
  if (isMirrored(getCircularPlane())) {
    directionCode = clockwise ? 3 : 2;
  } else {
    directionCode = clockwise ? 2 : 3;
  }
  if (machineState.useXZCMode) {
    switch (getCircularPlane()) {
    case PLANE_ZX:
      if (!isSpiral()) {
        var c = getCWithinRange(x, y, previousABC.z);
        if (!cFormat.areDifferent(c, previousABC.z)) {
          validate(getCircularSweep() < Math.PI, localize("Circular sweep exceeds limit."));
          var start = getCurrentPosition();
          writeBlock(gPlaneModal.format(18), gMotionModal.format(directionCode), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    case PLANE_XY:
      var d2 = center.x * center.x + center.y * center.y;
      if (d2 < 1e-6) { // center is on rotary axis
        var c = getCWithinRange(x, y, previousABC.z, !clockwise);
        if (!forceRewind) {
          writeBlock(gMotionModal.format(1), xOutput.format(getModulus(x, y)), cOutput.format(c), zOutput.format(z), getFeed(feed));
          previousABC.setZ(c);
          return;
        }
      }
      break;
    }

    linearize(getTolerance());
    return;
  }

  if (isSpeedFeedSynchronizationActive()) {
    error(localize("Speed-feed synchronization is not supported for circular moves."));
    return;
  }

  if (pendingRadiusCompensation >= 0) {
    error(localize("Radius compensation cannot be activated/deactivated for a circular move."));
    return;
  }

  var start = getCurrentPosition();

  if (getCircularPlane() != PLANE_XY) {
    if ((machineState.usePolarMode || getProperty("controllerType") == "v9") && !machineState.isTurningOperation) {
      linearize(tolerance);
      return;
    }
  }
  if (isFullCircle()) {
    if (getProperty("useRadius") || isHelical()) { // radius mode does not support full arcs
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(getG17Code()));
      writeBlock(gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18));
      writeBlock(gMotionModal.format(directionCode), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19));
      writeBlock(gMotionModal.format(directionCode), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else if (!getProperty("useRadius")) {
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) { // avoid G112 issue
      linearize(tolerance);
      return;
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(getG17Code()));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), jOutput.format(cy - start.y, 0), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), iOutput.format(cx - start.x, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), jOutput.format(cy - start.y, 0), kOutput.format(cz - start.z, 0), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  } else { // use radius mode
    if (isHelical() && ((getCircularSweep() < toRad(30)) || (getHelicalPitch() > 10))) {
      linearize(tolerance);
      return;
    }
    var r = getCircularRadius();
    if (toDeg(getCircularSweep()) > (180 + 1e-9)) {
      r = -r; // allow up to <360 deg arcs
    }
    switch (getCircularPlane()) {
    case PLANE_XY:
      writeBlock(gPlaneModal.format(getG17Code()));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_ZX:
      writeBlock(gPlaneModal.format(18));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    case PLANE_YZ:
      writeBlock(gPlaneModal.format(19));
      writeBlock(gMotionModal.format(directionCode), xOutput.format(x), yOutput.format(y), zOutput.format(z), "R" + rFormat.format(r), getFeed(feed));
      break;
    default:
      linearize(tolerance);
    }
  }
}

function onCycle() {
  if ((typeof isSubSpindleCycle == "function") && isSubSpindleCycle(cycleType)) {
    // Start of stock transfer operation(s)
    if (!machineState.stockTransferIsActive) {
      if (cycleType != "secondary-spindle-return") {
        goHome(false);
      }
      if (!cycle.stopSpindle) {
        onCommand(COMMAND_STOP_SPINDLE);
      }
      onCommand(COMMAND_COOLANT_OFF);

      if (cycle.stopSpindle) {
        // writeBlock(gMotionModal.format(0), gFormat.format(28), "H" + abcFormat.format(0));
        //writeBlock(gMotionModal.format(0), cOutput.format(0));
      }
      var workOffset = currentWorkOffset == undefined ? 1 : currentWorkOffset;
      //writeBlock(gMotionModal.format(0), gFormat.format(53 + workOffset), gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL))));
    }
    onCommand(COMMAND_OPTIONAL_STOP);
    writeln("");
    if (hasParameter("operation-comment")) {
      var comment = getParameter("operation-comment");
      if (comment) {
        if (getProperty("showSequenceNumbers") == "toolChange") {
          writeCommentSeqno(comment);
        } else {
          writeComment(comment);
        }
      }
    }

    switch (cycleType) {
    case "secondary-spindle-return":
      var secondaryPull = false;
      var secondaryHome = false;
      // Transfer part to secondary spindle
      if (cycle.unclampMode != "keep-clamped") {
        secondaryPull = true;
        secondaryHome = true;
      } else {
        // pull part only (when offset!=0), Return secondary spindle to home (when offset=0)
        if (hasParameter("operation:feedPlaneHeight_offset")) { // Inventor
          secondaryPull = getParameter("operation:feedPlaneHeight_offset") != 0;
        }
        if (hasParameter("operation:feedPlaneHeightOffset")) { // HSMWorks
          secondaryPull = getParameter("operation:feedPlaneHeightOffset") != 0;
        }
        secondaryHome = !secondaryPull;
      }
      if (secondaryPull) {
        writeBlock(mFormat.format(getCode("ENABLE_OPEN_CHUCK", getSpindle(PART))));
        writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSpindle(PART))), formatComment("UNCLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
        moveSubSpindle(FEED, cycle.feedPosition, cycle.feedrate, true, "BAR PULL", true);
        onDwell(cycle.dwell);
      }
      if (secondaryHome) {
        if (cycle.unclampMode == "unclamp-secondary") { // simple bar pulling operation
          writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSpindle(PART))), formatComment("CLAMP MAIN CHUCK"));
          onDwell(cycle.dwell);
          writeBlock(mFormat.format(getCode("ENABLE_OPEN_CHUCK", getSecondarySpindle())));
          writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSecondarySpindle())), formatComment("UNCLAMP SUB CHUCK"));
          onDwell(cycle.dwell);
        }
        onCommand(COMMAND_STOP_SPINDLE);
        if (getProperty("controllerType") != "v9") {
          writeBlock(mFormat.format(getCode("STOP_SPINDLE", getSecondarySpindle())));
        }
        var transferCodes = getSpindleTransferCodes();
        if ((transferCodes != undefined) && !transferCodes.cutoff) {
          writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF", getSpindle(PART))), formatComment("CANCEL SYNCHRONIZATION"));
        } else {
          var code = getCode("SPINDLE_SYNCHRONIZATION_OFF", getSpindle(PART));
          writeBlock(mFormat.format(code), formatComment("CANCEL SYNCHRONIZATION"));
        }
        moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
      } else {
        writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSpindle(PART))), formatComment("CLAMP MAIN CHUCK"));
        onDwell(cycle.dwell);
      }
      machineState.stockTransferIsActive = true;
      break;

    case "secondary-spindle-grab":
      if (currentSection.partCatcher) {
        engagePartCatcher(true);
      }

      writeBlock(gFormat.format(90), gFormat.format(40), gFormat.format(80));
      if (!machineState.stockTransferIsActive) {
        moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
      }
      goHome(true); // Send X to position
      writeBlock(gMotionModal.format(0), currentSection.wcs, gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL))));
      if (cycle.stopSpindle) { // no spindle rotation
        writeBlock(mFormat.format(getCode("STOP_SPINDLE", getSpindle(PART))));
        if (getProperty("controllerType") != "v9") {
          writeBlock(mFormat.format(getCode("STOP_SPINDLE", getSecondarySpindle())));
        }
        writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_OFF")));
        gMotionModal.reset();
      } else { // spindle rotation
        var transferCodes = getSpindleTransferCodes();
        writeBlock(
          gFormat.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(PART))),
          sOutput.format(transferCodes.spindleRPM),
          getCode(transferCodes.spindleDirection ? "SPINDLE_SYNCHRONIZATION_CW" : "SPINDLE_SYNCHRONIZATION_CCW", getSpindle(PART)) +
            ":" +  abcFormat.format(cycle.spindleOrientation)
        );
      }
      // clean out chips
      if (airCleanChuck) {
        writeBlock(mFormat.format(getCode("AIR_BLAST_ON", SPINDLE_MAIN)), formatComment("CLEAN OUT CHIPS"));
        writeBlock(mFormat.format(getCode("AIR_BLAST_ON", SPINDLE_SUB)));
        onDwell(5.5);
        writeBlock(mFormat.format(getCode("AIR_BLAST_OFF", SPINDLE_MAIN)));
        writeBlock(mFormat.format(getCode("AIR_BLAST_OFF", SPINDLE_SUB)));
      }
      writeBlock(mFormat.format(getCode("ENABLE_OPEN_CHUCK", getSecondarySpindle())));
      writeBlock(mFormat.format(getCode("SPINDLE_SYNCHRONIZATION_CW")) + ":" + cFormat.format(0));
      writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSecondarySpindle())), formatComment("UNCLAMP SUB CHUCK"));
      onDwell(cycle.dwell);
      gSpindleModeModal.reset();

      gMotionModal.reset();
      moveSubSpindle(RAPID, cycle.feedPosition, 0, cycle.useMachineFrame, "", true);
      moveSubSpindle(TORQUE, cycle.chuckPosition, cycle.feedrate, cycle.useMachineFrame, "", true);
      writeBlock(mFormat.format(getCode("CLAMP_CHUCK", getSecondarySpindle())), formatComment("CLAMP SUB CHUCK"));

      onDwell(cycle.dwell);
      machineState.stockTransferIsActive = true;
      break;
    }
  }
  previousABC = new Vector(0, 0, 0); // Reset C angle when turning
  if (cycleType == "stock-transfer") {
    warning(localize("Stock transfer is not supported. Required machine specific customization."));
    return;
  }
}

function getCommonCycle(x, y, z, r, includeRcode) {

  // R-value is incremental position from current position
  var raptoS = "";
  if ((r !== undefined) && includeRcode) {
    raptoS = "R" + spatialFormat.format(r);
  }
  if (getProperty("controllerType") == "v9" && isFirstCyclePoint()) {
    xOutput.reset();
    zOutput.reset();
  }

  if (machineState.useXZCMode) {
    var c = getCWithinRange(x, y, previousABC.z);
    cOutput.reset();
    return [xOutput.format(getModulus(x, y)), cOutput.format(c),
      zOutput.format(z),
      raptoS];
  } else {
    return [xOutput.format(x), yOutput.format(y),
      zOutput.format(z),
      raptoS];
  }
}

function writeCycleClearance(plane, clearance) {
  var currentPosition = getCurrentPosition();
  if (true) {
    onCycleEnd();
    switch (plane) {
    case 17:
      writeBlock(gMotionModal.format(0), zOutput.format(clearance));
      break;
    case 18:
      writeBlock(gMotionModal.format(0), yOutput.format(clearance));
      break;
    case 19:
      writeBlock(gMotionModal.format(0), xOutput.format(clearance));
      break;
    default:
      error(localize("Unsupported drilling orientation."));
      return;
    }
  }
}

var threadStart;
var threadEnd;
function moveToThreadStart(x, y, z) {
  var cuttingAngle = 0;
  if (hasParameter("operation:infeedAngle")) {
    cuttingAngle = getParameter("operation:infeedAngle");
  }
  if (cuttingAngle != 0) {
    var zz;
    if (isFirstCyclePoint()) {
      threadStart = getCurrentPosition();
      threadEnd = new Vector(x, y, z);
    } else {
      var zz = threadStart.z - (Math.abs(threadEnd.x - x) * Math.tan(toRad(cuttingAngle)));
      writeBlock(gMotionModal.format(0), zOutput.format(zz));
      threadStart.setZ(zz);
      threadEnd = new Vector(x, y, z);
    }
  }
}

function onCyclePoint(x, y, z) {

  if (!getProperty("useCycles") || currentSection.isMultiAxis()) {
    expandCyclePoint(x, y, z);
    return;
  }

  var plane = gPlaneModal.getCurrent();
  var localZOutput = zOutput;
  if (isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, 1)) ||
      isSameDirection(currentSection.workPlane.forward, new Vector(0, 0, -1))) {
    plane = 17; // XY plane
    localZOutput = zOutput;
  } else if (Vector.dot(currentSection.workPlane.forward, new Vector(0, 0, 1)) < 1e-7) {
    if (gotYAxis) {
      plane = 17; // XY plane Rotated
      localZOutput = zOutput;
    } else {
      plane = 19; // plane not Rotated
      localZOutput = xOutput;
    }
  } else {
    expandCyclePoint(x, y, z);
    return;
  }

  switch (cycleType) {
  case "thread-turning":
    if (getProperty("useSimpleThread") ||
       (hasParameter("operation:doMultipleThreads") && (getParameter("operation:doMultipleThreads") != 0)) ||
       (hasParameter("operation:infeedMode") && (getParameter("operation:infeedMode") != "constant"))) {
      var r = -cycle.incrementalX; // positive if taper goes down - delta radius
      moveToThreadStart(x, y, z);
      xOutput.reset();
      zOutput.reset();
      writeBlock(
        gMotionModal.format(92),
        xOutput.format(x),
        yOutput.format(y),
        zOutput.format(z),
        conditional(zFormat.isSignificant(r), g92ROutput.format(r)),
        pitchOutput.format(cycle.pitch)
      );
    } else {
      if (isLastCyclePoint()) {
        // thread height and depth of cut
        var threadHeight = getParameter("operation:threadDepth");
        var firstDepthOfCut = threadHeight / getParameter("operation:numberOfStepdowns");

        // first G76 block
        var repeatPass = hasParameter("operation:nullPass") ? getParameter("operation:nullPass") : 1; // Allowed value 1-99
        if (repeatPass < 1) {
          repeatPass = 1;
        }
        var chamferWidth = 10; // Pullout-width is 1*thread-lead in 1/10's;
        var materialAllowance = 0; // Material allowance for finishing pass
        var cuttingAngle = getParameter("operation:infeedAngle", 30) * 2; // Angle is not stored with tool. toDeg(tool.getTaperAngle());
        var pcode = repeatPass * 10000 + chamferWidth * 100 + cuttingAngle;
        gCycleModal.reset();
        writeBlock(
          gCycleModal.format(76),
          threadP1Output.format(pcode),
          threadQOutput.format(firstDepthOfCut),
          threadROutput.format(materialAllowance)
        );

        // second G76 block
        gCycleModal.reset();
        writeBlock(gCycleModal.format(76),
          xOutput.format(x),
          zOutput.format(z),
          threadROutput.format(-cycle.incrementalX),
          threadP2Output.format(threadHeight),
          threadQOutput.format(firstDepthOfCut),
          pitchOutput.format(cycle.pitch)
        );
      }
    }
    forceFeed();
    return;
  }

  // clamp the C-axis if necessary
  // the C-axis is automatically unclamped by the controllers during cycles
  if (!machineState.axialCenterDrilling && !machineState.isTurningOperation) {
    lockCode = mFormat.format(getCode("LOCK_MULTI_AXIS", getSpindle(PART)));
  }

  var rapto = 0;
  if (isFirstCyclePoint()) { // first cycle point
    // rapto = (getSpindle(PART) == SPINDLE_SUB) ? cycle.clearance - cycle.retract :  cycle.retract - cycle.clearance; // incremental
    rapto = ((getSpindle(PART) == SPINDLE_SUB) && (getMachiningDirection(currentSection) == MACHINING_DIRECTION_AXIAL)) ? cycle.retract * -1 : cycle.retract; // absolute

    var F = (gFeedModeModal.getCurrent() == 95 ? cycle.feedrate / spindleSpeed : cycle.feedrate);
    var P = !cycle.dwell ? 0 : cycle.dwell; // in seconds

    switch (cycleType) {
    case "drilling":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(81),
        getCommonCycle(x, y, z, rapto, true),
        feedOutput.format(F)
      );
      break;
    case "counter-boring":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(82),
        getCommonCycle(x, y, z, rapto, true),
        conditional(P > 0, pOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "chip-breaking":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(83.1),
        getCommonCycle(x, y, z, rapto, true),
        conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
        conditional(P > 0, pOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "deep-drilling":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(83),
        getCommonCycle(x, y, z, rapto, true),
        conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
        conditional(P > 0, pOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "tapping":
    case "right-tapping":
    case "left-tapping":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      //startSpindle(true, false);
      reverseTap = tool.type == TOOL_TAP_LEFT_HAND;
      var gCode = reverseTap ? 84.1 : 84;
      if (getProperty("useRigidTapping")) {
        writeBlock(mFormat.format(29));
      }
      writeBlock(
        gCycleModal.format(gCode),
        getCommonCycle(x, y, z, rapto, true),
        conditional(P > 0, pOutput.format(P)),
        pitchOutput.format(F)
      );
      break;
    case "tapping-with-chip-breaking":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      if (!F) {
        F = tool.getTappingFeedrate();
      }
      //startSpindle(true, false);
      reverseTap = tool.type == TOOL_TAP_LEFT_HAND;
      var gCode = reverseTap ? 84.1 : 84;
      if (getProperty("useRigidTapping")) {
        writeBlock(mFormat.format(29));
      }
      writeBlock(
        gCycleModal.format(gCode),
        getCommonCycle(x, y, z, rapto, true),
        conditional(cycle.incrementalDepth > 0, peckOutput.format(cycle.incrementalDepth)),
        conditional(P > 0, pOutput.format(P)),
        pitchOutput.format(F)
      );
      break;
    case "boring":
      if (feedFormat.getResultingValue(cycle.feedrate) != feedFormat.getResultingValue(cycle.retractFeedrate)) {
        expandCyclePoint(x, y, z);
        break;
      }
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(85),
        getCommonCycle(x, y, z, rapto, true),
        conditional(P > 0, pOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    case "stop-boring":
      writeCycleClearance(plane, cycle.clearance);
      localZOutput.reset();
      writeBlock(
        gCycleModal.format(86),
        getCommonCycle(x, y, z, rapto, true),
        conditional(P > 0, pOutput.format(P)),
        feedOutput.format(F)
      );
      break;
    default:
      expandCyclePoint(x, y, z);
    }
  } else { // position to subsequent cycle points
    if (cycleExpanded) {
      expandCyclePoint(x, y, z);
    } else {
      var step = 0;
      if (cycleType == "chip-breaking" || cycleType == "deep-drilling") {
        step = cycle.incrementalDepth;
      }
      writeBlock(getCommonCycle(x, y, z, rapto, false), conditional(step > 0, peckOutput.format(step))
      );
    }
  }
}

function onCycleEnd() {
  if (!cycleExpanded && !machineState.stockTransferIsActive) {
    if (cycleType == "thread-turning") {
      gMotionModal.reset();
      writeBlock(gMotionModal.format(0));
      gCycleModal.format(80);
    } else {
      writeBlock(gCycleModal.format(80));
      gMotionModal.reset();
    }
  }
}

var saveShowSequenceNumbers;
var pathBlockNumber = {start:0, end:0};

function onCyclePath() {
  saveShowSequenceNumbers = showSequenceNumbers;

  // buffer all paths and stop feeds being output
  feedOutput.disable();
  showSequenceNumbers = "false";
  redirectToBuffer();
  gMotionModal.reset();
  xOutput.reset();
  zOutput.reset();
}

function onCyclePathEnd() {
  showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  feedOutput.enable();
  var cyclePath = String(getRedirectionBuffer()).split(EOL); // get cycle path from buffer
  closeRedirection();
  for (line in cyclePath) { // remove empty elements
    if (cyclePath[line] == "") {
      cyclePath.splice(line);
    }
  }

  var verticalPasses;
  if (cycle.profileRoughingCycle == 0) {
    verticalPasses = false;
  } else if (cycle.profileRoughingCycle == 1) {
    verticalPasses = true;
  } else {
    error(localize("Unsupported passes type."));
    return;
  }
  // output cycle data
  switch (cycleType) {
  case "turning-canned-rough":
    writeBlock(gFormat.format(verticalPasses ? 72 : 71),
      (verticalPasses ? "W" : "U") + spatialFormat.format(cycle.depthOfCut),
      "R" + spatialFormat.format(cycle.retractLength)
    );
    writeBlock(gFormat.format(verticalPasses ? 72 : 71),
      "P" + (getStartEndSequenceNumber(cyclePath, true)),
      "Q" + (getStartEndSequenceNumber(cyclePath, false)),
      "U" + xFormat.format(cycle.xStockToLeave),
      "W" + spatialFormat.format(cycle.zStockToLeave),
      getFeed(cycle.cutfeedrate)
    );
    break;
  default:
    error(localize("Unsupported turning canned cycle."));
  }

  for (var i = 0; i < cyclePath.length; ++i) {
    if (i == 0 || i == (cyclePath.length - 1)) { // write sequence number on first and last line of the cycle path
      showSequenceNumbers = "true";
      if ((i == 0 && pathBlockNumber.start != sequenceNumber) || (i == (cyclePath.length - 1) && pathBlockNumber.end != sequenceNumber)) {
        error(localize("Mismatch of start/end block number in turning canned cycle."));
        return;
      }
    }
    writeBlock(cyclePath[i]); // output cycle path
    showSequenceNumbers = saveShowSequenceNumbers; // reset property to initial state
  }
}

function getStartEndSequenceNumber(cyclePath, start) {
  if (start) {
    pathBlockNumber.start = sequenceNumber + conditional(saveShowSequenceNumbers == "true", getProperty("sequenceNumberIncrement"));
    return pathBlockNumber.start;
  } else {
    pathBlockNumber.end = sequenceNumber + getProperty("sequenceNumberIncrement") + conditional(saveShowSequenceNumbers == "true", (cyclePath.length - 1) * getProperty("sequenceNumberIncrement"));
    return pathBlockNumber.end;
  }
}

function onPassThrough(text) {
  writeBlock(text);
}

function onParameter(name, value) {
  var invalid = false;
  switch (name) {
  case "action":
    if (String(value).toUpperCase() == "PARTEJECT") {
      ejectRoutine = true;
    } else if (String(value).toUpperCase() == "USEXZCMODE") {
      forceXZCMode = true;
      forcePolarMode = false;
    } else if (String(value).toUpperCase() == "USEPOLARMODE") {
      forcePolarMode = true;
      forceXZCMode = false;
    } else {
      invalid = true;
    }
  }
  if (invalid) {
    error(localize("Invalid action parameter: ") + sText2[0] + ":" + sText2[1]);
    return;
  }
}

function parseToggle() {
  var stat = undefined;
  for (i = 1; i < arguments.length; i++) {
    if (String(arguments[0]).toUpperCase() == String(arguments[i]).toUpperCase()) {
      if (String(arguments[i]).toUpperCase() == "YES") {
        stat = true;
      } else if (String(arguments[i]).toUpperCase() == "NO") {
        stat = false;
      } else {
        stat = i - 1;
        break;
      }
    }
  }
  return stat;
}

var currentCoolantMode = COOLANT_OFF;
var currentCoolantTurret = 1;
var coolantOff = undefined;
var isOptionalCoolant = false;
var forceCoolant = false;

function setCoolant(coolant, turret) {
  var coolantCodes = getCoolantCodes(coolant, turret);
  if (Array.isArray(coolantCodes)) {
    if (singleLineCoolant) {
      skipBlock = isOptionalCoolant;
      writeBlock(coolantCodes.join(getWordSeparator()));
    } else {
      for (var c in coolantCodes) {
        skipBlock = isOptionalCoolant;
        writeBlock(coolantCodes[c]);
      }
    }
    return undefined;
  }
  return coolantCodes;
}

function getCoolantCodes(coolant, turret) {
  turret = gotMultiTurret ? (turret == undefined ? 1 : turret) : 1;
  isOptionalCoolant = false;
  var multipleCoolantBlocks = new Array(); // create a formatted array to be passed into the outputted line
  if (!coolants) {
    error(localize("Coolants have not been defined."));
  }
  if (tool.type == TOOL_PROBE) { // avoid coolant output for probing
    coolant = COOLANT_OFF;
  }
  if (coolant == currentCoolantMode && turret == currentCoolantTurret) {
    if ((typeof operationNeedsSafeStart != "undefined" && operationNeedsSafeStart) && coolant != COOLANT_OFF) {
      isOptionalCoolant = true;
    } else if (!forceCoolant || coolant == COOLANT_OFF) {
      return undefined; // coolant is already active
    }
  }
  if ((coolant != COOLANT_OFF) && (currentCoolantMode != COOLANT_OFF) && (coolantOff != undefined) && !forceCoolant && !isOptionalCoolant) {
    if (Array.isArray(coolantOff)) {
      for (var i in coolantOff) {
        multipleCoolantBlocks.push(coolantOff[i]);
      }
    } else {
      multipleCoolantBlocks.push(coolantOff);
    }
  }
  forceCoolant = false;

  var m;
  var coolantCodes = {};
  for (var c in coolants) { // find required coolant codes into the coolants array
    if (coolants[c].id == coolant) {
      var localCoolant = parseCoolant(coolants[c], turret);
      localCoolant = typeof localCoolant == "undefined" ? coolants[c] : localCoolant;
      coolantCodes.on = localCoolant.on;
      if (localCoolant.off != undefined) {
        coolantCodes.off = localCoolant.off;
        break;
      } else {
        for (var i in coolants) {
          if (coolants[i].id == COOLANT_OFF) {
            coolantCodes.off = localCoolant.off;
            break;
          }
        }
      }
    }
  }
  if (coolant == COOLANT_OFF) {
    m = !coolantOff ? coolantCodes.off : coolantOff; // use the default coolant off command when an 'off' value is not specified
  } else {
    coolantOff = coolantCodes.off;
    m = coolantCodes.on;
  }

  if (!m) {
    onUnsupportedCoolant(coolant);
    m = 9;
  } else {
    if (Array.isArray(m)) {
      for (var i in m) {
        multipleCoolantBlocks.push(m[i]);
      }
    } else {
      multipleCoolantBlocks.push(m);
    }
    currentCoolantMode = coolant;
    currentCoolantTurret = turret;
    for (var i in multipleCoolantBlocks) {
      if (typeof multipleCoolantBlocks[i] == "number") {
        multipleCoolantBlocks[i] = mFormat.format(multipleCoolantBlocks[i]);
      }
    }
    return multipleCoolantBlocks; // return the single formatted coolant value
  }
  return undefined;
}

function parseCoolant(coolant, turret) {
  var localCoolant;
  if (getSpindle(PART) == SPINDLE_MAIN) {
    localCoolant = turret == 1 ? coolant.spindle1t1 : coolant.spindle1t2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindle1 : localCoolant;
  } else if (getSpindle(PART) == SPINDLE_LIVE) {
    localCoolant = turret == 1 ? coolant.spindleLivet1 : coolant.spindleLivet2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindleLive : localCoolant;
  } else {
    localCoolant = turret == 1 ? coolant.spindle2t1 : coolant.spindle2t2;
    localCoolant = typeof localCoolant == "undefined" ? coolant.spindle2 : localCoolant;
  }
  localCoolant = typeof localCoolant == "undefined" ? (turret == 1 ? coolant.turret1 : coolant.turret2) : localCoolant;
  localCoolant = typeof localCoolant == "undefined" ? coolant : localCoolant;
  return localCoolant;
}

function isSpindleSpeedDifferent() {
  if (isFirstSection()) {
    return true;
  }
  if (getPreviousSection().getTool().clockwise != tool.clockwise) {
    if (getPreviousSection().getTool().number == currentSection.getTool().number) {
      onCommand(COMMAND_STOP_SPINDLE);
    }
    return true;
  }
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SURFACE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().surfaceSpeed, tool.surfaceSpeed)) {
      return true;
    }
  } else {
    if ((getPreviousSection().getTool().getSpindleMode() != SPINDLE_CONSTANT_SPINDLE_SPEED) ||
        rpmFormat.areDifferent(getPreviousSection().getTool().spindleRPM, spindleSpeed)) {
      return true;
    }
  }
  return false;
}

function onSpindleSpeed(spindleSpeed) {
  if (rpmFormat.areDifferent(spindleSpeed, sOutput.getCurrent())) {
    startSpindle(false, false, getFramePosition(currentSection.getInitialPosition()), spindleSpeed);
  }
}

function startSpindle(tappingMode, forceRPMMode, initialPosition, rpm) {
  var spindleDir;
  var spindleMode;
  var _spindleSpeed = spindleSpeed;
  if (rpm !== undefined) {
    _spindleSpeed = rpm;
  }

  if ((getSpindle(PART) == SPINDLE_SUB) && !gotSecondarySpindle) {
    error(localize("Secondary spindle is not available."));
    return;
  }

  if (tappingMode) {
    spindleDir = mFormat.format(getCode("RIGID_TAPPING", getSpindle(TOOL)));
  } else {
    spindleDir = mFormat.format(tool.clockwise ? getCode("START_SPINDLE_CW", getSpindle(TOOL)) : getCode("START_SPINDLE_CCW", getSpindle(TOOL)));
  }

  var maximumSpindleSpeed = (tool.maximumSpindleSpeed > 0) ? Math.min(tool.maximumSpindleSpeed, getProperty("maximumSpindleSpeed")) : getProperty("maximumSpindleSpeed");
  if (tool.getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) {
    if (getSpindle(TOOL) == SPINDLE_LIVE) {
      error(localize("Constant surface speed not supported with live tool."));
      return;
    }
    _spindleSpeed = tool.surfaceSpeed * ((unit == MM) ? 1 / 1000.0 : 1 / 12.0);
    if (forceRPMMode) { // RPM mode is forced until move to initial position
      if (xFormat.getResultingValue(initialPosition.x) == 0) {
        _spindleSpeed = maximumSpindleSpeed;
      } else {
        _spindleSpeed = Math.min((_spindleSpeed * ((unit == MM) ? 1000.0 : 12.0) / (Math.PI * Math.abs(initialPosition.x * 2))), maximumSpindleSpeed);
      }
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(TOOL));
    } else {
      spindleMode = getCode("CONSTANT_SURFACE_SPEED_ON", getSpindle(TOOL));
    }
  } else {
    spindleMode = getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(TOOL));
  }

  writeBlock(
    gSpindleModeModal.format(spindleMode),
    sOutput.format(_spindleSpeed),
    spindleDir
  );
  // wait for spindle here if required
}

/** Positions the sub spindle */
function moveSubSpindle(_method, _position, _feed, _useMachineFrame, _comment, _error) {
  if (!gotSecondarySpindle) {
    return;
  }
  gMotionModal.reset();
  if (machineState.spindlesAreAttached) {
    if (_error) {
      error(localize("An attempt was made to position the sub-spindle with both chucks clamped."));
    }
    return;
  }
  switch (_method) {
  case HOME:
    if ((getProperty("useTailStock") == "false") || !machineState.tailstockIsActive) { // don't retract B-axis if used as a tailstock
      if (getProperty("safePositionMethod") == "G28") {
        writeBlock(gFormat.format(91));
        writeBlock(
          gFormat.format(152), // tells control that subspindle is moving
          gMotionModal.format(28),
          subOutput.format(0),
          conditional(_comment, formatComment(_comment))
        );
        writeBlock(gFormat.format(90));
      } else {
        writeBlock(
          gFormat.format(55),
          gFormat.format(152), // tells control that subspindle is moving
          gMotionModal.format(0),
          subOutput.format(0),
          conditional(_comment, formatComment(_comment))
        );
      }
    }
    break;
  case RAPID:
    writeBlock(
      gFormat.format(152), // tells control that subspindle is moving
      gMotionModal.format(0),
      subOutput.format(_position),
      conditional(_comment, formatComment(_comment))
    );
    break;
  case FEED:
    writeBlock(gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL))));
    writeBlock(
      gFormat.format(152), // tells control that subspindle is moving
      gMotionModal.format(1),
      subOutput.format(_position),
      getFeed(_feed),
      conditional(_comment, formatComment(_comment))
    );
    break;
  case TORQUE:
    writeBlock(gFeedModeModal.format(getCode("FEED_MODE_MM_MIN", getSpindle(TOOL))));
    if (transferUseTorque) {
      writeBlock(mFormat.format(getCode("TORQUE_SKIP_ON", getSpindle(PART))));
    }
    writeBlock(
      gFormat.format(152), // tells control that subspindle is moving
      gMotionModal.format(1),
      conditional(transferUseTorque, gFormat.format(6)), // block skip
      subOutput.format(_position),
      getFeed(_feed),
      conditional(_comment, formatComment(_comment))
    );
    if (transferUseTorque) {
      writeBlock(mFormat.format(getCode("TORQUE_SKIP_OFF", getSpindle(PART))));
    }
    break;
  }
}

function onCommand(command) {
  switch (command) {
  case COMMAND_COOLANT_OFF:
    setCoolant(COOLANT_OFF);
    break;
  case COMMAND_COOLANT_ON:
    setCoolant(COOLANT_FLOOD);
    break;
  case COMMAND_LOCK_MULTI_AXIS:
    writeBlock(cAxisBrakeModal.format(getCode("LOCK_MULTI_AXIS", getSpindle(PART))));
    break;
  case COMMAND_UNLOCK_MULTI_AXIS:
    writeBlock(cAxisBrakeModal.format(getCode("UNLOCK_MULTI_AXIS", getSpindle(PART))));
    break;
  case COMMAND_START_CHIP_TRANSPORT:
    writeBlock(mFormat.format(24), formatComment("CHIP CONVEYOR START"));
    break;
  case COMMAND_STOP_CHIP_TRANSPORT:
    writeBlock(mFormat.format(25), formatComment("CHIP CONVEYOR STOP"));
    break;
  case COMMAND_OPEN_DOOR:
    if (gotDoorControl) {
      writeBlock(mFormat.format(85), formatComment("AUTOMATIC DOOR OPEN")); // optional
    }
    break;
  case COMMAND_CLOSE_DOOR:
    if (gotDoorControl) {
      writeBlock(mFormat.format(86), formatComment("AUTOMATIC DOOR CLOSE")); // optional
    }
    break;
  case COMMAND_BREAK_CONTROL:
    break;
  case COMMAND_TOOL_MEASURE:
    break;
  case COMMAND_ACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_DEACTIVATE_SPEED_FEED_SYNCHRONIZATION:
    break;
  case COMMAND_STOP:
    writeBlock(mFormat.format(0));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_OPTIONAL_STOP:
    writeBlock(mFormat.format(1));
    forceSpindleSpeed = true;
    forceCoolant = true;
    break;
  case COMMAND_END:
    writeBlock(mFormat.format(2));
    break;
  case COMMAND_STOP_SPINDLE:
    writeBlock(
      mFormat.format(getCode("STOP_SPINDLE", activeSpindle))
    );
    sOutput.reset();
    break;
  case COMMAND_ORIENTATE_SPINDLE:
    if (machineState.isTurningOperation || machineState.axialCenterDrilling) {
      writeBlock(mFormat.format(getCode("ORIENT_SPINDLE", getSpindle(PART))));
    } else {
      error(localize("Spindle orientation is not supported for live tooling."));
      return;
    }
    break;
  case COMMAND_SPINDLE_CLOCKWISE:
    writeBlock(mFormat.format(getCode("START_SPINDLE_CW", getSpindle(PART))));
    break;
  case COMMAND_SPINDLE_COUNTERCLOCKWISE:
    writeBlock(mFormat.format(getCode("START_SPINDLE_CCW", getSpindle(PART))));
    break;
  // case COMMAND_CLAMP: // add support for clamping
  // case COMMAND_UNCLAMP: // add support for clamping
  default:
    onUnsupportedCommand(command);
  }
}

/** Get synchronization/transfer code based on part cutoff spindle direction. */
function getSpindleTransferCodes() {
  var transferCodes = {direction:0, spindleMode:SPINDLE_CONSTANT_SPINDLE_SPEED, surfaceSpeed:0, maximumSpindleSpeed:0};
  transferCodes.spindleDirection = isFirstSection() ? true : getPreviousSection().getTool().clockwise; // clockwise
  transferCodes.spindleRPM = cycle.spindleSpeed;
  if (isLastSection()) {
    return transferCodes;
  }
  var numberOfSections = getNumberOfSections();
  for (var i = getNextSection().getId(); i < numberOfSections; ++i) {
    var section = getSection(i);
    if (section.getParameter("operation-strategy") == "turningSecondarySpindleReturn") {
      continue;
    } else if (section.getType() != TYPE_TURNING || section.spindle != SPINDLE_PRIMARY) {
      break;
    } else if (section.getType() == TYPE_TURNING) {
      var tool = section.getTool();
      transferCodes.spindleMode = tool.getSpindleMode();
      transferCodes.spindleRPM = tool.spindleRPM;
      transferCodes.surfaceSpeed = tool.surfaceSpeed;
      transferCodes.maximumSpindleSpeed = tool.maximumSpindleSpeed;
      transferCodes.spindleDirection = tool.clockwise;
      break;
    }
  }
  return transferCodes;
}

function getG17Code() {
  if (gotYAxis) {
    return (machineState.usePolarMode) ? 17 : 17;
  } else {
    return (machineState.usePolarMode) ? 17 : 18;
  }
}

function ejectPart() {
  writeln("");
  if (getProperty("showSequenceNumbers") == "toolChange") {
    writeCommentSeqno(localize("PART EJECT"));
  } else {
    writeComment(localize("PART EJECT"));
  }
  gMotionModal.reset();
  moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
  goHome(false); // Position all axes to home position
  setCoolant(COOLANT_THROUGH_TOOL);
  gSpindleModeModal.reset();
  writeBlock(
    gSpindleModeModal.format(getCode("CONSTANT_SURFACE_SPEED_OFF", getSpindle(PART))),
    sOutput.format(50),
    mFormat.format(getCode("START_SPINDLE_CW", getSpindle(PART)))
  );

  if (getProperty("usePartCatcher")) {
    writeBlock(mFormat.format(getCode("PART_CATCHER_ON", getSpindle(PART)))); // tag: m57 w/eject
  }
  writeBlock(mFormat.format(getCode("UNCLAMP_CHUCK", getSpindle(PART))));
  onDwell(1.5);
  // writeBlock(mFormat.format(getCode("CYCLE_PART_EJECTOR")));
  // onDwell(0.5);
  if (getProperty("usePartCatcher")) {
    writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", getSpindle(PART))));
    onDwell(1.1);
  }

  // clean out chips
  if (airCleanChuck) {
    writeBlock(mFormat.format(getCode("COOLANT_AIR_ON", getSpindle(PART))));
    onDwell(2.5);
    writeBlock(mFormat.format(getCode("COOLANT_AIR_OFF", getSpindle(PART))));
  }
  writeBlock(mFormat.format(getCode("STOP_SPINDLE", getSpindle(PART))));
  setCoolant(COOLANT_OFF);
  writeComment(localize("END OF PART EJECT"));
  writeln("");
}

function engagePartCatcher(engage) {
  if (getProperty("usePartCatcher")) {
    if (engage) { // engage part catcher
      gMotionModal.reset();
      var f = (unit == IN) ? 50 : 1250;
      writeln("");
      if (getProperty("partCatcherPosition") != 0) {
        moveSubSpindle(RAPID, getProperty("partCatcherPosition"), 0, true, "SUB SPINDLE ADVANCE", true);
      }
      writeBlock(mFormat.format(getCode("PART_CATCHER_ON", true)), formatComment(localize("PART CATCHER ON")));
      if (getProperty("partCatcherPosition") != 0) {
        writeBlock(gFeedModeModal.format(94));
        moveSubSpindle(FEED, 0, f, true, "SUB SPINDLE FEED", true);
      }
      writeln("");
    } else { // disengage part catcher
      onCommand(COMMAND_COOLANT_OFF);
      writeln("");
      if (getProperty("partCatcherPosition") != 0) {
        moveSubSpindle(HOME, 0, 0, true, "SUB SPINDLE RETURN", true);
      }
      writeBlock(mFormat.format(getCode("PART_CATCHER_OFF", true)), formatComment(localize("PART CATCHER OFF")));
      writeln("");
    }
  }
}

function onSectionEnd() {

  if (machineState.usePolarMode) {
    setPolarMode(false); // disable polar interpolation mode
  }

  // cancel SFM mode to preserve spindle speed
  if ((currentSection.getTool().getSpindleMode() == SPINDLE_CONSTANT_SURFACE_SPEED) && !machineState.stockTransferIsActive) {
    startSpindle(false, true, getFramePosition(currentSection.getFinalPosition()));
  }

  if (getProperty("usePartCatcher") && partCutoff && currentSection.partCatcher) {
    engagePartCatcher(false);
  }

  if (((getCurrentSectionId() + 1) >= getNumberOfSections()) ||
      (tool.number != getNextSection().getTool().number)) {
    onCommand(COMMAND_BREAK_CONTROL);
  }

  if (getSpindle(PART) == SPINDLE_SUB || machineState.machiningDirection == MACHINING_DIRECTION_RADIAL) {
    invertAxes(false, true);
  }
  forceXZCMode = false;
  forcePolarMode = false;
  partCutoff = false;
  forceAny();
  forceFeed();
}

function onClose() {

  optionalSection = false;
  onCommand(COMMAND_STOP_SPINDLE);
  setCoolant(COOLANT_OFF);

  //writeln("");

  if (getProperty("gotChipConveyor")) {
    onCommand(COMMAND_STOP_CHIP_TRANSPORT);
  }

  gMotionModal.reset();

  // Move to home position
  goHome(false);

  if (machineState.tailstockIsActive) {
    writeBlock(mFormat.format(getCode("TAILSTOCK_OFF", SPINDLE_MAIN)));
  }

  // Automatically eject part
  if (ejectRoutine) {
    ejectPart();
  }

  //writeln("");
  onImpliedCommand(COMMAND_END);

  if (getProperty("looping")) {
    writeBlock(mFormat.format(230), formatComment(localize("Increment part counter"))); //increment part counter
    writeBlock(mFormat.format(99));
  } else {
    onCommand(COMMAND_OPEN_DOOR);
    writeBlock(mFormat.format(30)); // stop program, spindle stop, coolant off
  }
  writeln("%");
}

function setProperty(property, value) {
  properties[property].current = value;
}
// <<<<< INCLUDED FROM ../common/hurco mill-turn winmax.cps
properties.maximumSpindleSpeed.value = 4500;
