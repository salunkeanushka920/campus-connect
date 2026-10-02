package com.campusconnect.controller;

import com.campusconnect.dao.LocationDAO;
import com.campusconnect.model.CampusLocation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Servlet handling Admin Location additions and toggles.
 */
@WebServlet(name = "LocationServlet", urlPatterns = {"/admin/location"})
public class LocationServlet extends HttpServlet {

    private final LocationDAO locationDAO = new LocationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?portal=admin&error=Unauthorized.");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            String block = request.getParameter("block");
            String locationName = request.getParameter("locationName");
            String locationType = request.getParameter("locationType");

            if (block != null && locationName != null && locationType != null &&
                !block.trim().isEmpty() && !locationName.trim().isEmpty()) {
                CampusLocation loc = new CampusLocation(0, block.trim(), locationName.trim(), locationType.trim(), true);
                locationDAO.addLocation(loc);
                response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?success=New+location+added+successfully.");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?error=Please+provide+block+and+room+name.");
        } else if ("toggle".equalsIgnoreCase(action)) {
            String idStr = request.getParameter("id");
            String activeStr = request.getParameter("active");
            if (idStr != null && activeStr != null) {
                try {
                    int id = Integer.parseInt(idStr.trim());
                    boolean active = Boolean.parseBoolean(activeStr.trim());
                    locationDAO.toggleLocationStatus(id, active);
                } catch (Exception ignored) {}
            }
            response.sendRedirect(request.getContextPath() + "/admin/locations.jsp?success=Location+status+updated.");
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/locations.jsp");
        }
    }
}
