/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.log;

import java.io.File;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 *
 * @author zouhairhajji
 */
public class Logger {
    
    
    protected StringBuilder logBuilder;
    private String lastLog;
    
    private String nameLog;
    
    public Logger(String name) {
        this.logBuilder = new StringBuilder();
        this.nameLog = name;
    }
    
    
    public static String getDate(){
       return new SimpleDateFormat("yyyy/MM/dd HH:mm:ss").format(new Date());
    }
    
    
    private String log(String type,String message){
         this.lastLog =  "["+type+" " + getDate() + " ] : "+message;
         this.logBuilder.append(this.lastLog+"\n");
         return this.lastLog;
    }   
    
    
    public String info(String message){
        return log("info", message);
       
    }   
    
    public String warn(String message){
        return log("warn", message);
    }    

    
    
    
    public String getLastLog() {
        return lastLog;
    }
    
    
    
    @Override
    public String toString(){
        return this.logBuilder.toString();
    }
    
    
    public void writeInFile(){
        
    }
    
    
    
}
