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
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Queue;
import java.util.logging.Level;
import org.jdom2.Document;
import org.jdom2.Element;
import org.jdom2.output.XMLOutputter;

/**
 *
 * @author zouhairhajji
 */
public class ManagerConseiller extends ManagerDB {

    public ManagerConseiller(InPutData in, OutPutData data, Logger logger, Connection connection, Queue<Connection> connections) {
        super(in, data, logger, connection, connections);
    }

    @Override
    public void run() {
        while (running) {

            try {
                switch (this.in.getCommand()) {

                    case askAuthentification:
                        this.out.sendConnectionDone(null);
                        break;

                    case askAllClient:
                        this.out.sendAllClient(listerAllClient());
                        break;

                    case askInformationClient:
                        Element element = getOwnInformationClient(this.in.getLastDocument());
                        this.out.sendOwnInformationClient(element);
                        break;

                    case askDeleteClient:
                        this.deleteClient(this.in.getLastDocument().getRootElement());
                        this.out.sendAllClient(listerAllClient());
                        break;

                    case askAllRegion:
                        this.out.sendALlRegion(getAllRegions());
                        break;

                    case askAllDepartement:
                        this.out.sendALlDepartement(getAllDepartement());
                        break;

                    case askAllPays:
                        this.out.sendALlPays(getAllPays());
                        break;
                    case askSimulationPretsClient:

                        break;
                    default:
                        this.out.sendNeedRight(null);
                        break;
                }

            } catch (Exception ex) {
                ex.printStackTrace();
                stopThread();
            }
        }
    }

    private Element getOwnInformationClient(Document lastDocument) throws SQLException {
        int idConseille = Integer.parseInt(lastDocument.getRootElement().getChildText("idConseille"));
        String query = "   SELECT * FROM employe e "
                + "   LEFT JOIN Pays  p ON (e.id_pays = p.id_pays) "
                + "   LEFT JOIN Info_Personnelle i on (i.id_info_perso = e.id_info_perso)"
                + "   LEFT JOIN Account a ON (a.id_account = e.id_account) "
                + "   LEFT JOIN Departement d ON (d.id_departement = e.id_departement) "
                + "   LEFT JOIN Pays pn ON (e.id_pays_Naissance = pn.id_pays) "
                + "   LEFT JOIN Region r ON (r.id_region = d.id_region) "
                + "   WHERE e.id_account = ?";
        PreparedStatement st = connexion.prepareStatement(query);
        st.setString(1, idConseille + "");
        ResultSet rs = st.executeQuery();
        Element root = new Element("rootElement");

        while (rs.next()) {
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) {
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), root);
            }
        }
        return root;
    }

    public void createChildElement(ResultSet rs, String rsNameValue, String nameAttribut, Element root) throws SQLException {
        Element element = new Element(nameAttribut);
        element.setText(rs.getString(rsNameValue));
        root.addContent(element);
    }

    @Override
    public Element listerAllClient() {
        String query = "SELECT * "
                + "FROM "
                + "Client c, Info_Personnelle i, Account a, Pays pN, Departement d, Region r, Agence ag "
                + "where "
                + "i.id_info_perso = c.id_info_perso and c.id_account = a.id_account and pN.id_pays = c.id_pays and d.id_departement = c.id_departement AND r.id_region = d.id_region and ag.id_agence = c.id_domiciliation";

        String query2 = "SELECT * FROM Simul_Pret sp, calcPret cp, Taux_Directeur td, Type_Pret tp  WHERE cp.id_calcPret = sp.id_calcPret and cp.id_tauxDirecteur = td.id_tauxDirecteur AND tp.id_type_pret = sp.id_type_pret AND sp.id_client=?";
        Element root = new Element("AllClient");
        List<Element> clientsInfo = new ArrayList<>();
        
        try {
            PreparedStatement st = connexion.prepareStatement(query);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                Element eRegion = new Element("Client");
                ResultSetMetaData columns = rs.getMetaData();
                for (int i = 1; i <= columns.getColumnCount(); i++) {
                    createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), eRegion);
                }

                clientsInfo.add(eRegion);
            }
        } catch (SQLException ex) {
            System.out.println("Exception :" + ex.getMessage());
            return null;
        }
        
        
        // Adding Simulations
        for(Element  element : clientsInfo){
            try {
                PreparedStatement st = connexion.prepareStatement(query2);
                st.setString(1, element.getChildText("id_client"));
                ResultSet rs = st.executeQuery();
                while(rs.next()){
                    Element eSimulation = new Element("simulation");
                    ResultSetMetaData columns = rs.getMetaData();
                    for (int i = 1; i <= columns.getColumnCount(); i++) {
                        createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), eSimulation);
                    }
                    element.addContent(eSimulation);
                }
            } catch (SQLException ex) {
               ex.printStackTrace();
            }
            
        }
        
        
        
        for(Element  element : clientsInfo)
            root.addContent(element);
        return root;
    }

    private boolean deleteClient(Element element) {
        int idClient = Integer.parseInt(element.getChild("idClient").getValue());
        String query1 = "Delete FROM `Info_Personnelle` where  id_info_perso = (SELECT id_info_perso FROM Client where id_client=? );";
        String query2 = "Delete FROM `Account` where  id_account = (SELECT id_account FROM Client where id_client=? );";
        String query3 = "Delete FROM `Client` where  id_client =  ?";

        try {
            PreparedStatement st = connexion.prepareStatement(query1);
            st.setInt(1, idClient);
            st.executeUpdate();

            st = connexion.prepareStatement(query2);
            st.setInt(1, idClient);
            st.executeUpdate();

            st = connexion.prepareStatement(query3);
            st.setInt(1, idClient);
            st.executeUpdate();

            return true;
        } catch (SQLException ex) {
            ex.printStackTrace();
            return false;
        }

    }

    private Element getAllRegions() throws SQLException {
        String query = "SELECT * FROM Region";
        PreparedStatement st = connexion.prepareStatement(query);
        ResultSet rs = st.executeQuery();
        Element root = new Element("rootElement");
        while (rs.next()) {
            Element eRegion = new Element("region");
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) {
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), eRegion);
            }
            root.addContent(eRegion);
        }
        return root;
    }

    private Element getAllDepartement() throws SQLException {
        String query = "SELECT * FROM `Departement` NATURAL JOIN `Region` ";
        PreparedStatement st = connexion.prepareStatement(query);
        ResultSet rs = st.executeQuery();
        Element root = new Element("rootElement");
        while (rs.next()) {
            Element eRegion = new Element("departement");
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) {
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), eRegion);
            }
            root.addContent(eRegion);
        }
        return root;
    }

    private Element getAllPays() throws SQLException {
        String query = "SELECT * FROM `Pays` ";
        PreparedStatement st = connexion.prepareStatement(query);
        ResultSet rs = st.executeQuery();
        Element root = new Element("rootElement");
        while (rs.next()) {
            Element eRegion = new Element("pays");
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) {
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), eRegion);
            }
            root.addContent(eRegion);
        }
        return root;
    }

}
