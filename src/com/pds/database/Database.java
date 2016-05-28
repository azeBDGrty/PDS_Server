package com.pds.database;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author zouhairhajji
 */
public class Database {
    
    private static Connection connexion;
    /*
    private static String nameDB = "BDG_PREPROD";
    private static String ipDB = "10.10.10.10";
    private static String url = "jdbc:mysql://"+ipDB+"/"+nameDB;
    private static String login = "root";
    private static String password = "bdgrootbdd";
    public static String dbPrefix = "db_";
    
    private static String nameDB = "pds_bdg";
    private static String ipDB = "localhost";
    private static String url = "jdbc:mysql://"+ipDB+"/"+nameDB;
    private static String login = "root";
    private static String password = "";
    public static String dbPrefix = "db_";*/
    
     private static String nameDB = "pds3";
    private static String ipDB = "localhost";
    private static String url = "jdbc:mysql://"+ipDB+"/"+nameDB;
    private static String login = "root";
    private static String password = "";
    
    public static Connection getConnexion() throws ClassNotFoundException, SQLException{
        if ( connexion != null )
            return connexion;
        
        else{
            Class.forName("com.mysql.jdbc.Driver");   
            connexion = DriverManager.getConnection(url, login, password);
            return connexion;
        } 
    }
    
    public static Statement getStatement() throws ClassNotFoundException, SQLException{
        return getConnexion().createStatement();
    }
    
    
}
