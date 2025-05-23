/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;

/**
 *
 * @author Admin
 */
public class UserDAO {

    ArrayList<UserDTO> list;

    public UserDAO() {
        this.list = new ArrayList<>();
        list.add(new UserDTO("admin", "Administrator", "1", "AD", true));
        list.add(new UserDTO("se193604", "Tran Anh Vu", "hcm", "MB", true));
    }

    public boolean login(String username, String password) {
        for (UserDTO userDTO : list) {
            if ((userDTO.getUserId().equals(username))
                    && userDTO.getPassword().equals(password)) {
                return true;
            }
        }
        return false;
    }

    public UserDTO getUserById(String userId) {
        for (UserDTO userDTO : list) {
            if (userDTO.getUserId().equals(userId)) {
                return userDTO;
            }
        }
        return null;
    }
}

