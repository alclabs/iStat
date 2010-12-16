/*
 * Copyright (c) 2010 Automated Logic Corporation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package com.controlj.green.istat.web;

import com.controlj.green.addonsupport.access.*;
import com.controlj.green.addonsupport.access.aspect.SetPoint;
import com.controlj.green.addonsupport.access.util.Acceptors;
import org.jetbrains.annotations.NotNull;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collection;


// Todo - don't think this class is used any more.  Investigate and remove

public class MakeLocations extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            storeLocations();
            PrintWriter out = response.getWriter();
            out.println("<html><body>");

            ArrayList<String> results = getLocations();
            for (String result : results) {
                out.println("<div>"+result+"<div>");
            }
            out.println("</body></html>");
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    public void storeLocations() throws Exception
    {
        SystemConnection connection = DirectAccess.getDirectAccess().getRootSystemConnection();
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

    public ArrayList<String> getLocations() throws Exception
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
