/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Serveur;

import ManagerUser.ManagerDB;
import InOutData.InPutData;
import InOutData.OutPutData;
import Log.Logger;
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
