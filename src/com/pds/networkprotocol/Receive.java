/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.networkprotocol;

/**
 *
 * @author zouhairhajji
 */
public enum Receive {
    
    none (""),
    
    
    askAuthentification (""),
    askAddClient (""),
    askModifyClient (""),
    askDeleteClient (""),
    
    askInformationClient ("Le client demande toute information qui le concerne"),
    askAllClient(""),
    
    /**
     * 
     *  Conseiller 
     */
    
    askAllDepartement ("Demande la liste des departements"),
    askAllPays ("Demande la liste des pays"),
    askAllRegion ("Demande la liste des regions "),
    askSimulationPretsClient ("Demande la liste des simulations des prets"),
    askSimulationClient("demande la liste des sim de pret d'un client def"),
    askIndicatorInfo ("");
    
    private String signification;

    private Receive(String signification) {
        this.signification = signification;
    }

    public String getSignification() {
        return signification;
    }
}
