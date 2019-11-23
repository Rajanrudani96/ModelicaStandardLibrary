within Modelica.Electrical.Polyphase.Examples;
model PolyPhaseRectifier "Demonstrate a polyphase diode rectifier"
  extends Icons.Example;
  import Modelica.Electrical.Polyphase.Functions.numberOfSymmetricBaseSystems;
  parameter Integer m(final min=2)=6 "Number of phases";
  parameter Modelica.SIunits.Voltage VrmsY=100 "RMS voltage line to starpoint";
  parameter Modelica.SIunits.Frequency f=50 "Source frequency";
  parameter Modelica.SIunits.Resistance RLoad=2 "Load resistance";
  parameter Modelica.SIunits.Resistance RLine=1e-3 "Line resistance";
  parameter Modelica.SIunits.Inductance LLine=1e-5 "Line inductance";
  parameter Modelica.SIunits.Resistance RGnd=1e6 "Resistance to ground";
  final parameter Integer mSystems=numberOfSymmetricBaseSystems(m)
    "Number of base systems";
  final parameter Integer mBasic=integer(m/mSystems)
    "Phase number of base systems";
  final parameter Integer kPolygon=if m==2 then 1 else integer((mBasic - 1)/2)
    "Alternative of largest polygon voltage";
  Sources.SineVoltage sineVoltage(
    m=m,
    V=sqrt(2)*fill(VrmsY, m),
    f=fill(f, m))         annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-60})));
  Basic.MultiStarResistance multiStar(m=m, R=RGnd)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,-60})));
  Analog.Basic.Resistor resistor2ground(R=RGnd)
                                               annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-60})));
  Analog.Basic.Ground groundAC
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-60})));
  Sensors.MultiSensor multiSensorAC(m=m)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-20})));
  Modelica.Blocks.Math.Mean pAC(f=f) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Blocks.Math.Harmonic iH1(f=f, k=1) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-40})));
  Modelica.Blocks.Math.Harmonic vH1(f=f, k=1) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,-20})));
  Basic.MultiDelta multiDelta(m=m, kPolygon=kPolygon)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,50})));
  Sensors.VoltageSensor voltageSensor(m=m)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,50})));
  Modelica.Blocks.Math.Harmonic vLL(f=f, k=1) "Line-to-line voltage"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,50})));
  Basic.Resistor lineResistor(m=m, R=fill(RLine, m))
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Basic.Inductor lineInductor(m=m,
    L=fill(LLine, m),
    i(start=zeros(m), fixed=true))
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Ideal.IdealDiode diode1(
    m=m,
    Ron=fill(1e-6, m),
    Goff=fill(1e-6, m),
    Vknee=fill(0, m)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,40})));
  Ideal.IdealDiode diode2(
    m=m,
    Ron=fill(1e-6, m),
    Goff=fill(1e-6, m),
    Vknee=fill(0, m)) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,0})));
  Basic.Star star1(m=m) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,60})));
  Basic.Star star2(m=m) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={10,-20})));
  Analog.Sensors.MultiSensor multiSensorDC
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Modelica.Blocks.Math.Mean pDC(f=f) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={20,20})));
  Modelica.Blocks.Math.Mean iDC(f=f) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,20})));
  Modelica.Blocks.Math.Mean vDC(f=f) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={60,20})));
  Analog.Basic.Resistor resistor1(R=RLoad/2)
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,40})));
  Analog.Basic.Resistor resistor2(R=RLoad/2)
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={80,0})));
  Analog.Basic.Ground groundDC annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={90,20})));
equation
  connect(sineVoltage.plug_n, multiStar.plug)
    annotation (Line(points={{-60,-60},{-50,-60}}, color={0,0,255}));
  connect(star1.plug_p, diode1.plug_n)
    annotation (Line(points={{0,60},{0,50}},              color={0,0,255}));
  connect(diode2.plug_p, star2.plug_p)
    annotation (Line(points={{0,-10},{0,-20}},               color={0,0,255}));
  connect(star2.pin_n, resistor2.n)
    annotation (Line(points={{20,-20},{80,-20},{80,-10}},color={0,0,255}));
  connect(resistor1.n, groundDC.p)
    annotation (Line(points={{80,30},{80,20}},color={0,0,255}));
  connect(groundDC.p, resistor2.p)
    annotation (Line(points={{80,20},{80,10}}, color={0,0,255}));
  connect(multiDelta.plug_p, voltageSensor.plug_p)
    annotation (Line(points={{-90,40},{-70,40}}, color={0,0,255}));
  connect(multiDelta.plug_n, voltageSensor.plug_n)
    annotation (Line(points={{-90,60},{-70,60}}, color={0,0,255}));
  connect(voltageSensor.v[1], vLL.u)
    annotation (Line(points={{-59,50},{-42,50}}, color={0,0,127}));
  connect(multiStar.pin, resistor2ground.p)
    annotation (Line(points={{-30,-60},{-20,-60}}, color={0,0,255}));
  connect(resistor2ground.n, groundAC.p)
    annotation (Line(points={{0,-60},{10,-60}},    color={0,0,255}));
  connect(star1.pin_n, multiSensorDC.pc)
    annotation (Line(points={{20,60},{40,60}}, color={0,0,255}));
  connect(multiSensorDC.pc, multiSensorDC.pv)
    annotation (Line(points={{40,60},{40,70},{50,70}}, color={0,0,255}));
  connect(multiSensorDC.nc, resistor1.p)
    annotation (Line(points={{60,60},{80,60},{80,50}}, color={0,0,255}));
  connect(star2.pin_n, multiSensorDC.nv)
    annotation (Line(points={{20,-20},{50,-20},{50,50}}, color={0,0,255}));
  connect(multiSensorDC.v, vDC.u) annotation (Line(points={{56,49},{56,40},{60,40},
          {60,32}}, color={0,0,127}));
  connect(multiSensorDC.i, iDC.u) annotation (Line(points={{44,49},{44,40},{40,40},
          {40,32}}, color={0,0,127}));
  connect(multiSensorDC.power, pDC.u)
    annotation (Line(points={{39,54},{20,54},{20,32}}, color={0,0,127}));
  connect(diode1.plug_p, diode2.plug_n)
    annotation (Line(points={{0,30},{0,10}}, color={0,0,255}));
  connect(multiSensorAC.pc, sineVoltage.plug_p)
    annotation (Line(points={{-80,-30},{-80,-60}}, color={0,0,255}));
  connect(multiSensorAC.pc, multiSensorAC.pv)
    annotation (Line(points={{-80,-30},{-90,-30},{-90,-20}}, color={0,0,255}));
  connect(multiSensorAC.nc, lineResistor.plug_p)
    annotation (Line(points={{-80,-10},{-80,20},{-70,20}}, color={0,0,255}));
  connect(voltageSensor.plug_p, multiSensorAC.nc)
    annotation (Line(points={{-70,40},{-80,40},{-80,-10}}, color={0,0,255}));
  connect(lineResistor.plug_n, lineInductor.plug_p)
    annotation (Line(points={{-50,20},{-40,20}}, color={0,0,255}));
  connect(diode1.plug_p, lineInductor.plug_n) annotation (Line(points={{-6.66134e-16,
          30},{-6.66134e-16,20},{-20,20}}, color={0,0,255}));
  connect(multiSensorAC.nv, sineVoltage.plug_n)
    annotation (Line(points={{-70,-20},{-60,-20},{-60,-60}}, color={0,0,255}));
  connect(multiSensorAC.powerTotal, pAC.u)
    annotation (Line(points={{-74,-9},{-74,0},{-42,0}}, color={0,0,127}));
  connect(multiSensorAC.v[1], vH1.u) annotation (Line(points={{-69,-14},{-50,-14},
          {-50,-20},{-42,-20}}, color={0,0,127}));
  connect(multiSensorAC.i[1], iH1.u) annotation (Line(points={{-69,-26},{-50,-26},
          {-50,-40},{-42,-40}}, color={0,0,127}));
  annotation (experiment(StopTime=0.2, Interval=5e-05),  Documentation(info="<html>
<p>
This example demonstrates a polyphase rectifier, as well as proper usage of ground.
</p>
<p>
You may try different number of phases 2&le;m, and investigate:
</p>
<ul>
<li>AC power   pAC.y (sum of all phases)</li>
<li>AC current iH1.y_rms (1st harmonice rms)</li>
<li>AC voltage vH1.y_rms (1st harmonice rms, line to neutral)</li>
<li>AC voltage vLL.y_rms (1st harmonice rms, line to line)</li>
<li>DC power   pDC.y (mean)<li>
<li>DC current iDC.y (mean)<li>
<li>DC voltage vDC.y (mean)<li>
</ul>
<p>
Note that kPolygon=(mBasic - 1)/2 is set to achieve the highest possible line-to-line voltage.
</p>
<p>
AC rms voltage line-to-neutral is set by parameter VrmsY.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end PolyPhaseRectifier;
