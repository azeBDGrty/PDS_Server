/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pds.server;

import com.pds.customermanager.ClientHandler;
import com.pds.log.Logger;
import java.io.IOException;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;
import java.util.Random;
import java.util.logging.Level;

/**
 *
 * @author zouhairhajji
 */
public class Server implements Runnable {

    private int port;
    private boolean running;
    private Thread T;

    private ServerSocket serverSocket;

    private Logger logger;
    
    private List<ClientHandler> handlers;

    private Queue<Connection> connections;

    public Server() throws IOException {
        this(3000);
    }

    public Server(int port) throws IOException {
        this.port = port;
        this.running = false;
        this.serverSocket = new ServerSocket(port);
        this.logger = new Logger("ServerAppli");
        this.handlers = new ArrayList<>();
        this.connections = new LinkedList<>();
        for(int i = 0; i< 15; i++)
            try{
                this.connections.add(com.pds.database.Database.getConnexion());
            }catch(ClassNotFoundException | SQLException ex){
                System.out.println(logger.warn("Exception detected : "));
                System.out.println(logger.warn(ex.toString()));
                stopAllHandlers();
                System.out.println(logger.warn("Kill of all handlers "));
                System.out.println(logger.warn("shutting down the server"));
                System.exit(0);
            }
            
    }

    
    
    public void startThread() {
        if(this.running)
            return;
        this.running = true;
        this.T = new Thread(this);
        this.T.start();

    }

    public void stopThread() {
        this.running = false;
    }

    public void stopAllHandlers(){
        for(ClientHandler handler : handlers)
            handler.stopThread();
    }
    
    
    @Override
    public void run() {
        Socket clientSocket;
        try {
            System.out.println(logger.info("Server Connected"));
            System.out.println(logger.info("\t Using port : " + this.port));
            System.out.println(logger.info("\t Using IP   : " + InetAddress.getLocalHost().getHostAddress()));
            System.out.println("");
            
            while (running) {
                System.out.println(logger.info("Waiting for new client"));
                clientSocket = this.serverSocket.accept();
                System.out.println(logger.info("New client connected"));
                ClientHandler clientHandler = new ClientHandler(clientSocket, this.logger, connections);
                handlers.add(clientHandler);
                clientHandler.startThread();
            }
            this.serverSocket.close();
            
        } catch (Exception ex) {
            System.out.println(logger.warn("Exception detected : "));
            System.out.println(logger.warn(ex.toString()));
            stopAllHandlers();
            System.out.println(logger.warn("Kill of all handlers "));
            System.out.println(logger.warn("shutting down the server"));
            System.exit(0);
        }
    }

}
