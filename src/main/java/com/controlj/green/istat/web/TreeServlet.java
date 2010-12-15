package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.InvalidConnectionRequestException;
import com.controlj.green.addonsupport.access.*;
import com.controlj.green.addonsupport.access.aspect.SetPoint;
import com.controlj.green.addonsupport.access.aspect.SetPointAdjust;
import com.controlj.green.addonsupport.access.util.Acceptors;
import com.controlj.green.addonsupport.access.util.LocationSort;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
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
            writeLevel(out, req.getParameter(LOCATION_PARAM), req);
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

    public void writeLevel(final ServletOutputStream out, final String location, HttpServletRequest req) throws IOException, SystemException, ActionExecutionException, InvalidConnectionRequestException {
        out.println("[");

        SystemConnection connection = DirectAccess.getDirectAccess().getUserSystemConnection(req);

        connection.runReadAction(new ReadAction(){
            public void execute(@NotNull SystemAccess access) throws Exception {
                Location parent;
                if (location == null || location.length()==0) {
                    parent = access.getGeoRoot();
                } else
                {
                    parent = access.getGeoRoot().getTree().resolve(location);
                }
                Collection<Location> childrenLocs = parent.getChildren(LocationSort.PRESENTATION);
                HasDecendentAspects acceptor = new HasDecendentAspects(SetPoint.class, SetPointAdjust.class);

                for (Location nextLoc : childrenLocs)
                {
                    if (!acceptor.accept(nextLoc)) {
                        continue;
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

    private class HasDecendentAspects
    {
        Class<? extends Aspect> testAspects[];

        HasDecendentAspects(Class<? extends Aspect>... aspects)
        {
            this.testAspects = aspects;
        }

        public boolean accept(@NotNull Location loc) {
            for (Class<? extends Aspect> testAspect : testAspects) {
                if (loc.find(testAspect, Acceptors.acceptAll()).isEmpty()) {
                    return false;
                }
            }
            return true;
        }
    }


}