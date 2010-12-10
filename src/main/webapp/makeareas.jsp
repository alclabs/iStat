<%@ page import="com.controlj.green.addonsupport.AddOnInfo" %>
<%@ page import="com.controlj.green.addonsupport.access.DataStore" %>
<%@ page import="com.controlj.green.addonsupport.access.SystemConnection" %>
<%@ page import="com.controlj.green.addonsupport.access.WritableSystemAccess" %>
<%@ page import="com.controlj.green.addonsupport.access.WriteAction" %>
<%@ page import="org.jetbrains.annotations.NotNull" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="com.controlj.green.addonsupport.access.aspect.SetPoint" %>
<%@ page import="java.util.Collection" %>
<%@ page import="com.controlj.green.addonsupport.access.util.Acceptors" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head><title>Make some areas</title></head>
<%!
    public void storeLocations() throws Exception
    {
        AddOnInfo aoi = AddOnInfo.getAddOnInfo();
        SystemConnection connection = aoi.getRootSystemConnection();
        connection.runWriteAction("Writing sample", new WriteAction() {
            public void execute(@NotNull WritableSystemAccess access) throws Exception {
                DataStore ds = access.getSystemDataStore("locations");
                PrintWriter writer = ds.getWriter();
                System.out.println("It ran");
                Collection<SetPoint> sps = access.find(access.getGeoRoot(), SetPoint.class, Acceptors.acceptAll());
                System.out.println("Creating areas- found "+new ArrayList<SetPoint>(sps).size());
                for (SetPoint sp : sps) {
                    writer.println(sp.getLocation().getPersistentLookupString(false));
                }
                writer.close();
            }
        });
    }

%>
  <body>
<div>Running it</div>
  <%
      storeLocations();
  %>
  </body>
</html>