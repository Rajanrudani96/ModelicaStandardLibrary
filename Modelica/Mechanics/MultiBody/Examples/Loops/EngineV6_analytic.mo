within Modelica.Mechanics.MultiBody.Examples.Loops;
model EngineV6_analytic
  "V6 engine with 6 cylinders, 6 planar loops, 1 degree-of-freedom and analytic handling of kinematic loops"

  extends Modelica.Icons.Example;
  parameter Boolean animation=true "= true, if animation shall be enabled";
  output Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    engineSpeed_rpm=
         Modelica.SIunits.Conversions.to_rpm(load.w) "Engine speed";
  output Modelica.SIunits.Torque engineTorque = filter.u
    "Torque generated by engine";
  output Modelica.SIunits.Torque filteredEngineTorque = filter.y
    "Filtered torque generated by engine";

  inner Modelica.Mechanics.MultiBody.World world(animateWorld=false,
      animateGravity =                                                              false)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Utilities.EngineV6_analytic engine(redeclare model Cylinder =
        Modelica.Mechanics.MultiBody.Examples.Loops.Utilities.Cylinder_analytic_CAD)
    annotation (Placement(transformation(extent={{-40,0},{0,40}})));
  Modelica.Mechanics.Rotational.Components.Inertia load(
                                             phi(
      start=0,
      fixed=true), w(
      start=10,
      fixed=true),
    stateSelect=StateSelect.always,
    J=1) annotation (Placement(transformation(
          extent={{40,10},{60,30}})));
  Modelica.Mechanics.Rotational.Sources.QuadraticSpeedDependentTorque load2(
                                                 tau_nominal=-100, w_nominal=
        200,
    useSupport=false)
             annotation (Placement(transformation(extent={{90,10},{70,30}})));
  Rotational.Sensors.TorqueSensor torqueSensor
    annotation (Placement(transformation(extent={{12,10},{32,30}})));
  Blocks.Continuous.CriticalDamping filter(
    n=2,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    f=5) annotation (Placement(transformation(extent={{30,-20},{50,0}})));
equation

  connect(world.frame_b, engine.frame_a)
    annotation (Line(
      points={{-60,-10},{-20,-10},{-20,-0.2}},
      color={95,95,95},
      thickness=0.5));
  connect(load2.flange, load.flange_b)
    annotation (Line(points={{70,20},{60,20}}));
  connect(torqueSensor.flange_a, engine.flange_b)
    annotation (Line(points={{12,20},{2,20}}));
  connect(torqueSensor.flange_b, load.flange_a)
    annotation (Line(points={{32,20},{40,20}}));
  connect(torqueSensor.tau, filter.u) annotation (Line(points={{14,9},{14,-10},
          {28,-10}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This is a similar model as the example \"EngineV6\". However, the cylinders
have been built up with component Modelica.Mechanics.MultiBody.Joints.Assemblies.JointRRR that
solves the non-linear system of equations in an aggregation of 3 revolution
joints <strong>analytically</strong> and only one body is used that holds the total
mass of the crank shaft:
</p>

<p>
<IMG src=\"modelica://Modelica/Resources/Images/Mechanics/MultiBody/Examples/Loops/EngineV6_CAD_small.png\">
</p>

<p>
This model is about 20 times faster as the EngineV6 example and <strong>no</strong> linear or
non-linear system of equations occur. In contrast, the \"EngineV6\" example
leads to 6 systems of nonlinear equations (every system has dimension = 5, with
Evaluate=false and dimension=1 with Evaluate=true) and a linear system of equations
of about 40. This shows the power of the analytic loop handling.
</p>


<p>
Simulate for 3 s with about 50000 output intervals, and plot the variables <strong>engineSpeed_rpm</strong>,
<strong>engineTorque</strong>, and <strong>filteredEngineTorque</strong>. Note, the result file has
a size of about 240 Mbyte in this case. The default setting of StopTime = 1.01 s (with the default setting of the tool for the number of output points), in order that (automatic) regression testing does not have to cope with a large result file.
</p>

</html>"), experiment(StopTime=1.01));
end EngineV6_analytic;
