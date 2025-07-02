/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class UserDTO {
    private String Username;
    private String Name;
    private String Password;
    private String Role;

    public UserDTO() {
    }

    public UserDTO(String Username, String Name, String Password, String Role) {
        this.Username = Username;
        this.Name = Name;
        this.Password = Password;
        this.Role = Role;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getRole() {
        return Role;
    }

    public void setRole(String Role) {
        this.Role = Role;
    }
    
    
}
