/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ManagerUser;

import InOutData.InPutData;
import InOutData.OutPutData;
import Log.Logger;
import Serveur.RoleUser;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Queue;
import org.jdom2.Element;

/**
 *
 * @author zouhairhajji
 */
public abstract class ManagerDB implements Runnable{
    
    protected OutPutData out;
    protected InPutData in;
    protected RoleUser role;
    
    protected Thread T;
    protected boolean running;
    
    protected Connection connexion;
    
    public ManagerDB(InPutData in, OutPutData data,  Logger logger, Connection connection ,Queue<Connection> connections) {
        this.out = data;
        this.in = in;
        this.running = false;
        this.connexion = connection;
    }
    
    
    
    public Thread startThread() {
        if(this.running)
            return T;
        this.running = true;
        this.T = new Thread(this);
        this.T.start();
        return T;
    }

    public void stopThread() {
        this.running = false;
    }
    
    
    
    public Element seConnecter(){
       
        try {
            String login    = in.getLastDocument().getRootElement().getChild("login").getValue();
            String passWord = in.getLastDocument().getRootElement().getChild("passWord").getValue();
            
            PreparedStatement st = Database.Database.getConnexion().prepareStatement("SELECT * FROM `Account` WHERE ndc = ? AND psw = ?");
            st.setString(1, login);
            st.setString(2, passWord);
            ResultSet rs = st.executeQuery();
            
            Element root = new Element("InformationUser");
            
            if(!rs.next()){
                return null;
            }else{
                Element eIdCompte =  new Element("idCompte");
                eIdCompte.setText(rs.getString("id_account"));
                
                Element eUser =  new Element("login");
                eUser.setText(rs.getString("ndc"));
                
                Element eRole =  new Element("role");
                eRole.setText(rs.getString("role"));
                
                
                this.role = RoleUser.FactoryGetRole(rs.getString("role"));
                
                
                Element eDateCreation =  new Element("dateCreation");
                eDateCreation.setText(rs.getString("dateCreation"));
                
                Element equestionSecrete =  new Element("questionSecrete");
                equestionSecrete.setText(rs.getString("questionSecrete"));
                
                root.addContent(eIdCompte);
                root.addContent(eUser);
                root.addContent(eRole);
                root.addContent(eDateCreation);
                root.addContent(equestionSecrete);
                
                return root;
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            return null;
        }
    }
    
    public boolean quitter(){
        return false;
    }
    
    
    public void askAfficherInformation(int idClient){
        
    }
    
    public abstract Element listerAllClient();

    public RoleUser getRole() {
        return role;
    }

    
    
}
