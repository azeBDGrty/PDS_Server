/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.server;

import com.pds.usermanager.ManagerDB;
import com.pds.inoutdata.InPutData;
import com.pds.inoutdata.OutPutData;
import com.pds.log.Logger;
import java.sql.Connection;
import java.util.Queue;
import org.jdom2.Element;

/**
 *
 * @author zouhairhajji
 */
public class Anonyme extends ManagerDB{

    public Anonyme(InPutData in, OutPutData data, Logger logger, Connection connection, Queue<Connection> connections) {
        super(in, data, logger, connection, connections);
    }

    

   

    
    

    @Override
    public Element listerAllClient() {
        return null;
    }
    
    
    public boolean quitter(){
        return super.quitter();
    }

    @Override
    public void run() {
        
    }
    
}
