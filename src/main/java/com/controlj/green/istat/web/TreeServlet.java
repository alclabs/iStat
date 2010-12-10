package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.access.*;
import com.controlj.green.addonsupport.access.aspect.SetPoint;
import com.controlj.green.addonsupport.access.aspect.SetPointAdjust;
import com.controlj.green.addonsupport.access.util.Acceptors;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;

public class TreeServlet extends HttpServlet {
    private static final String LOCATION_PARAM = "LOC";

    public TreeServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
        resp.setHeader("Cache-Control", "no-cache");
        ServletOutputStream out = resp.getOutputStream();
        try {
            writeLevel(out, req.getParameter(LOCATION_PARAM));
        } catch (Exception e) {
            throw new ServletException(e);
        }
        out.flush();
        /*
        out.println("[");
        out.println("{ display:'Main Conf Room', id:'mainconf'},");
        out.println("{ display:'Board Room', id:'boardroom'},");
        out.println("{ display:'Room 235', id:'room235'}");
        out.println("]");
        */
    }

    public void writeLevel(final ServletOutputStream out, final String location) throws IOException, SystemException, ActionExecutionException {
        out.println("[");

        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        connection.runReadAction(new ReadAction(){
            public void execute(@NotNull SystemAccess access) throws Exception {
                Location parent;
                if (location == null || location.length()==0) {
                    parent = access.getGeoRoot();
                } else
                {
                    parent = access.getGeoRoot().getTree().resolve(location);
                }
                Collection<Location> childrenLocs = parent.getChildren();

                for (Location nextLoc : childrenLocs)
                {
                    if (nextLoc.getType() == LocationType.Equipment)
                    {
                        if (nextLoc.find(SetPoint.class, Acceptors.acceptAll()).isEmpty() ||
                            nextLoc.find(SetPointAdjust.class, Acceptors.acceptAll()).isEmpty() )
                        {
                            continue;
                        }
                    }
                    out.print("{");
                    out.print("display:'"+nextLoc.getDisplayName()+"', ");
                    out.print("id:'"+nextLoc.getPersistentLookupString(false)+"', ");
                    out.print("area: "+ (nextLoc.getType() == LocationType.Area));
                    out.println("},");
                }

            }
        });

        out.println("]");        
    }


}