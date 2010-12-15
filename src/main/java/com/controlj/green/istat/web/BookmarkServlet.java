package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.InvalidConnectionRequestException;
import com.controlj.green.addonsupport.access.*;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

// todo - don't think this is used anymore - investigate and remove

public class BookmarkServlet extends HttpServlet {
    public BookmarkServlet() {
        super();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        //System.out.println("Area Servlet called at:"+new Date());

        resp.setHeader("Expires", "Wed, 01 Jan 2003 12:00:00 GMT");
        resp.setHeader("Cache-Control", "no-cache");
        ServletOutputStream out = resp.getOutputStream();
        try {
            writeLocations(out, req.getParameterValues("bookmarks"), req);
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

    public void writeLocations(final ServletOutputStream out, final String locations[], HttpServletRequest req) throws IOException, SystemException, ActionExecutionException, InvalidConnectionRequestException {
        out.println("[");

        SystemConnection connection = DirectAccess.getDirectAccess().getUserSystemConnection(req);

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

}