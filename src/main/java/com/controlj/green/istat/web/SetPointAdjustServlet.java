package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.access.*;
import com.controlj.green.addonsupport.access.aspect.SetPointAdjust;
import com.controlj.green.addonsupport.access.util.Acceptors;
import com.controlj.green.addonsupport.access.value.FloatValue;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Collection;

public class SetPointAdjustServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
        resp.setHeader("Cache-Control", "no-cache");
        ServletOutputStream out = resp.getOutputStream();

        String location = req.getParameter("loc");
        String newValue = req.getParameter("value");

        if (location == null || newValue == null)
        {
            throw new ServletException("Error adjusting setpoint, location or value not set");
        }

        writeAdjustment(location, newValue);
    }

    private void writeAdjustment(final String locationString, final String newValue) throws ServletException {
        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();

        try {
            connection.runWriteAction(FieldAccessFactory.newFieldAccess(), "Setpoint adjusted from iStat", new WriteAction() {

                public void execute(@NotNull WritableSystemAccess access) throws Exception {
                    Location location = access.getGeoRoot().getTree().resolve(locationString);
                    Collection<SetPointAdjust> adjusts = location.find(SetPointAdjust.class, Acceptors.acceptAll());
                    if (adjusts.isEmpty()) {
                        throw new Exception("Invalid location, no SetPointAdjusts here: "+location);
                    }

                    SetPointAdjust adjust = adjusts.iterator().next();
                    FloatValue hsp = adjust.getHeatingSetpointAdjust();
                    FloatValue csp = adjust.getCoolingSetpointAdjust();

                    if (!hsp.getValidator().isValid(newValue) || !csp.getValidator().isValid(newValue))
                    {
                        throw new ServletException("Error, trying to set setpoint to invalid value of:"+newValue);
                    }

                    csp.set(Float.parseFloat(newValue));
                    if (!adjust.isHeatingAndCoolingLinked())
                    {
                        hsp.set(Float.parseFloat(newValue));
                    }
                }
            });
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
