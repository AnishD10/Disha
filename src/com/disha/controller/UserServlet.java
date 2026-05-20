package com.disha.controller;

import dao.UserDAO;
import com.disha.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;
import java.util.List;

/**
 * UserServlet handles all user management CRUD operations for admin panel.
 */
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) { String hex = Integer.toHexString(0xff & b); if (hex.length() == 1) sb.append('0'); sb.append(hex); }
            return sb.toString();
        } catch (Exception ex) { throw new RuntimeException(ex); }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/JSP/admin/add-user.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                User editUser = userDAO.getUserById(editId);
                request.setAttribute("editUser", editUser);
                request.getRequestDispatcher("/JSP/admin/edit-user.jsp").forward(request, response);
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                userDAO.deleteUser(deleteId);
                response.sendRedirect(request.getContextPath() + "/admin/users?action=list&msg=deleted");
                break;
            default: // list
                String search = request.getParameter("search");
                String roleFilter = request.getParameter("role");
                List<User> users;
                if (search != null && !search.trim().isEmpty()) {
                    users = userDAO.searchUsers(search.trim());
                } else if (roleFilter != null && !roleFilter.isEmpty()) {
                    users = userDAO.getUsersByRole(roleFilter);
                } else {
                    users = userDAO.getAllUsers();
                }
                request.setAttribute("users", users);
                request.setAttribute("searchQuery", search);
                request.setAttribute("roleFilter", roleFilter);
                request.getRequestDispatcher("/JSP/admin/manage-users.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            User user = new User();
            user.setFirstName(request.getParameter("firstName"));
            user.setLastName(request.getParameter("lastName"));
            user.setEmail(request.getParameter("email"));
            user.setPhone(request.getParameter("phone"));
            try { user.setRole(User.Role.valueOf(request.getParameter("role"))); }
            catch (Exception e) { user.setRole(User.Role.STUDENT); }

            String password = request.getParameter("password");
            User created = userDAO.createUser(user, hashPassword(password));
            if (created != null) {
                response.sendRedirect(request.getContextPath() + "/admin/users?action=list&msg=added");
            } else {
                request.setAttribute("errorMessage", "Failed to add user. Email may already exist.");
                request.getRequestDispatcher("/JSP/admin/add-user.jsp").forward(request, response);
            }
        } else if ("edit".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("userId"));
            User user = userDAO.getUserById(userId);
            if (user != null) {
                user.setFirstName(request.getParameter("firstName"));
                user.setLastName(request.getParameter("lastName"));
                user.setEmail(request.getParameter("email"));
                user.setPhone(request.getParameter("phone"));
                try { user.setRole(User.Role.valueOf(request.getParameter("role"))); }
                catch (Exception e) {}
                user.setActive("on".equals(request.getParameter("isActive")) || "true".equals(request.getParameter("isActive")));
                userDAO.updateUser(user);
            }
            response.sendRedirect(request.getContextPath() + "/admin/users?action=list&msg=updated");
        }
    }
}
