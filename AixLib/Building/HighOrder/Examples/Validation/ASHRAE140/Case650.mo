within AixLib.Building.HighOrder.Examples.Validation.ASHRAE140;
model Case650
  extends Modelica.Icons.Example;

  parameter AixLib.DataBase.Profiles.Profile_BaseDataDefinition SetTempProfile = AixLib.DataBase.Profiles.ASHRAE140.SetTemp_caseX50();
  parameter AixLib.DataBase.Profiles.Profile_BaseDataDefinition AERProfile = AixLib.DataBase.Profiles.ASHRAE140.Ventilation_caseX50();
  Components.Weather.BaseClasses.Sun_new sun(
    TimeCorrection=0,
    Latitude=39.76,
    Longitude=-104.9,
    DiffWeatherDataTime=-7,
    Diff_localStandardTime_WeatherDataTime=0.5)
    annotation (Placement(transformation(extent={{-142,61},{-118,85}})));
  Components.Weather.BaseClasses.RadOnTiltedSurf_Perez radOnTiltedSurf_Perez[5](
    WeatherFormat=2,
    Latitude=fill(39.76, 5),
    Azimut={180,-90,0,90,0},
    Tilt={90,90,90,90,0},
    GroundReflection=fill(0.2, 5)) "N,E,S,W, Horz"
    annotation (Placement(transformation(extent={{-102,56},{-74,84}})));

  Modelica.Blocks.Sources.CombiTimeTable Solar_Radiation(
    tableOnFile=true,
    tableName="Table",
    columns={2,3},
    fileName=
        "D:/Git/AixLib/AixLib/Resources/WeatherData/Weatherdata_ASHARE140.mat")
    annotation (Placement(transformation(extent={{-114,0},{-94,20}})));
  Modelica.Blocks.Sources.CombiTimeTable Source_Weather(
    tableOnFile=true,
    tableName="Table",
    columns={4,5,6,7},
    fileName=
        "D:/Git/AixLib/AixLib/Resources/WeatherData/Weatherdata_ASHARE140.mat")
    annotation (Placement(transformation(extent={{-114,30},{-94,50}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature outsideTemp
    "ambient temperature"
    annotation (Placement(transformation(extent={{-70,41},{-59,52}})));
  Rooms.ASHRAE140.SouthFacingWindows Room
    annotation (Placement(transformation(extent={{-9,17},{33,58}})));
  Utilities.Sources.HourOfDay hourOfDay
    annotation (Placement(transformation(extent={{80,69},{100,89}})));
  Modelica.Blocks.Interfaces.RealOutput AnnualCoolingLoad "in MWh"
    annotation (Placement(transformation(extent={{90,22},{110,42}})));
  Modelica.Blocks.Interfaces.RealOutput PowerLoad "in kW"
    annotation (Placement(transformation(extent={{90,6},{110,26}})));
  Modelica.Blocks.Sources.Constant Source_InternalGains_convective(k=0.4*200)
    annotation (Placement(transformation(extent={{-112,-31},{-99,-18}})));
  Modelica.Blocks.Sources.Constant Source_InternalGains_radiative(k=0.6*200)
    annotation (Placement(transformation(extent={{-112,-58},{-100,-46}})));
  HVAC.HeatGeneration.IdealHeaterCooler                   idealHeaterCooler(
    TN_heater=1,
    TN_cooler=1,
    h_heater=1e6,
    KR_heater=1000,
    l_cooler=-1e6,
    KR_cooler=1000,
    Heater_on=false)
    annotation (Placement(transformation(extent={{6,-34},{26,-14}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow Ground(Q_flow=0)
    "adiabatic boundary"
    annotation (Placement(transformation(extent={{-75,0},{-55,20}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    InternalGains_convective
    annotation (Placement(transformation(extent={{-91,-34},{-71,-14}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow
    InternalGains_radiative
    annotation (Placement(transformation(extent={{-92,-62},{-72,-42}})));
  Modelica.Blocks.Sources.CombiTimeTable Source_TsetCool(
    columns={2},
    tableOnFile=false,
    table=SetTempProfile.Profile,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-8,-49},{5,-36}})));
  Modelica.Blocks.Sources.CombiTimeTable AirExchangeRate(
    columns={2},
    tableOnFile=false,
    table=AERProfile.Profile,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    annotation (Placement(transformation(extent={{-39,-48},{-26,-35}})));
equation
    //Connections for input solar model
  for i in 1:5 loop
    connect(sun.OutDayAngleSun, radOnTiltedSurf_Perez[i].InDayAngleSun);
    connect(sun.OutHourAngleSun, radOnTiltedSurf_Perez[i].InHourAngleSun);
    connect(sun.OutDeclinationSun, radOnTiltedSurf_Perez[i].InDeclinationSun);
    connect(Solar_Radiation.y[1], radOnTiltedSurf_Perez[i].solarInput1);
    connect(Solar_Radiation.y[2], radOnTiltedSurf_Perez[i].solarInput2);
  end for;

  // Set outputs
  AnnualCoolingLoad = idealHeaterCooler.coolMeter.q_kwh/1000;  // in MWh

  PowerLoad = idealHeaterCooler.coolMeter.p;

  connect(Source_Weather.y[1], outsideTemp.T) annotation (Line(
      points={{-93,40},{-80,40},{-80,46.5},{-71.1,46.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(radOnTiltedSurf_Perez.OutTotalRadTilted, Room.SolarRadiationPort)
    annotation (Line(
      points={{-76.8,77},{-50,77},{-50,49.8},{-11.1,49.8}},
      color={255,128,0},
      smooth=Smooth.None));
  connect(outsideTemp.port, Room.Therm_outside) annotation (Line(
      points={{-59,46.5},{-55,46.5},{-55,47},{-50,47},{-50,57.385},{-10.05,
          57.385}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(Source_Weather.y[2], Room.WindSpeedPort) annotation (Line(
      points={{-93,40},{-11.1,40},{-11.1,43.65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(Room.thermRoom, idealHeaterCooler.HeatCoolRoom) annotation (Line(
      points={{5.91,42.215},{5.91,19},{30,19},{30,-22.8},{25.4,-22.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Ground.port, Room.Therm_ground) annotation (Line(
      points={{-55,10},{5.28,10},{5.28,17.82}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Source_InternalGains_convective.y, InternalGains_convective.Q_flow)
    annotation (Line(
      points={{-98.35,-24.5},{-93,-24.5},{-93,-23},{-92,-23},{-92,-24},{-91,-24}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(Source_InternalGains_radiative.y, InternalGains_radiative.Q_flow)
    annotation (Line(
      points={{-99.4,-52},{-92,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(InternalGains_convective.port, Room.thermRoom) annotation (Line(
      points={{-71,-24},{-50,-24},{-50,-14},{6,-14},{6,42.215},{5.91,42.215}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(InternalGains_radiative.port, Room.starRoom) annotation (Line(
      points={{-72,-52},{-60,-52},{-60,-24},{-50,-24},{-50,-14},{13.89,-14},{
          13.89,42.83}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(Source_TsetCool.y[1], idealHeaterCooler.soll_cool) annotation (Line(
      points={{5.65,-42.5},{11.2,-42.5},{11.2,-28.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(AirExchangeRate.y[1], Room.AER) annotation (Line(
      points={{-25.35,-41.5},{-21,-41.5},{-21,27.25},{-11.1,27.25}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(
        extent={{-150,-100},{120,90}},
        preserveAspectRatio=false,
        grid={1,1}), graphics={
        Rectangle(
          extent={{-48,90},{48,-10}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-116,-13},{-60,-70}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{50,90},{120,-100}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-150,90},{-50,-10}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),Text(
          extent={{-150,20},{-122,4}},
          lineColor={0,0,255},
          textString="1 - Direct normal irradiance in W/m2
2 - global horizontal 
     radiance in W/m2
"),     Text(
          extent={{-147,-2},{-79,-10}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Weather boundary conditions"),
                                         Text(
          extent={{-148,48},{-116,30}},
          lineColor={0,0,255},
          textString="1 - Air Temperature in K
2 - Wind Speed m/s
3- Dew Point Temperature in K
4- Cloud Cover"),
        Text(
          extent={{35,-91},{96,-99}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Outputs"),
        Rectangle(
          extent={{-50,-14},{47,-64}},
          lineColor={0,0,127},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,-55},{7,-63}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="HVAC system"),
        Text(
          extent={{-125,-61},{-68,-68}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Internal gains"),
        Text(
          extent={{-56,-1},{12,-9}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Building physics")}),
                  Icon(coordinateSystem(
        extent={{-150,-100},{120,90}},
        preserveAspectRatio=false,
        grid={1,1})),
    experiment(StopTime=3.1536e+007, Interval=3600),
    __Dymola_experimentSetupOutput(events=false),
    Documentation(revisions="<html>
 <p><ul>
 <li><i>March 9, 2015</i> by Ana Constantin:<br/>Implemented</li>
 </ul></p>
 </html>",
         info="<html>
<p>As described in ASHRAE Standard 140.</p>
<p>Difference to case 600:</p>
<ul>
<li>From 1800 hours to 0700 hours, vent fan = ON</li>
<li>From 0700 hours to 1800 hours, vent fan = OFF</li>
<li>Heating = always OFF</li>
<li>From 1800 hours to 0700 hours, cool = OFF</li>
<li>From 0700 hours to 1800 hours, cool = ON if temperature &GT; 27 degC; otherwise, cool = OFF</li>
</ul>
</html>"));
end Case650;
