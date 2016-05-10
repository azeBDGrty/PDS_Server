/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package Database;

import com.pds.database.Database;
import java.sql.Connection;
import java.sql.Statement;
import org.junit.After;
import org.junit.AfterClass;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import static org.junit.Assert.*;

/**
 *
 * @author zouhairhajji
 */
public class DatabaseTest {
    
    
    @Test
    public void testGetConnexion() throws Exception {
        try{
            assertTrue(Database.getConnexion() != null);
        }catch(Exception ex){
            fail("Une exception est declanchée");
        }
    }

    
    
}
