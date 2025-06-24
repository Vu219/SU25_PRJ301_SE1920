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
public class ProductDAO {

    private static final String GET_ALL_PRODUCTS = "SELECT id, name, image, description, price, size, status FROM tblProducts";
    private static final String GET_PRODUCT_BY_ID = "SELECT id, name, image, description, price, size, status FROM tblProducts WHERE id = ?";
    private static final String CREATE_PRODUCT = "INSERT INTO tblProducts (id, name, image, description, price, size, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String UPDATE_PRODUCT = "UPDATE tblProducts SET name = ?, image = ?, description = ?, price = ?, size = ?, status = ? WHERE id = ?";
    private static final String DELETE_PRODUCT = "DELETE FROM tblProducts WHERE id = ?";
    private static final String SEARCH_PRODUCTS_BY_NAME = "SELECT id, name, image, description, price, size, status FROM tblProducts WHERE name LIKE ? AND status = 1";
    private static final String GET_ACTIVE_PRODUCTS = "SELECT id, name, image, description, price, size, status FROM tblProducts WHERE status = 1";

    //get AllProduct
    public List<ProductDTO> getAllProducts() throws SQLException {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ALL_PRODUCTS);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));

                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getAll(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }

    //get ProductById
    public ProductDTO getProductById(String id) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        ProductDTO product = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_PRODUCT_BY_ID);
            ps.setString(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));
            }
        } catch (Exception e) {
            System.err.println("Error in getProductByID(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return product;
    }

    //creat Product
    public boolean createProduct(ProductDTO product) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(CREATE_PRODUCT);
            ps.setString(1, product.getId());
            ps.setString(2, product.getName());
            ps.setString(3, product.getImage());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getSize());
            ps.setBoolean(7, product.isStatus());

            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in createProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    //update Product
    public boolean updateProduct(ProductDTO product) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(UPDATE_PRODUCT);
            ps.setString(1, product.getName());
            ps.setString(2, product.getImage());
            ps.setString(3, product.getDescription());
            ps.setDouble(4, product.getPrice());
            ps.setString(5, product.getSize());
            ps.setBoolean(6, product.isStatus());
            ps.setString(7, product.getId());

            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in updateProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    //delete Product
    public boolean deleteProduct(String id) {
        Connection conn = null;
        PreparedStatement ps = null;
        boolean success = false;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(DELETE_PRODUCT);
            ps.setString(1, id);

            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Error in deleteProduct(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, null);
        }
        return success;
    }

    //search Product By Name
    public List<ProductDTO> searchProductsByName(String name) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(SEARCH_PRODUCTS_BY_NAME);
            ps.setString(1, "%" + name + "%");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));

                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in searchProductsByName(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }

    //get Active Product
    public List<ProductDTO> getActiveProducts() {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(GET_ACTIVE_PRODUCTS);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));

                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getActiveProducts(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }
        return products;
    }

    /**
     * Close database resources safely
     *
     * @param conn Connection to close
     * @param ps PreparedStatement to close
     * @param rs ResultSet to close
     */
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

    public boolean isProductExists(String id) {
        return getProductById(id) != null;
    }

    public List<ProductDTO> getProductsByStatus(boolean status) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = GET_ALL_PRODUCTS + " WHERE status = ?";

        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(query);
            ps.setBoolean(1, status);
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));

                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getProductsByStatus(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return products;
    }
    
    public boolean updateProductStatus(String productId, boolean status) {
        ProductDTO product = getProductById(productId);
        if(product != null) {
            product.setStatus(status);
            return updateProduct(product);
        }else {
            return false;
        }
    }
    
    public List<ProductDTO> getActiveProductsByName(String name) {
        List<ProductDTO> products = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String query = GET_ALL_PRODUCTS + " WHERE name like ? and status=1";
        System.out.println(query);
        try {
            conn = DbUtils.getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, "%"+name+"%");
            rs = ps.executeQuery();

            while (rs.next()) {
                ProductDTO product = new ProductDTO();
                product.setId(rs.getString("id"));
                product.setName(rs.getString("name"));
                product.setImage(rs.getString("image"));
                product.setDescription(rs.getString("description"));
                product.setPrice(rs.getDouble("price"));
                product.setSize(rs.getString("size"));
                product.setStatus(rs.getBoolean("status"));

                products.add(product);
            }
        } catch (Exception e) {
            System.err.println("Error in getProductsByStatus(): " + e.getMessage());
            e.printStackTrace();
        } finally {
            closeResources(conn, ps, rs);
        }

        return products;
    }

    
}

