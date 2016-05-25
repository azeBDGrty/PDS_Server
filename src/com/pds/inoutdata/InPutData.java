/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.inoutdata;

import com.pds.networkprotocol.Receive;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.Socket;
import javax.xml.parsers.*;
//import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import static com.pds.networkprotocol.Receive.*;
import static com.pds.networkprotocol.Send.*;
import java.io.File;
import org.jdom2.Document;
import org.jdom2.input.SAXBuilder;

/**
 *
 * @author zouhairhajji
 */
public class InPutData {
    
    
    
    
    
    private Receive lastCommand;
    private BufferedReader reader;
    private Document lastDocument ;
    
    
    public InPutData(Socket socket) throws IOException {
        this.reader = new BufferedReader(new InputStreamReader(socket.getInputStream()));
    }
    
    private synchronized String readMessage() throws IOException{
        String message = reader.readLine();
        if (message == null) 
            throw new IOException();
        return message;
    }
    
    
    
    public synchronized void readElement() throws IOException{
        String ElementBuilder = "";
        String message = "";
        
        while( !  ".".equalsIgnoreCase(message = readMessage()) ){
            ElementBuilder += message; 
        }
        
        try {
            this.lastDocument = new SAXBuilder().build(new InputSource( new StringReader( ElementBuilder ) ));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public synchronized Receive getCommand() throws IOException{
        String message = readMessage();
        switch(message){
            case "askAuthentification":
                readElement();
                this.lastCommand = askAuthentification;
                break;
                
            case "askAllClient": 
                this.lastCommand = askAllClient;
                break;
               
                
            case "askDeleteClient": 
                readElement();
                this.lastCommand = askDeleteClient;
                break;    
                
                
            case "askInformationClient":
                readElement();
                this.lastCommand = askInformationClient;
                break;
                
            case "askIndicatorInfo": 
                this.lastCommand = askIndicatorInfo;
                readElement();
                break;    
                
                
                
            case "askAllRegion":
                this.lastCommand = askAllRegion;
                break;
                
            case "askAllDepartement":
                this.lastCommand = askAllDepartement;
                break;
                
            case "askAllPays":
                this.lastCommand = askAllPays;
                break;
                
                
            case "askSimulationClient": 
                this.lastCommand = askSimulationClient;
                readElement();
                break;
                
            case "askSimulationPretsClient": 
                this.lastCommand = askSimulationPretsClient;
                readElement(); // on dot recuperer le id du client concerné
                
                break;
                
            default :
                this.lastCommand = none;
                break;
        }
        return this.lastCommand;
    }

    public synchronized Document getLastDocument() {
        return this.lastDocument;
    }

    public synchronized Receive getLastCommand() {
        return lastCommand;
    }
    
    
    
}
