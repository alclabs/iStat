package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.access.*;
import com.controlj.green.addonsupport.access.aspect.SetPoint;
import com.controlj.green.addonsupport.access.util.Acceptors;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

//todo - is this used?
public class AreaServlet extends HttpServlet {
    public AreaServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
        resp.setHeader("Cache-Control", "no-cache");
        ServletOutputStream out = resp.getOutputStream();
        try {
            writeLocations(out, getLocations());
        } catch (Exception e) {
            throw new ServletException(e);
        }
        /*
        out.println("[");
        out.println("{ display:'Main Conf Room', id:'mainconf'},");
        out.println("{ display:'Board Room', id:'boardroom'},");
        out.println("{ display:'Room 235', id:'room235'}");
        out.println("]");
        */
    }

    public void writeLocations(final ServletOutputStream out, final ArrayList<String> locations) throws IOException, SystemException, ActionExecutionException {
        out.println("[");

        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        connection.runReadAction(new ReadAction(){
            public void execute(@NotNull SystemAccess access) throws Exception {
                for (String location : locations) {
                    out.print("{");
                    Location loc = access.getGeoRoot().getTree().resolve(location);
                    out.print("display:'"+loc.getDisplayName()+"', ");
                    out.print("id:'"+location+"'");
                    out.println("},");
                }

            }
        });



        out.println("]");
    }

    public ArrayList<String> getLocations() throws Exception
    {
        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        return connection.runReadAction(new ReadActionResult<ArrayList<String>>() {
            public ArrayList<String> execute(@NotNull SystemAccess access) throws Exception {
                ArrayList<String> result = new ArrayList<String>();
                Collection<SetPoint> sps = access.find(access.getGeoRoot(), SetPoint.class, Acceptors.acceptAll());
                for (SetPoint sp : sps) {
                    result.add(sp.getLocation().getParent().getPersistentLookupString(false));
                }
                return result;
            }
        });
    }

    public ArrayList<String> getLocationsFromDataStore() throws Exception
    {
        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        return connection.runReadAction(new ReadActionResult<ArrayList<String>>() {
            public ArrayList<String> execute(@NotNull SystemAccess access) throws Exception {
                DataStore ds = access.getSystemDataStore("locations");
                BufferedReader reader = ds.getReader();
                ArrayList<String> result = new ArrayList<String>();
                String line =null;
                do {
                    line = reader.readLine();
                    if (line != null) {
                        result.add(line);
                    }
                } while (line != null);

                reader.close();
                return result;
            }
        });
    }

}
