within AixLib.DataBase.Profiles.ASHRAE140;
record SetTemp_caseX40 "Max. and Min. set room temperatures for heating"
    extends AixLib.DataBase.Profiles.Profile_BaseDataDefinition(Profile=[
      0,    273.15+ 10;
     25200, 273.15+ 10;
     25200,273.15+ 20;
     82800,273.15+ 20;
     82800, 273.15+10;
     86400, 273.15+10]);
    annotation (Documentation(info="<html>
<p>Heating load for Test Case 640</p>
<p><h4>Table for Natural Ventilation:</h4></p>
<p>Column 1: Time</p>
<p>Column 2: Set temperature for Heater</p>
</html>"));
end SetTemp_caseX40;
