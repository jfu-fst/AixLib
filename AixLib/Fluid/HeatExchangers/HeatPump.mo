within AixLib.Fluid.HeatExchangers;
model HeatPump

  replaceable package Medium =
     Modelica.Media.Water.ConstantPropertyLiquidWater
     constrainedby Modelica.Media.Interfaces.PartialMedium;

  Modelica.Fluid.Interfaces.FluidPort_a
                    port_a_source(redeclare package Medium = Medium)
                                  annotation(Placement(transformation(extent = {{-100, 60}, {-80, 80}})));
  Modelica.Fluid.Interfaces.FluidPort_b
                    port_b_source(redeclare package Medium = Medium)
                                  annotation(Placement(transformation(extent = {{-100, -80}, {-80, -60}})));
  Modelica.Fluid.Interfaces.FluidPort_a
                    port_a_sink(redeclare package Medium = Medium)
                                annotation(Placement(transformation(extent = {{80, -80}, {100, -60}})));
  Modelica.Fluid.Interfaces.FluidPort_b
                    port_b_sink(redeclare package Medium = Medium)
                                annotation(Placement(transformation(extent = {{80, 60}, {100, 80}})));
  Fluid.MixingVolumes.MixingVolume
                volumeEvaporator(V = VolumeEvaporator, nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01)                               annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin={-70,-60})));
  Fluid.MixingVolumes.MixingVolume
                volumeCondenser(V = VolumeCondenser, nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=0.01)                             annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin={70,-30})));
  Fluid.Sensors.TemperatureTwoPort
                            temperatureSinkOut(redeclare package Medium =
        Medium, m_flow_nominal=0.01)           annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 90, origin = {80, 50})));
  Modelica.Blocks.Interfaces.BooleanInput OnOff annotation(Placement(transformation(extent = {{-20, -20}, {20, 20}}, rotation = 270, origin = {0, 80})));
  Fluid.Sensors.TemperatureTwoPort
                            temperatureSourceIn(redeclare package Medium =
        Medium, m_flow_nominal=0.01)            annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {-80, 36})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlowCondenser annotation(Placement(transformation(extent={{-4,-4},
            {4,4}},                                                                                                    rotation = 0, origin={48,-40})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow HeatFlowEvaporator annotation(Placement(transformation(extent={{4,-4},{
            -4,4}},                                                                                                    rotation = 0, origin={-46,-50})));
  Modelica.Blocks.Tables.CombiTable2D PowerTable(table = tablePower) annotation(Placement(transformation(extent = {{-52, 20}, {-32, 40}})));
  Modelica.Blocks.Tables.CombiTable2D HeatFlowCondenserTable(table = tableHeatFlowCondenser) annotation(Placement(transformation(extent = {{-52, -12}, {-32, 8}})));
  Modelica.Blocks.Logical.Switch SwitchHeatFlowCondenser annotation(Placement(transformation(extent = {{14, -20}, {34, 0}})));
  Modelica.Blocks.Sources.Constant constZero2(k = 0) annotation(Placement(transformation(extent = {{-26, -28}, {-6, -8}})));
  Modelica.Blocks.Logical.Switch SwitchPower annotation(Placement(transformation(extent = {{14, 12}, {34, 32}})));
  Modelica.Blocks.Sources.Constant constZero1(k = 0) annotation(Placement(transformation(extent = {{-26, 4}, {-6, 24}})));
  Modelica.Blocks.Math.Feedback feedbackHeatFlowEvaporator annotation(Placement(transformation(extent = {{10, -60}, {-10, -40}})));
  Modelica.Blocks.Interfaces.RealOutput Power "Connector of Real output signal"
                                                                                annotation(Placement(transformation(extent = {{-10, -10}, {10, 10}}, rotation = 270, origin = {0, -90})));
  parameter Modelica.SIunits.Volume VolumeEvaporator = 0.01 "Volume im m3";
  parameter Modelica.SIunits.Volume VolumeCondenser = 0.01 "Volume im m3";
  parameter Real tablePower[:, :] = fill(0.0, 0, 2)
    "table matrix (grid u1 = first column, grid u2 = first row; e.g., table=[0,0;0,1])";
  parameter Real tableHeatFlowCondenser[:, :] = fill(0.0, 0, 2)
    "table matrix (grid u1 = first column, grid u2 = first row; e.g., table=[0,0;0,1])";
  Modelica.Blocks.Math.Gain gain(k = -1) annotation(Placement(transformation(extent = {{-18, -60}, {-38, -40}})));
equation
  connect(temperatureSourceIn.port_a, port_a_source) annotation(Line(points = {{-80, 46}, {-80, 70}, {-90, 70}}, color = {0, 127, 255}, smooth = Smooth.None));
  connect(temperatureSinkOut.port_b, port_b_sink) annotation(Line(points = {{80, 60}, {80, 70}, {90, 70}}, color = {0, 127, 255}, smooth = Smooth.None));
  connect(HeatFlowEvaporator.port, volumeEvaporator.heatPort) annotation(Line(points={{-50,-50},
          {-70,-50}},                                                                                            color = {191, 0, 0}, smooth = Smooth.None));
  connect(HeatFlowCondenser.port, volumeCondenser.heatPort) annotation(Line(points={{52,-40},
          {70,-40}},                                                                                         color = {191, 0, 0}, smooth = Smooth.None));
  connect(OnOff, SwitchHeatFlowCondenser.u2) annotation(Line(points = {{0, 80}, {0, -10}, {12, -10}}, color = {255, 0, 255}, smooth = Smooth.None));
  connect(HeatFlowCondenserTable.y, SwitchHeatFlowCondenser.u1) annotation(Line(points = {{-31, -2}, {12, -2}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(constZero2.y, SwitchHeatFlowCondenser.u3) annotation(Line(points = {{-5, -18}, {12, -18}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(SwitchHeatFlowCondenser.y, HeatFlowCondenser.Q_flow) annotation(Line(points={{35,-10},
          {40,-10},{40,-40},{44,-40}},                                                                                                color = {0, 0, 127}, smooth = Smooth.None));
  connect(constZero1.y, SwitchPower.u3) annotation(Line(points = {{-5, 14}, {12, 14}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(SwitchPower.u2, SwitchHeatFlowCondenser.u2) annotation(Line(points = {{12, 22}, {0, 22}, {0, -10}, {12, -10}}, color = {255, 0, 255}, smooth = Smooth.None));
  connect(PowerTable.y, SwitchPower.u1) annotation(Line(points = {{-31, 30}, {12, 30}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(SwitchPower.y, Power) annotation(Line(points = {{35, 22}, {38, 22}, {38, -70}, {0, -70}, {0, -90}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(SwitchPower.y, feedbackHeatFlowEvaporator.u2) annotation(Line(points = {{35, 22}, {38, 22}, {38, -70}, {0, -70}, {0, -58}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(SwitchHeatFlowCondenser.y, feedbackHeatFlowEvaporator.u1) annotation(Line(points = {{35, -10}, {40, -10}, {40, -50}, {8, -50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.y, HeatFlowEvaporator.Q_flow) annotation(Line(points={{-39,-50},{
          -42,-50}},                                                                            color = {0, 0, 127}, smooth = Smooth.None));
  connect(gain.u, feedbackHeatFlowEvaporator.y) annotation(Line(points = {{-16, -50}, {-9, -50}}, color = {0, 0, 127}, smooth = Smooth.None));
  connect(temperatureSourceIn.port_b, volumeEvaporator.ports[1]) annotation (
      Line(
      points={{-80,26},{-80,-58}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_a_sink, volumeCondenser.ports[1]) annotation (Line(
      points={{90,-70},{80,-68},{80,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(volumeCondenser.ports[2], temperatureSinkOut.port_a) annotation (Line(
      points={{80,-28},{80,40}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(temperatureSourceIn.T, PowerTable.u2) annotation (Line(
      points={{-69,36},{-66,36},{-66,24},{-54,24}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSourceIn.T, HeatFlowCondenserTable.u2) annotation (Line(
      points={{-69,36},{-66,36},{-66,-8},{-54,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSinkOut.T, PowerTable.u1) annotation (Line(
      points={{69,50},{-62,50},{-62,36},{-54,36}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temperatureSinkOut.T, HeatFlowCondenserTable.u1) annotation (Line(
      points={{69,50},{-62,50},{-62,4},{-54,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volumeEvaporator.ports[2], port_b_source) annotation (Line(
      points={{-80,-62},{-80,-70},{-90,-70}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false,   extent={{-100,
            -100},{100,100}}),                                                                           graphics), Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics={  Rectangle(extent = {{-80, 80}, {80, -80}}, lineColor = {0, 0, 255}, fillColor = {249, 249, 249},
            fillPattern =                                                                                                    FillPattern.Solid), Rectangle(extent = {{-80, 80}, {-60, -80}}, lineColor = {0, 0, 255}, fillColor = {170, 213, 255},
            fillPattern =                                                                                                    FillPattern.Solid), Rectangle(extent = {{60, 80}, {80, -80}}, lineColor = {0, 0, 255}, fillColor = {255, 170, 213},
            fillPattern =                                                                                                    FillPattern.Solid), Text(extent = {{-100, 20}, {100, -20}}, lineColor = {0, 0, 255}, textString = "%name")}), Documentation(info = "<html>
 <h4><span style=\"color:#008000\">Overview</span></h4>
 <p>Simple model of an on/off-controlled heat pump. The refrigerant circuit is a black-box model represented by tables which calculate the electric power and heat flows of the condenser depending on the source and sink temperature. </p>
 <h4><span style=\"color:#008000\">Level of Development</span></h4>
 <p><img src=\"modelica://AixLib/Images/stars3.png\"/></p>
 <h4><span style=\"color:#008000\">Example Results</span></h4>
 <p><a href=\"AixLib.HVAC.HeatGeneration.Examples.HeatPumpSystem\">AixLib.HVAC.HeatGeneration.Examples.HeatPumpSystem</a></p>
 <p><a href=\"AixLib.HVAC.HeatGeneration.Examples.HeatPumpSystem2\">AixLib.HVAC.HeatGeneration.Examples.HeatPumpSystem2</a></p>
 </html>", revisions="<html>
 <p>November 2014, Marcus Fuchs</p>
 <p><ul>
 <li>Changed model to use Annex 60 base class</li>
 </ul></p>
 <p>25.11.2013, Kristian Huchtemann</p>
 <p><ul>
 <li>implemented</li>
 </ul></p>
 </html>"));
end HeatPump;
