/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author Admin
 */
public class ProjectsDAO {

    public ProjectsDAO() {
    }

    public boolean addProject(ProjectsDTO project) {
        String sql = "INSERT INTO tblStartupProjects (project_name, Description, Status, estimated_launch) VALUES (?, ?, ?, ?)";
        boolean success = false;
        PreparedStatement pr = null;
        Connection conn = null;

        try {
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);

            pr.setString(1, project.getProject_name());
            pr.setString(2, project.getDescription());
            pr.setString(3, project.getStatus());
            pr.setDate(4, project.getEstimated_launch());

            success = pr.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in createProject(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pr, null);
        }
        return success;
    }

    public List<ProjectsDTO> getAllProjects() throws SQLException {
        List<ProjectsDTO> projects = new ArrayList<>();
        String sql = "SELECT project_id, project_name, Description, Status, estimated_launch FROM tblStartupProjects";
        Connection conn = null;
        PreparedStatement pr = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);
            rs = pr.executeQuery();

            while (rs.next()) {
                ProjectsDTO project = new ProjectsDTO();
                project.setProject_id(rs.getInt("project_id"));
                project.setProject_name(rs.getString("project_name"));
                project.setDescription(rs.getString("Description"));
                project.setStatus(rs.getString("Status"));
                project.setEstimated_launch(rs.getDate("estimated_launch"));

                projects.add(project);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pr, rs);
        }
        return projects;
    }

    public boolean updateProjectStatus(int projectId, String newStatus) {
        String sql = "UPDATE tblStartupProjects SET Status = ? WHERE project_id = ?";
        Connection conn = null;
        PreparedStatement pr = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);

            pr.setString(1, newStatus);
            pr.setInt(2, projectId);

            success = pr.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in updateProjectStatus(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pr, null);
        }
        return success;
    }

    public List<ProjectsDTO> searchProjectsByName(String name) {
        List<ProjectsDTO> projects = new ArrayList<>();
        String sql = "SELECT project_id, project_name, Description, Status, estimated_launch FROM tblStartupProjects WHERE project_name LIKE ?";
        Connection conn = null;
        PreparedStatement pr = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);
            pr.setString(1, "%" + name + "%");
            rs = pr.executeQuery();

            while (rs.next()) {
                ProjectsDTO project = new ProjectsDTO();
                project.setProject_id(rs.getInt("project_id"));
                project.setProject_name(rs.getString("project_name"));
                project.setDescription(rs.getString("Description"));
                project.setStatus(rs.getString("Status"));
                project.setEstimated_launch(rs.getDate("estimated_launch"));

                projects.add(project);
            }
        } catch (Exception e) {
            System.err.println("Error in searchProjectsByName(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pr, rs);
        }
        return projects;
    }

    private void closeResources(Connection conn, PreparedStatement pr, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pr != null) {
                pr.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (Exception e) {
            System.err.println("Error closing resources: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public ProjectsDTO getProjectByName(String name) {
        String sql = "SELECT * FROM tblStartupProjects WHERE project_name = ?";
        Connection conn = null;
        PreparedStatement pr = null;
        ResultSet rs = null;
        ProjectsDTO project = null;

        try {
            conn = DbUtils.getConnection();
            pr = conn.prepareStatement(sql);
            pr.setString(1, name);
            rs = pr.executeQuery();

            if (rs.next()) {
                project = new ProjectsDTO();
                project.setProject_id(rs.getInt("project_id"));
                project.setProject_name(rs.getString("project_name"));
                project.setDescription(rs.getString("Description"));
                project.setStatus(rs.getString("Status"));
                project.setEstimated_launch(rs.getDate("estimated_launch"));
            }

        } catch (Exception e) {
            System.err.println("Error in isProductExists(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, pr, rs);
        }
        return project;
    }
    
    public boolean isProjectExists(String projectName) {
        return getProjectByName(projectName) != null;
    }
}
