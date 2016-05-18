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
public enum Send {
    
    connectionRefused(""),
    connectionAutorised(""),
    connectionDone("La connection est déjà rétablie"),
    undefinedRequest (""),
    
    sendInformationClient ("Envoyer les informations qui concerne le client(qui est connecté)"),
    
    sendAllClient("envoyer toutes les informations qui concernent les clients"),
    needRight ("Manque de droits"),
    
    sendAllDepartement ("La liste des departements"),
    sendAllRegion ("La liste des regions"),
    sendAllPays ("La liste des pays"),
    
    
    sendSimulationPretsClient("La liste des simulations de prets.");
            
    private String abv;

    private Send(String abv) {
        this.abv = abv;
    }

    public String getAbv() {
        return abv;
    }
    
    
}
