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
import java.sql.Statement;
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
                    
                    case askTauxInteret: 
                        this.out.sendTauxInteret(getTauxInteretConcerned());
                        break;

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
                                        
                    case askAvgAge : 
                        this.out.sendAvgAge(getAgebyLoan(this.in.getLastDocument().getRootElement()));
                        break;
                        
                     case askLoanNumber : 
                        this.out.sendLoanNumber(getLoanNumbers(this.in.getLastDocument().getRootElement()));
                        break;
                         
                      case askSimNumber: 
                        this.out.sendSimNumber(getSimNumbers(this.in.getLastDocument().getRootElement()));
                        break;   
                    
                    case askAvgAmount: 
                        this.out.sendAvgAmount(getAvgAmount(this.in.getLastDocument().getRootElement()));
                        break;  
                        
                    case askLoanTime: 
                        this.out.sendLoanTime(getLoanTime(this.in.getLastDocument().getRootElement()));
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
                        this.out.sendAllSimPretClient(getAllSimulations());
                        
                        break;
                        
                    case askSimulationClient : 
                        this.out.sendAllSimPretClient(getAllSimulations());
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
    
    private Element getAllSimulations() throws SQLException{
        //int idClient = Integer.parseInt(e.getRootElement().getChildText("id_client"));
        String query = ("SELECT * FROM simul_pret,calcpret,taux_directeur WHERE simul_pret.id_calcPret=calcPret.id_calcPret "
                + "AND calcpret.id_tauxDirecteur=taux_directeur.id_tauxDirecteur");
        PreparedStatement st = connexion.prepareStatement(query);
        ResultSet rs = st.executeQuery();
       
        Element root = new Element("rootElement");
        
        while (rs.next()) {
            Element simulation = new Element("simulationRealisee");
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) {
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), simulation);
            }
            root.addContent(simulation);
        }
        return root;    //retourne un element xml avec l'ensemble des balise contenant les données de la requete
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
    
     private Element getTauxInteretConcerned() throws SQLException {
        Element eRoot = this.in.getLastDocument().getRootElement();
        int age = Integer.parseInt(eRoot.getChildText("age"));
        double revenu = Double.parseDouble(eRoot.getChildText("revenu"));
        String typeContrat = eRoot.getChildText("typeContrat");
        boolean isClient = (eRoot.getChildText("isClient").equalsIgnoreCase("1")) ? true : false;
        String typeEmprunt = eRoot.getChildText("typeEmprunt");
        
        String query = "SELECT *  FROM matriceTauxFixe  WHERE  ('"+age+"' BETWEEN ageMin and ageMax)  AND ('"+revenu+"' BETWEEN revenuMin AND revenuMax)   AND (typeContrat = '"+typeContrat+"')  AND idTypePret in (SELECT id_type_pret FROM type_pret where libelle = '"+typeEmprunt+"')     AND isClient = "+isClient+";";
        ResultSet rs = connexion.createStatement().executeQuery(query);

        Element root = new Element("rootElement");
        
        
        while (rs.next()) {
            ResultSetMetaData columns = rs.getMetaData();
            for (int i = 1; i <= columns.getColumnCount(); i++) 
                createChildElement(rs, columns.getColumnName(i), columns.getColumnName(i), root);
            System.out.println(rs.getString("ageMin")+".....");
        }
        System.out.println(new XMLOutputter().outputString(root));
        return root;
    }

     
      private Element getLoanNumbers(Element element) throws SQLException {
      int ageDebut = 0,ageFin = 0;
      String typeTaux = null;
      int nbtranche = Integer.parseInt(element.getChildText("Tranche"));
       
      
     if(element.getChild("TypePretImmo").getValue().equals("1") && !element.getChild("TypePretConso").getValue().equals("1") )
          typeTaux = "_Credit_IMMO_";
       else if(element.getChild("TypePretConso").getValue().equals("1") && !element.getChild("TypePretImmo").getValue().equals("1"))
           typeTaux = "_CREDIT_CONSO_";
      
      if(nbtranche == 0)
      {   ageDebut=18;ageFin=25; }
          else if(nbtranche == 1)    
          {  ageDebut=26;ageFin=40; }
          else if(nbtranche == 2)
          {  ageDebut=41;ageFin=65; }
          else if(nbtranche == 3)
          { ageDebut=66;ageFin=200; }
          
        String query = "SELECT COUNT(*) as LoanNumbers from vue_indicateur3 "+
"WHERE "+
"YEAR(dateDebut) = 2016 " +
"AND Age BETWEEN ? AND ? "+
"AND libelle = ? "+
"AND id_agence = 1 ";
        
    String query2 = "SELECT COUNT(*) as LoanNumbers from vue_indicateur3 "+
"WHERE "+
"YEAR(dateDebut) = 2016 " +
"AND Age BETWEEN ? AND ? "+
"AND id_agence = 1 ";     
    
    
PreparedStatement st;

 if(typeTaux != null){
     st = connexion.prepareStatement(query);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
        st.setString(3, typeTaux); }
 else {
        st = connexion.prepareStatement(query2);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
 }
 
        
         Element root = new Element("rootElement");
         Element eloanNumbers = new Element("loanNumbers");
          
            for(int i=1;i<=12;i++){
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int j = 1; j <= columns.getColumnCount(); j++) {
                    createChildElement(rs,columns.getColumnName(j), "month"+i, eloanNumbers);
                    }

            
        }
       
      
    }
        root.addContent(eloanNumbers);
        return root;
    }

    private Element getSimNumbers(Element element) throws SQLException {
      
        
     int ageDebut = 0,ageFin = 0;
      String typeTaux = null;
      int nbtranche = Integer.parseInt(element.getChildText("Tranche"));
      
      
      if(element.getChild("TypePretImmo").getValue().equals("1") && !element.getChild("TypePretConso").getValue().equals("1") )
          typeTaux = "_Credit_IMMO_";
       else if(element.getChild("TypePretConso").getValue().equals("1") && !element.getChild("TypePretImmo").getValue().equals("1"))
           typeTaux = "_CREDIT_CONSO_";
      
      if(nbtranche == 0)
      {   ageDebut=18;ageFin=25; }
          else if(nbtranche == 1)    
          {  ageDebut=26;ageFin=40; }
          else if(nbtranche == 2)
          {  ageDebut=41;ageFin=65; }
          else if(nbtranche == 3)
          { ageDebut=66;ageFin=200; }   

      
 String query = "SELECT COUNT(*) from simul_pret sp,client c"
+"WHERE "
+"YEAR(dateSimulation) = 2016 "
+"AND id_agence = 1 "
+"AND (YEAR(CURRENT_DATE) - YEAR(dateNaissance))"
+"BETWEEN ? AND ? "
+"AND sp.id_type_pret = (SELECT id_type_pret from type_pret where libelle = ?) "
+"AND sp.id_client = c.id_client";
 
 String query2 = "SELECT COUNT(*) from simul_pret sp,client c"
+"WHERE "
+"YEAR(dateSimulation) = 2016 "
+"AND id_agence = 1 "
+"AND (YEAR(CURRENT_DATE) - YEAR(dateNaissance))"
+"BETWEEN ? AND ? "
+"AND sp.id_client = c.id_client";

   
 PreparedStatement st;
 if(typeTaux != null ){
     st = connexion.prepareStatement(query);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
        st.setString(3, typeTaux); }
 else {
        st = connexion.prepareStatement(query2);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
 }

        
        
        
        Element root = new Element("rootElement");
         Element esimNumbers = new Element("simNumbers");
          
            for(int i=1;i<=12;i++){
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int j = 1; j <= columns.getColumnCount(); j++) {
                    createChildElement(rs,columns.getColumnName(j), "month"+i, esimNumbers);
                    }

            
        }
       
      
    }
            
              root.addContent(esimNumbers);
              return root;
    }
 
    private Element getAgebyLoan(Element element) throws SQLException {
          
  String checkImmo = element.getChild("TypePretImmo").getValue();
  String checkConso = element.getChild("TypePretConso").getValue();
 int tabtranche[] = {18,25,26,40,41,65,66,200};         

String query = "SELECT COUNT(*) as LoanNumbers from vue_indicateur3 "+
"WHERE "+
"YEAR(dateDebut) = 2016 " +
"AND Age BETWEEN ? AND ? "+
"AND libelle = ? "+
"AND id_agence = 1 ";
        
String query2 = "SELECT COUNT(*) as LoanNumbers from vue_indicateur3 "+
"WHERE "+
"YEAR(dateDebut) = 2016 " +
"AND Age BETWEEN ? AND ? "+
"AND id_agence = 1 ";
       
        
        if(checkImmo.equals("1") && checkConso.equals("1")){
            PreparedStatement st = connexion.prepareStatement(query2);
            Element root = new Element("rootElement");
            Element resultat = new Element("resultat");
            for(int j=0;j<tabtranche.length;j=j+2){
                st.setInt(1,tabtranche[j]);
                st.setInt(2,tabtranche[j+1]);
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int i = 1; i <= columns.getColumnCount(); i++) {
                    createChildElement(rs,columns.getColumnName(i), "tranche"+j, resultat);
                    }
          
    }
            }
                  root.addContent(resultat);
        return root;
        }
        
       else   if(checkImmo.equals("1") && checkConso.equals("0")){
                       PreparedStatement st = connexion.prepareStatement(query);
            Element root = new Element("rootElement");
            Element resultat = new Element("resultat");
            for(int j=0;j<tabtranche.length;j=j+2){
                st.setInt(1,tabtranche[j]);
                st.setInt(2,tabtranche[j+1]);
                st.setString(3, "_Credit_IMMO_");
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int i = 1; i <= columns.getColumnCount(); i++) {
                    createChildElement(rs,columns.getColumnName(i), "tranche"+j, resultat);
                    }
          
    }
            }
                  root.addContent(resultat);
        return root;
        }
        
       else   if(checkImmo.equals("0") && checkConso.equals("1")){
           System.out.println("check conso");
           PreparedStatement st = connexion.prepareStatement(query);
            Element root = new Element("rootElement");
            Element resultat = new Element("resultat");
            for(int j=0;j<tabtranche.length;j=j+2){
                st.setInt(1,tabtranche[j]);
                st.setInt(2,tabtranche[j+1]);
                st.setString(3,"_CREDIT_CONSO_");
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int i = 1; i <= columns.getColumnCount(); i++) {
                    createChildElement(rs,columns.getColumnName(i), "tranche"+j, resultat);
                    }
          
    }
            }
                  root.addContent(resultat);
        return root;
        }
        return null;
    
    } 
    
   
     private Element getAvgAmount(Element element) throws SQLException {
    
      
         
         String checkImmo = element.getChild("TypePretImmo").getValue();
  String checkConso = element.getChild("TypePretConso").getValue();

   int ageDebut = 0,ageFin = 0;
      String typeTaux = null;
      int nbtranche = Integer.parseInt(element.getChildText("Tranche"));
       
      
     if(checkImmo.equals("1") && !checkConso.equals("1") )
          typeTaux = "_Credit_IMMO_";
       else if(checkImmo.equals("1") && !checkConso.equals("1"))
           typeTaux = "_CREDIT_CONSO_";
  
  if(nbtranche == 0)
      {   ageDebut=18;ageFin=25; }
          else if(nbtranche == 1)    
          {  ageDebut=26;ageFin=40; }
          else if(nbtranche == 2)
          {  ageDebut=41;ageFin=65; }
          else if(nbtranche == 3)
          { ageDebut=66;ageFin=200; } 
         
   
        String query = "SELECT AVG(mt_pret) from vue_indicateur3"+
"WHERE"+
"YEAR(dateDebut) = 2016 "+
"AND Age BETWEEN ? AND ?"+
"AND libelle = ?"+
"AND id_agence = 1";
         
 String query2 = "SELECT AVG(mt_pret) from vue_indicateur3"+
"WHERE"+
"YEAR(dateDebut) = 2016 "+
"AND Age BETWEEN ? AND ?"+
"AND id_agence = 1";       
        
  PreparedStatement st;

 if(typeTaux != null){
     st = connexion.prepareStatement(query);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
        st.setString(3, typeTaux); }
 else {
        st = connexion.prepareStatement(query2);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
 }      
 
  Element root = new Element("rootElement");
         Element eavgAmount= new Element("eavgAmount");
          
            for(int i=1;i<=12;i++){
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int j = 1; j <= columns.getColumnCount(); j++) {
                    createChildElement(rs,columns.getColumnName(j), "month"+i, eavgAmount);
                    }

            
        }
       
      
    }
            
              root.addContent(eavgAmount);
              return root;
 
        
     }
         
         
         
     
     
     private Element getLoanTime(Element element) throws SQLException {
    
         String checkImmo = element.getChild("TypePretImmo").getValue();
  String checkConso = element.getChild("TypePretConso").getValue();

   int ageDebut = 0,ageFin = 0;
      String typeTaux = null;
      int nbtranche = Integer.parseInt(element.getChildText("Tranche"));
       
      
     if(element.getChild("TypePretImmo").getValue().equals("1") && !element.getChild("TypePretConso").getValue().equals("1") )
          typeTaux = "_Credit_IMMO_";
       else if(element.getChild("TypePretConso").getValue().equals("1") && !element.getChild("TypePretImmo").getValue().equals("1"))
           typeTaux = "_CREDIT_CONSO_";
  
  if(nbtranche == 0)
      {   ageDebut=18;ageFin=25; }
          else if(nbtranche == 1)    
          {  ageDebut=26;ageFin=40; }
          else if(nbtranche == 2)
          {  ageDebut=41;ageFin=65; }
          else if(nbtranche == 3)
          { ageDebut=66;ageFin=200; } 
         
   
        String query = "SELECT AVG(duree) from vue_indicateur3"+
"WHERE"+
"YEAR(dateDebut) = 2016 "+
"AND Age BETWEEN ? AND ?"+
"AND libelle = ?"+
"AND id_agence = 1";
         
 String query2 = "SELECT AVG(duree) from vue_indicateur3"+
"WHERE"+
"YEAR(dateDebut) = 2016 "+
"AND Age BETWEEN ? AND ?"+
"AND id_agence = 1";       
        
  PreparedStatement st;

 if(typeTaux != null){
     st = connexion.prepareStatement(query);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
        st.setString(3, typeTaux); }
 else {
        st = connexion.prepareStatement(query2);
        st.setInt(1, ageDebut);
        st.setInt(2, ageFin);
 }      
 
  Element root = new Element("rootElement");
         Element eloanTime = new Element("loanTime");
          
            for(int i=1;i<=12;i++){
                ResultSet rs = st.executeQuery();
                while (rs.next()) {
            
                ResultSetMetaData columns = rs.getMetaData();
                    for (int j = 1; j <= columns.getColumnCount(); j++) {
                    createChildElement(rs,columns.getColumnName(j), "month"+i, eloanTime);
                    }

            
        }
       
      
    }
            
              root.addContent(eloanTime);
              return root;
 
        
     }
     
}
