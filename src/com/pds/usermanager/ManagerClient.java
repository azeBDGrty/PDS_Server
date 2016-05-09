/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.usermanager;

import com.pds.inoutdata.InPutData;
import com.pds.inoutdata.OutPutData;
import com.pds.log.Logger;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Queue;
import org.jdom2.Element;

/**
 *
 * @author zouhairhajji
 */
public class ManagerClient extends ManagerDB {

    public ManagerClient(InPutData in, OutPutData data, Logger logger, Connection connection, Queue<Connection> connections) {
        super(in, data, logger, connection, connections);
    }
    
    

    @Override
    public Element listerAllClient() {
        return null;
    }
    
    
    
    

    @Override
    public void run() {
        while (running) {
            
            try {
                switch (this.in.getCommand()) {
                    case askAuthentification : 
                        this.out.sendConnectionDone(null);
                        break;
                    
                        
                    default :
                        this.out.sendNeedRight(null);
                        break;
                }
            } catch (Exception ex) {
                stopThread();
            }
        }
    }
    
    

}
