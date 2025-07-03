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
public class ExamsDAO {

    private static final String Get_ExamsByCategory = "SELECT e.exam_id, e.exam_title, e.Subject, e.category_id, e.total_marks, e.Duration, c.category_name FROM tblExams e JOIN tblExamCategories c ON e.category_id = c.category_id WHERE e.category_id = ?";
    private static final String Create_ExamWithCategory = "INSERT INTO tblExams (exam_id, exam_title, Subject, category_id, total_marks, Duration) VALUES (?, ?, ?, ?, ?, ?)";

    public List<ExamsDTO> getExamsByCategory(int categoryId) throws SQLException {
        List<ExamsDTO> exams = new ArrayList<>();
        String sql = Get_ExamsByCategory;
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, categoryId);
            rs = ps.executeQuery();

            while (rs.next()) {
                ExamsDTO exam = new ExamsDTO();
                exam.setExam_id(rs.getInt("exam_id"));
                exam.setExam_title(rs.getString("exam_title"));
                exam.setSubject(rs.getString("Subject"));
                exam.setCategory_id(rs.getInt("category_id"));
                exam.setTotal_marks(rs.getInt("total_marks"));
                exam.setDuration(rs.getInt("Duration"));
                // Add category name to the exam object if needed
                exam.setCategory_name(rs.getString("category_name"));

                exams.add(exam);
            }
        } catch (Exception e) {
            System.err.println("Error in getExamsByCategory(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return exams;
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
            e.printStackTrace();
        }
    }

    public boolean createExam(ExamsDTO exam) throws SQLException {
        String sql = Create_ExamWithCategory;
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(sql);

            ps.setInt(1, exam.getExam_id());
            ps.setString(2, exam.getExam_title());
            ps.setString(3, exam.getSubject());
            ps.setInt(4, exam.getCategory_id());
            ps.setInt(5, exam.getTotal_marks());
            ps.setInt(6, exam.getDuration());

            success = ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.err.println("Error in creatExam(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    public int getMaxExamId() throws SQLException {
        String sql = "SELECT MAX(exam_id) + 1 AS max_id  FROM tblExams";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        int maxId = 0;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                maxId = rs.getInt("max_id");
            }

        } catch (Exception e) {
            System.err.println("Error in getNextExamId(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return maxId + 1;
    }
}
