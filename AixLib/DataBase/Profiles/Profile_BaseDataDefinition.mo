within AixLib.DataBase.Profiles;


record Profile_BaseDataDefinition "Ventilation profiles"
  extends Modelica.Icons.Record;
  parameter Real[:, :] Profile "First column time";
  annotation(Documentation(info = "<html>
 <h4><span style=\"color:#008000\">Overview</span></h4>
 <p>Profiles are to be understood as useage profiles. </p>
 <h4><span style=\"color:#008000\">Concept</span></h4>
 <p>For example:</p>
 <ul>
 <li>Ventilation schedules</li>
 <li>Schedules for set room temperature</li>
 </ul>
 <h4><span style=\"color:#008000\">References</span></h4>
 <p>Base data definition for record to be used in model <a href=\"Modelica.Blocks.Sources.CombiTimeTable\">Modelica.Blocks.Sources.CombiTimeTable</a></p>
 </html>", revisions = "<html>
 <ul>
 <li><i>August 30, 2013&nbsp;</i> by Ole Odendahl:<br/>Formatted documentation appropriately</li>
 <li><i>July 3, 2012&nbsp;</i> by Ana Constantin:<br/>Implemented.</li>
 </ul>
 </html>"));
end Profile_BaseDataDefinition;
