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
import java.io.IOException;
import java.util.Collection;

public class StatServlet extends HttpServlet {
    public StatServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        resp.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
        resp.setHeader("Cache-Control", "no-cache");
        ServletOutputStream out = resp.getOutputStream();

        try {
            writeStats(out, req.getParameter("loc"));
        } catch (Exception e) {
            resp.sendError(500, e.getMessage());
            //throw new ServletException(e);
        }

        /*
        out.println("[{ hsp:67,");
        out.println("csp: 74,");
        out.println("off: 1.5,");
        out.println("lim: 3.0,");
        out.println("current:71,");
        out.println("loc:'"+req.getParameter("loc")+"',");
        out.println("time:'"+new Date().getSeconds()+"'");
        out.println("}]");
        */
    }

    public void writeStats(final ServletOutputStream out, final String location) throws IOException, SystemException, ActionExecutionException {
        out.println("[{");

        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        connection.runReadAction(FieldAccessFactory.newFieldAccess(), new ReadAction(){
            public void execute(@NotNull SystemAccess access) throws Exception {
                Location eqLoc = access.getGeoRoot().getTree().resolve(location);
                Collection<SetPoint> setPoints = eqLoc.find(SetPoint.class, Acceptors.acceptAll());
                if (setPoints.isEmpty()) {
                    throw new Exception("Invalid location, no SetPoints here: "+location);
                }
                Collection<SetPointAdjust> setPointAdjusts = eqLoc.find(SetPointAdjust.class, Acceptors.acceptAll());
                if (setPointAdjusts.isEmpty()) {
                    throw new Exception("Invalid location, no SetPointAdjusts here: "+location);
                }


                SetPoint setPoint = setPoints.iterator().next();
                SetPointAdjust setPointAdjust = setPointAdjusts.iterator().next();

                out.println("hsp:" +    setPoint.getEffectiveHeating() + ", ");
                out.println("csp:" +    setPoint.getEffectiveCooling() + ", ");
                out.println("current:"+ setPoint.getZoneTemp()+",");
                out.println("off:" +    setPointAdjust.getCoolingSetpointAdjust().getValueAsString() + ",");
                out.println("lim:" +    setPointAdjust.getCoolingSetpointAdjust().getMaximum() + ",");
                out.println("loc:'" +   location+"',");
            }
        });

        out.println("}]");
    }



    
}