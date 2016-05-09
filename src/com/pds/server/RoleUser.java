/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.server;

/**
 *
 * @author zouhairhajji
 */
public enum RoleUser {
 
    client("User"),
    conseiller("Cons"),
    directeurBank("DirAge"),
    directeurAgence("DirBnk");
    
    private String abv;

    private RoleUser(String abv) {
        this.abv = abv;
    }

    public String getAbv() {
        return abv;
    }
    
    public static RoleUser FactoryGetRole(String role){
        switch(role.trim()){
            case "Cons" : 
                return conseiller;
                
            case "DirAge" : 
                return directeurAgence;
                
            case "DirBnk" : 
                return directeurBank; 
                
            case "User" : 
                return client;
                
            default : 
                break;
                
        }
      return null;  
    }
    
    
}
