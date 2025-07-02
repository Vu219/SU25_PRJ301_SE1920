/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author Admin
 */
public class UserDAO {

    public UserDAO() {
    }

    public boolean login(String username, String password) {
        try {
            UserDTO user = getUserByUsername(username);
            if (user != null) {
                return user.getPassword().equals(password);
            }
        } catch (Exception e) {
        }
        return false;
    }

    public UserDTO getUserByUsername(String username) {
        UserDTO userDTO = null;
        Connection conn = null;
        PreparedStatement pr = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM tblUsers WHERE Username = ?";

            
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);
            pr.setString(1, username);
            rs = pr.executeQuery();

            if (rs.next()) {
                String userName = rs.getString("Username");
                String name = rs.getString("Name");
                String password = rs.getString("Password");
                String role = rs.getString("Role");

                userDTO = new UserDTO(userName, name, password, role);
                return userDTO;
            }
        } catch (Exception e) {
        } finally {
            closeResources(conn, pr, rs);
        }
        return userDTO;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }

    public List<UserDTO> getAllUsers() {
        List<UserDTO> userList = new ArrayList<>();
        String sql = "SELECT * FROM tblUsers ORDER BY Username";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement pr = conn.prepareStatement(sql);
            ResultSet rs = pr.executeQuery();
            while (rs.next()) {
                UserDTO user = new UserDTO();
                user.setUsername(rs.getString("Username"));
                user.setName(rs.getString("Name"));
                user.setPassword(rs.getString("Password"));
                user.setRole(rs.getString("Role"));
                userList.add(user);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return userList;
    }
    
    public boolean updatePassword(String Username, String newPassword) {
        String sql = "UPDATE tblUsers SET password = ? WHERE Username = ?";
        try {
            Connection conn = DbUtils.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newPassword);
            ps.setString(2, Username);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
