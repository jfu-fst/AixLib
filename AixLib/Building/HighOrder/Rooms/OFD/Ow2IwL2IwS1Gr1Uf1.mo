within AixLib.Building.HighOrder.Rooms.OFD;
model Ow2IwL2IwS1Gr1Uf1
  "2 outer walls, 2 inner walls load, 1 inner wall simple, 1 floor towards ground, 1 ceiling towards upper floor"
  import AixLib;
  ///////// construction parameters
  parameter Integer TMC = 1 "Themal Mass Class" annotation(Dialog(group = "Construction parameters", compact = true, descriptionLabel = true), choices(choice = 1 "S", choice = 2 "M", choice = 3 "L", radioButtons = true));
  parameter Integer TIR = 1 "Thermal Insulation Regulation" annotation(Dialog(group = "Construction parameters", compact = true, descriptionLabel = true), choices(choice = 1
        "EnEV_2009",                                                                                                    choice = 2
        "EnEV_2002",                                                                                                    choice = 3
        "WSchV_1995",                                                                                                    choice = 4
        "WSchV_1984",                                                                                                    radioButtons = true));
  parameter Boolean withFloorHeating = false
    "If true, that floor has different connectors"                                          annotation(Dialog(group = "Construction parameters"), choices(checkBox = true));
  parameter Modelica.SIunits.Temperature T0_air = 295.15 "Air" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_OW1 = 295.15 "OW1" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_OW2 = 295.15 "OW2" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_IW1a = 295.15 "IW1a" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_IW1b = 295.15 "IW1b" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_IW2 = 295.15 "IW2" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_CE = 295.13 "Ceiling" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T0_FL = 295.13 "Floor" annotation(Dialog(tab = "Initial temperatures", descriptionLabel = true));
  //////////room geometry
  parameter Modelica.SIunits.Length room_length = 2 "length " annotation(Dialog(group = "Dimensions", descriptionLabel = true));
  parameter Modelica.SIunits.Length room_lengthb = 1 "length_b " annotation(Dialog(group = "Dimensions", descriptionLabel = true));
  parameter Modelica.SIunits.Length room_width = 2 "width " annotation(Dialog(group = "Dimensions", descriptionLabel = true));
  parameter Modelica.SIunits.Height room_height = 2 "height" annotation(Dialog(group = "Dimensions", descriptionLabel = true));
  // Outer walls properties
  parameter Real solar_absorptance_OW = 0.25 "Solar absoptance outer walls " annotation(Dialog(group = "Outer wall properties", descriptionLabel = true));
  parameter Modelica.SIunits.Temperature T_Ground = 278.15 "Ground Temperature"
                                                                                annotation(Dialog(group = "Outer wall properties", descriptionLabel = true));
  parameter Integer ModelConvOW = 1 "Heat Convection Model" annotation(Dialog(group = "Outer wall properties", compact = true, descriptionLabel = true), choices(choice = 1
        "DIN 6946",                                                                                                    choice = 2
        "ASHRAE Fundamentals",                                                                                                    choice = 3
        "Custom alpha",                                                                                                    radioButtons = true));
  // Windows and Doors
  parameter Boolean withWindow1 = true "Window 1" annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true), choices(checkBox = true));
  parameter Modelica.SIunits.Area windowarea_OW1 = 0 "Window area " annotation(Dialog(group = "Windows and Doors", descriptionLabel = true, enable = withWindow1));
  parameter Boolean withWindow2 = true "Window 2 " annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true), choices(checkBox = true));
  parameter Modelica.SIunits.Area windowarea_OW2 = 0 "Window area" annotation(Dialog(group = "Windows and Doors", naturalWidth = 10, descriptionLabel = true, enable = withWindow2));
  parameter Boolean withDoor1 = true "Door 1" annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true), choices(checkBox = true));
  parameter Modelica.SIunits.Length door_width_OD1 = 0 "width " annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true, enable = withDoor1));
  parameter Modelica.SIunits.Length door_height_OD1 = 0 "height " annotation(Dialog(group = "Windows and Doors", descriptionLabel = true, enable = withDoor1));
  parameter Boolean withDoor2 = true "Door 2" annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true), choices(checkBox = true));
  parameter Modelica.SIunits.Length door_width_OD2 = 0 "width " annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true, enable = withDoor2));
  parameter Modelica.SIunits.Length door_height_OD2 = 0 "height " annotation(Dialog(group = "Windows and Doors", descriptionLabel = true, enable = withDoor2));
  // Dynamic Ventilation
  parameter Boolean withDynamicVentilation = false "Dynamic ventilation" annotation(Dialog(group = "Dynamic ventilation", descriptionLabel = true), choices(checkBox = true));
  parameter Modelica.SIunits.Temperature HeatingLimit = 288.15
    "Outside temperature at which the heating activates"                                                            annotation(Dialog(group = "Dynamic ventilation", descriptionLabel = true, enable = if withDynamicVentilation then true else false));
  parameter Real Max_VR = 10 "Maximal ventilation rate" annotation(Dialog(group = "Dynamic ventilation", descriptionLabel = true, enable = if withDynamicVentilation then true else false));
  parameter Modelica.SIunits.TemperatureDifference Diff_toTempset = 2
    "Difference to set temperature"                                                                   annotation(Dialog(group = "Dynamic ventilation", descriptionLabel = true, enable = if withDynamicVentilation then true else false));
  parameter Modelica.SIunits.Temperature Tset = 295.15 "Tset" annotation(Dialog(group = "Dynamic ventilation", descriptionLabel = true, enable = if withDynamicVentilation then true else false));
  //Door properties
  AixLib.Building.Components.Walls.Wall outside_wall1(solar_absorptance = solar_absorptance_OW, windowarea = windowarea_OW1, T0 = T0_OW1, door_height = door_height_OD1, door_width = door_width_OD1, wall_length = room_length, wall_height = room_height, withWindow = withWindow1, withDoor = withDoor1, WallType = Type_OW, WindowType = Type_Win, U_door = U_door_OD1, eps_door = eps_door_OD1) annotation(Placement(transformation(extent = {{-64, -22}, {-54, 36}}, rotation = 0)));
  AixLib.Building.Components.Walls.Wall outside_wall2(solar_absorptance = solar_absorptance_OW, windowarea = windowarea_OW2, T0 = T0_OW2, door_height = door_height_OD2, door_width = door_width_OD2, wall_length = room_width, wall_height = room_height, withWindow = withWindow2, withDoor = withDoor2, WallType = Type_OW, WindowType = Type_Win, U_door = U_door_OD2, eps_door = eps_door_OD2) annotation(Placement(transformation(origin = {23, 59}, extent = {{-4.99998, -27}, {5.00001, 27}}, rotation = 270)));
  AixLib.Building.Components.Walls.Wall inside_wall1a(T0 = T0_IW1a, outside = false, WallType = Type_IWload, wall_length = room_length - room_lengthb, wall_height = room_height, withWindow = false, withDoor = false) annotation(Placement(transformation(origin = {61, 24}, extent = {{-2.99999, -16}, {2.99999, 16}}, rotation = 180)));
  AixLib.Building.Components.Walls.Wall inside_wall2(T0 = T0_IW2, outside = false, WallType = Type_IWsimple, wall_length = room_width, wall_height = room_height, withWindow = false, withDoor = false) annotation(Placement(transformation(origin = {22, -60}, extent = {{-4.00002, -26}, {4.00001, 26}}, rotation = 90)));
  AixLib.Building.Components.DryAir.Airload airload(V = room_V, T(start = T0_air)) annotation(Placement(transformation(extent = {{0, -20}, {20, 0}}, rotation = 0)));
  AixLib.Building.Components.Walls.Wall Ceiling(T0 = T0_CE, outside = false, WallType = Type_CE, wall_length = room_length, wall_height = room_width, withWindow = false, withDoor = false, ISOrientation = 3) annotation(Placement(transformation(origin = {-30, 61}, extent = {{2.99997, -16}, {-3.00002, 16}}, rotation = 90)));
  AixLib.Building.Components.Walls.Wall floor(T0 = T0_FL, outside = false, WallType = Type_FL, wall_length = room_length, wall_height = room_width, withWindow = false, withDoor = false, ISOrientation = 2) if withFloorHeating == false annotation(Placement(transformation(origin = {-27, -60}, extent = {{-2.00002, -11}, {2.00001, 11}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermInsideWall2 annotation(Placement(transformation(extent = {{20, -100}, {40, -80}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermInsideWall1a annotation(Placement(transformation(extent = {{80, 20}, {100, 40}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermOutside annotation(Placement(transformation(extent = {{-100, 80}, {-80, 100}}, rotation = 0), iconTransformation(extent = {{-100, 80}, {-80, 100}})));
  Modelica.Blocks.Interfaces.RealInput WindSpeedPort annotation(Placement(transformation(extent = {{-109.5, -50}, {-89.5, -30}}, rotation = 0)));
  Utilities.Interfaces.SolarRad_in SolarRadiationPort_OW1 annotation(Placement(transformation(extent = {{-109.5, 20}, {-89.5, 40}}, rotation = 0)));
  Utilities.Interfaces.SolarRad_in SolarRadiationPort_OW2 annotation(Placement(transformation(origin = {50.5, 101}, extent = {{-10, -10}, {10, 10}}, rotation = 270), iconTransformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {50.5, 99})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermCeiling annotation(Placement(transformation(extent = {{80, 60}, {100, 80}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermRoom annotation(Placement(transformation(extent = {{-30, 10}, {-10, 30}})));
  Utilities.Interfaces.Star starRoom annotation(Placement(transformation(extent = {{10, 10}, {30, 30}})));
  Modelica.Blocks.Interfaces.RealInput AirExchangePort annotation(Placement(transformation(extent = {{-13, -13}, {13, 13}}, rotation = 270, origin = {-20, 100}), iconTransformation(extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 270, origin = {-20.5, 98.5})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature Ground annotation(Placement(transformation(extent = {{-24, -100}, {-4, -80}})));
  Modelica.Blocks.Sources.Constant GroundTemperature(k = T_Ground) annotation(Placement(transformation(extent = {{-60, -100}, {-40, -80}})));
  AixLib.Building.Components.Walls.Wall inside_wall1b(T0 = T0_IW1b, outside = false, WallType = Type_IWload, wall_length = room_lengthb, wall_height = room_height, withWindow = false, withDoor = false) annotation(Placement(transformation(origin = {61, -15}, extent = {{-3, -15}, {3, 15}}, rotation = 180)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermInsideWall1b annotation(Placement(transformation(extent = {{80, -20}, {100, 0}}, rotation = 0)));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor Tair annotation(Placement(transformation(extent = {{24, -20}, {38, -6}})));
  AixLib.Building.Components.DryAir.InfiltrationRate_DIN12831 infiltrationRate(room_V = room_V, n50 = n50, e = e, eps = eps) annotation(Placement(transformation(extent = {{-68, 44}, {-50, 52}})));
  AixLib.Building.Components.DryAir.DynamicVentilation dynamicVentilation(HeatingLimit = HeatingLimit, Max_VR = Max_VR, Diff_toTempset = Diff_toTempset, Tset = Tset) if withDynamicVentilation annotation(Placement(transformation(extent = {{-70, -66}, {-46, -54}})));
  Utilities.Interfaces.Adaptors.HeatStarToComb thermStar_Demux annotation(Placement(transformation(extent = {{-10, 8}, {10, -8}}, rotation = 90, origin = {-20, -26})));
  AixLib.Building.Components.DryAir.VarAirExchange NaturalVentilation(V = room_V) annotation(Placement(transformation(extent = {{-68, -50}, {-48, -30}})));
  AixLib.Building.Components.Walls.BaseClasses.SimpleNLayer floor_FH(h = room_width, l = room_length, n = Type_FL.n, d = Type_FL.d, rho = Type_FL.rho, lambda = Type_FL.lambda, c = Type_FL.c, T0 = T0_FL) if withFloorHeating
    "floor component if using Floor heating"                                                                                                     annotation(Placement(transformation(origin = {-22, -77}, extent = {{-3.00007, 16}, {3, -16}}, rotation = 90)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermFloor if withFloorHeating
    "thermal connector for floor heating"                                                                                  annotation(Placement(transformation(extent = {{-24, -72}, {-14, -62}}), iconTransformation(extent = {{-32, -34}, {-12, -14}})));
protected
  parameter Real U_door_OD1 = if TIR == 1 then 1.8 else 2.9 "U-value" annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true, enable = withDoor1));
  parameter Real eps_door_OD1 = 0.95 "eps" annotation(Dialog(group = "Windows and Doors", descriptionLabel = true, enable = withDoor1));
  parameter Real U_door_OD2 = if TIR == 1 then 1.8 else 2.9 "U-value" annotation(Dialog(group = "Windows and Doors", joinNext = true, descriptionLabel = true, enable = withDoor2));
  parameter Real eps_door_OD2 = 0.95 "eps" annotation(Dialog(group = "Windows and Doors", descriptionLabel = true, enable = withDoor2));
  // Infiltration rate
  parameter Real n50(unit = "h-1") = if TIR == 1 or TIR == 2 then 3 else if TIR == 3 then 4 else 6
    "Air exchange rate at 50 Pa pressure difference"                                                                                                annotation(Dialog(tab = "Infiltration"));
  parameter Real e = 0.03 "Coefficient of windshield" annotation(Dialog(tab = "Infiltration"));
  parameter Real eps = 1.0 "Coefficient of height" annotation(Dialog(tab = "Infiltration"));
  // Outer wall type
  parameter AixLib.DataBase.Walls.WallBaseDataDefinition Type_OW = if TIR == 1 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2009.OW.OW_EnEV2009_S() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2009.OW.OW_EnEV2009_M() else AixLib.DataBase.Walls.EnEV2009.OW.OW_EnEV2009_L() else if TIR == 2 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2002.OW.OW_EnEV2002_S() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2002.OW.OW_EnEV2002_M() else AixLib.DataBase.Walls.EnEV2002.OW.OW_EnEV2002_L() else if TIR == 3 then if TMC == 1 then AixLib.DataBase.Walls.WSchV1995.OW.OW_WSchV1995_S() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1995.OW.OW_WSchV1995_M() else AixLib.DataBase.Walls.WSchV1995.OW.OW_WSchV1995_L() else if TMC == 1 then AixLib.DataBase.Walls.WSchV1984.OW.OW_WSchV1984_S() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1984.OW.OW_WSchV1984_M() else AixLib.DataBase.Walls.WSchV1984.OW.OW_WSchV1984_L() annotation(Dialog(tab = "Types"));
  //Inner wall Types
  parameter AixLib.DataBase.Walls.WallBaseDataDefinition Type_IWsimple = if TIR == 1 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2009.IW.IWsimple_EnEV2009_S_half() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2009.IW.IWsimple_EnEV2009_M_half() else AixLib.DataBase.Walls.EnEV2009.IW.IWsimple_EnEV2009_L_half() else if TIR == 2 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2002.IW.IWsimple_EnEV2002_S_half() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2002.IW.IWsimple_EnEV2002_M_half() else AixLib.DataBase.Walls.EnEV2002.IW.IWsimple_EnEV2002_L_half() else if TIR == 3 then if TMC == 1 then AixLib.DataBase.Walls.WSchV1995.IW.IWsimple_WSchV1995_S_half() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1995.IW.IWsimple_WSchV1995_M_half() else AixLib.DataBase.Walls.WSchV1995.IW.IWsimple_WSchV1995_L_half() else if TMC == 1 then AixLib.DataBase.Walls.WSchV1984.IW.IWsimple_WSchV1984_S_half() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1984.IW.IWsimple_WSchV1984_M_half() else AixLib.DataBase.Walls.WSchV1984.IW.IWsimple_WSchV1984_L_half() annotation(Dialog(tab = "Types"));
  parameter AixLib.DataBase.Walls.WallBaseDataDefinition Type_IWload = if TIR == 1 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2009.IW.IWload_EnEV2009_S_half() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2009.IW.IWload_EnEV2009_M_half() else AixLib.DataBase.Walls.EnEV2009.IW.IWload_EnEV2009_L_half() else if TIR == 2 then if TMC == 1 then AixLib.DataBase.Walls.EnEV2002.IW.IWload_EnEV2002_S_half() else if TMC == 2 then AixLib.DataBase.Walls.EnEV2002.IW.IWload_EnEV2002_M_half() else AixLib.DataBase.Walls.EnEV2002.IW.IWload_EnEV2002_L_half() else if TIR == 3 then if TMC == 1 then AixLib.DataBase.Walls.WSchV1995.IW.IWload_WSchV1995_S_half() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1995.IW.IWload_WSchV1995_M_half() else AixLib.DataBase.Walls.WSchV1995.IW.IWload_WSchV1995_L_half() else if TMC == 1 then AixLib.DataBase.Walls.WSchV1984.IW.IWload_WSchV1984_S_half() else if TMC == 2 then AixLib.DataBase.Walls.WSchV1984.IW.IWload_WSchV1984_M_half() else AixLib.DataBase.Walls.WSchV1984.IW.IWload_WSchV1984_L_half() annotation(Dialog(tab = "Types"));
  // Floor to ground type
  parameter AixLib.DataBase.Walls.WallBaseDataDefinition Type_FL = if TIR == 1 then AixLib.DataBase.Walls.EnEV2009.Floor.FLground_EnEV2009_SML() else if TIR == 2 then AixLib.DataBase.Walls.EnEV2002.Floor.FLground_EnEV2002_SML() else if TIR == 3 then AixLib.DataBase.Walls.WSchV1995.Floor.FLground_WSchV1995_SML() else AixLib.DataBase.Walls.WSchV1984.Floor.FLground_WSchV1984_SML() annotation(Dialog(tab = "Types"));
  // Ceiling to upper floor type
  parameter AixLib.DataBase.Walls.WallBaseDataDefinition Type_CE = if TIR == 1 then if TMC == 1 or TMC == 2 then AixLib.DataBase.Walls.EnEV2009.Ceiling.CEpartition_EnEV2009_SM_loHalf() else AixLib.DataBase.Walls.EnEV2009.Ceiling.CEpartition_EnEV2009_L_loHalf() else if TIR == 2 then if TMC == 1 or TMC == 2 then AixLib.DataBase.Walls.EnEV2002.Ceiling.CEpartition_EnEV2002_SM_loHalf() else AixLib.DataBase.Walls.EnEV2002.Ceiling.CEpartition_EnEV2002_L_loHalf() else if TIR == 3 then if TMC == 1 or TMC == 2 then AixLib.DataBase.Walls.WSchV1995.Ceiling.CEpartition_WSchV1995_SM_loHalf() else AixLib.DataBase.Walls.WSchV1995.Ceiling.CEpartition_WSchV1995_L_loHalf() else if TMC == 1 or TMC == 2 then AixLib.DataBase.Walls.WSchV1984.Ceiling.CEpartition_WSchV1984_SM_loHalf() else AixLib.DataBase.Walls.WSchV1984.Ceiling.CEpartition_WSchV1984_L_loHalf() annotation(Dialog(tab = "Types"));
  //Window type
  parameter AixLib.DataBase.WindowsDoors.Simple.OWBaseDataDefinition_Simple Type_Win = if TIR == 1 then AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2009() else if TIR == 2 then AixLib.DataBase.WindowsDoors.Simple.WindowSimple_EnEV2002() else if TIR == 3 then AixLib.DataBase.WindowsDoors.Simple.WindowSimple_WSchV1995() else AixLib.DataBase.WindowsDoors.Simple.WindowSimple_WSchV1984() annotation(Dialog(tab = "Types"));
  parameter Modelica.SIunits.Volume room_V = room_length * room_width * room_height;
equation
  // Connect equations for dynamic ventilation
  if withDynamicVentilation then
    connect(thermOutside, dynamicVentilation.port_outside);
    connect(dynamicVentilation.port_inside, airload.port);
  end if;
  //Connect floor for cases with or without floor heating
  if withFloorHeating then
    connect(floor_FH.port_b, thermFloor) annotation(Line(points = {{-23.6, -74.3}, {-23.6, -67}, {-19, -67}}, color = {191, 0, 0}, smooth = Smooth.None, pattern = LinePattern.Dash));
    connect(floor_FH.port_a, Ground.port) annotation(Line(points = {{-23.6, -79.7001}, {-23.6, -90}, {-4, -90}}, color = {191, 0, 0}, smooth = Smooth.None, pattern = LinePattern.Dash));
  else
    connect(floor.port_outside, Ground.port) annotation(Line(points = {{-27, -62.1}, {-27, -90}, {-4, -90}}, color = {191, 0, 0}, smooth = Smooth.None, pattern = LinePattern.Dash));
    connect(floor.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{-27, -58}, {-27, -40}, {-20.1, -40}, {-20.1, -38}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None, pattern = LinePattern.Dash));
  end if;
  connect(thermInsideWall2, thermInsideWall2) annotation(Line(points = {{30, -90}, {30, -90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(GroundTemperature.y, Ground.T) annotation(Line(points = {{-39, -90}, {-30, -90}, {-30, -90}, {-26, -90}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(WindSpeedPort, outside_wall2.WindSpeedPort) annotation(Line(points = {{-99.5, -40}, {-80, -40}, {-80, 74}, {42.8, 74}, {42.8, 64.25}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(thermRoom, thermRoom) annotation(Line(points = {{-20, 20}, {-20, 20}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(thermOutside, thermOutside) annotation(Line(points = {{-90, 90}, {-90, 90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(thermOutside, outside_wall1.port_outside) annotation(Line(points = {{-90, 90}, {-90, 82}, {-80, 82}, {-80, 6}, {-68, 6}, {-68, 7}, {-64.25, 7}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(outside_wall1.WindSpeedPort, WindSpeedPort) annotation(Line(points = {{-64.25, 28.2667}, {-80, 28.2667}, {-80, -40}, {-99.5, -40}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(inside_wall1b.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{58, -15}, {52, -15}, {52, -40}, {-20, -40}, {-20, -38}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(inside_wall1a.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{58, 24}, {52, 24}, {52, -40}, {-20.1, -40}, {-20.1, -38}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(outside_wall1.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{-54, 7}, {-48, 6}, {-40, 6}, {-40, -40}, {-20.1, -40}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(outside_wall2.SolarRadiationPort, SolarRadiationPort_OW2) annotation(Line(points = {{47.75, 65.5}, {47.75, 74}, {50.5, 74}, {50.5, 88}, {50.5, 101}}, color = {255, 128, 0}, smooth = Smooth.None));
  connect(outside_wall2.port_outside, thermOutside) annotation(Line(points = {{23, 64.25}, {23, 74}, {-80, 74}, {-80, 82}, {-90, 82}, {-90, 90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(Ceiling.port_outside, thermCeiling) annotation(Line(points = {{-30, 64.15}, {-30, 64.15}, {-30, 74}, {84, 74}, {84, 70}, {90, 70}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(starRoom, thermStar_Demux.star) annotation(Line(points = {{20, 20}, {20, 4}, {-14.2, 4}, {-14.2, -15.6}}, color = {95, 95, 95}, pattern = LinePattern.None, smooth = Smooth.None));
  connect(outside_wall2.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{23, 54}, {23, 54}, {23, 40}, {-40, 40}, {-40, -40}, {-20.1, -40}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(inside_wall2.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{22, -56}, {22, -40}, {-20.1, -40}, {-20.1, -38}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(inside_wall2.port_outside, thermInsideWall2) annotation(Line(points = {{22, -64.2}, {22, -77.3}, {30, -77.3}, {30, -90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(inside_wall1a.port_outside, thermInsideWall1a) annotation(Line(points = {{64.15, 24}, {77.225, 24}, {77.225, 30}, {90, 30}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(inside_wall1b.port_outside, thermInsideWall1b) annotation(Line(points = {{64.15, -15}, {79.225, -15}, {79.225, -10}, {90, -10}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(thermStar_Demux.therm, airload.port) annotation(Line(points = {{-25.1, -15.9}, {-25.1, -12}, {1, -12}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(infiltrationRate.port_a, thermOutside) annotation(Line(points = {{-68, 48}, {-80, 48}, {-80, 82}, {-90, 82}, {-90, 90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(SolarRadiationPort_OW1, outside_wall1.SolarRadiationPort) annotation(Line(points = {{-99.5, 30}, {-80, 30}, {-80, 33.5833}, {-65.5, 33.5833}}, color = {255, 128, 0}, smooth = Smooth.None));
  connect(thermStar_Demux.therm, thermRoom) annotation(Line(points = {{-25.1, -15.9}, {-25.1, 2.05}, {-20, 2.05}, {-20, 20}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(Tair.port, airload.port) annotation(Line(points = {{24, -13}, {24, -40}, {-6, -40}, {-6, -12}, {1, -12}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(infiltrationRate.port_b, airload.port) annotation(Line(points = {{-50, 48}, {-40, 48}, {-40, -40}, {-6, -40}, {-6, -12}, {1, -12}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(Ceiling.thermStarComb_inside, thermStar_Demux.thermStarComb) annotation(Line(points = {{-30, 58}, {-30, 40}, {-40, 40}, {-40, -40}, {-20.1, -40}, {-20.1, -35.4}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(NaturalVentilation.port_a, thermOutside) annotation(Line(points = {{-68, -40}, {-80, -40}, {-80, 90}, {-90, 90}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(NaturalVentilation.InPort1, AirExchangePort) annotation(Line(points = {{-67, -46.4}, {-80, -46.4}, {-80, 74}, {-20, 74}, {-20, 100}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(NaturalVentilation.port_b, airload.port) annotation(Line(points = {{-48, -40}, {-6, -40}, {-6, -12}, {1, -12}}, color = {191, 0, 0}, smooth = Smooth.None));
  connect(thermInsideWall1b, thermInsideWall1b) annotation(Line(points = {{90, -10}, {85, -10}, {85, -10}, {90, -10}}, color = {191, 0, 0}, smooth = Smooth.None));
  annotation(__Dymola_Images(Parameters(source = "AixLib/Images/House/2OW_2IWl_1IWs_1Gr_Pa.png", Width = 5, Length = 5)), Icon(graphics={  Rectangle(extent=  {{-6, -46}, {6, 46}}, lineColor=  {0, 0, 0}, fillColor=  {215, 215, 215},
            fillPattern=                                                                                                    FillPattern.Solid, origin=  {74, -22}, rotation=  0, radius=  0), Rectangle(extent=  {{-80, 80}, {80, 60}}, lineColor=  {0, 0, 0}, fillColor=  {215, 215, 215},
            fillPattern=                                                                                                    FillPattern.Solid), Rectangle(extent=  {{25, 10}, {-25, -10}}, lineColor=  {0, 0, 0}, fillColor=  {170, 213, 255},
            fillPattern=                                                                                                    FillPattern.Solid, origin=  {-25, 70}, rotation=  180, visible=  withWindow2), Rectangle(extent=  {{6, 18}, {-6, -18}}, lineColor=  {0, 0, 0}, fillColor=  {135, 135, 135},
            fillPattern=                                                                                                    FillPattern.Solid, origin=  {74, 42}, rotation=  0), Rectangle(extent=  {{-80, 60}, {-60, -80}}, lineColor=  {0, 0, 0}, fillColor=  {215, 215, 215},
            fillPattern=                                                                                                    FillPattern.Solid), Rectangle(extent=  {{-60, 60}, {68, -68}}, lineColor=  {0, 0, 0}, fillColor=  {47, 102, 173},
            fillPattern=                                                                                                    FillPattern.Solid), Rectangle(extent=  {{-60, -68}, {80, -80}}, lineColor=  {0, 0, 0}, fillColor=  {215, 215, 215},
            fillPattern=                                                                                                    FillPattern.Solid), Rectangle(extent=  {{-80, 50}, {-60, 0}}, lineColor=  {0, 0, 0}, fillColor=  {170, 213, 255},
            fillPattern=                                                                                                    FillPattern.Solid, visible=  withWindow1), Rectangle(extent=  {{20, 80}, {40, 60}}, lineColor=  {0, 0, 0}, fillColor=  {127, 127, 0},
            fillPattern=                                                                                                    FillPattern.Solid, visible=  withDoor2), Rectangle(extent=  {{-80, -20}, {-60, -40}}, lineColor=  {0, 0, 0}, fillColor=  {127, 127, 0},
            fillPattern=                                                                                                    FillPattern.Solid, visible=  withDoor1), Line(points=  {{-46, -38}, {-46, -68}}, color=  {255, 255, 255}, smooth=  Smooth.None), Line(points=  {{68, 24}, {56, 24}}, color=  {255, 255, 255}, smooth=  Smooth.None), Text(extent=  {{-56, 52}, {64, 40}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, textString=  "width"), Text(extent=  {{-120, 6}, {0, -6}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, origin=  {-46, 56}, rotation=  90, textString=  "length"), Text(extent=  {{57, 6}, {-57, -6}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, origin=  {58, -23}, rotation=  90, textString=  "length_b"), Text(extent=  {{20, 74}, {40, 66}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, textString=  "D2", visible=  withDoor2), Text(extent=  {{-50, 76}, {0, 64}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, textString=  "Win2", visible=  withWindow2), Text(extent=  {{50, -6}, {0, 6}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, textString=  "Win1", origin=  {-70, 0}, rotation=  90, visible=  withWindow1), Text(extent=  {{2.85713, -4}, {-17.1429, 4}}, lineColor=  {255, 255, 255}, fillColor=  {255, 170, 170},
            fillPattern=                                                                                                    FillPattern.Solid, textString=  "D1", origin=  {-70, -22.8571}, rotation=  90, visible=  withDoor1), Line(points=  {{-46, 60}, {-46, 30}}, color=  {255, 255, 255}, smooth=  Smooth.None), Line(points=  {{-60, 46}, {-30, 46}}, color=  {255, 255, 255}, smooth=  Smooth.None), Line(points=  {{38, 46}, {68, 46}}, color=  {255, 255, 255}, smooth=  Smooth.None), Line(points=  {{60, 24}, {60, 16}}, color=  {255, 255, 255}, smooth=  Smooth.None), Line(points=  {{60, -64}, {60, -68}}, color=  {255, 255, 255}, smooth=  Smooth.None)}), Diagram(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics), Documentation(revisions = "<html>
 <ul>
 <li><i>April 18, 2014</i> by Ana Constantin:<br/>Added documentation</li>
 <li><i>July 7, 2011</i> by Ana Constantin:<br/>Implemented</li>
 </ul>
 </html>", info = "<html>
 <h4><span style=\"color:#008000\">Overview</span></h4>
 <p>Model for a room with 2&nbsp;outer&nbsp;walls,&nbsp;2&nbsp;inner&nbsp;walls&nbsp;load towards two different rooms but with the same orientation,&nbsp;1&nbsp;inner&nbsp;wall&nbsp;simple,&nbsp;1&nbsp;floor&nbsp;towards&nbsp;ground,&nbsp;1&nbsp;ceiling&nbsp;towards&nbsp;upper&nbsp;floor.</p>
 <h4><span style=\"color:#008000\">Level of Development</span></h4>
 <p><img src=\"modelica://AixLib/Images/stars3.png\" alt=\"stars: 3 out of 5\"/></p>
 <h4><span style=\"color:#008000\">Concept</span></h4>
 <p>The following figure presents the room&apos;s layout:</p>
 <p><img src=\"modelica://AixLib/Images/House/2OW_2IWl_1IWs_1Gr_Pa.png\"/></p>
 </html>"));
end Ow2IwL2IwS1Gr1Uf1;
