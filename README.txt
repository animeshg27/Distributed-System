How to connect to Oracle on Omega using your PC/laptop

1. Insert your oracle (sqlplus) username and password in the OracleJDBC.java file
   
2. Connect to UTA VPN (Important)
    
3. Compile the OracleJDBC.java using the command

    javac -cp ojdbc8.jar: OracleJDBC.java
                    OR
    javac -cp ojdbc8.jar; OracleJDBC.java
    
4. Execute the OracleJDBC using the command

    A.  Show contents of a relation

        java -cp ojdbc8.jar: OracleJDBC r Fall22_S001_3_REGIONS
                                OR
        java -cp ojdbc8.jar; OracleJDBC r Fall22_S001_3_REGIONS

    B.
        1.  Retailers who generated highest business
            
            java -cp ojdbc8.jar: OracleJDBC b 1 01-JAN-2022 31-DEC-2022
                                        OR
            java -cp ojdbc8.jar; OracleJDBC b 1 01-JAN-2022 31-DEC-2022

            Walmart FC Road         4880
        
        2.  Most sold products within a specific time frame

            java -cp ojdbc8.jar: OracleJDBC b 2 01-JAN-2021 31-DEC-2022
                                        OR
            java -cp ojdbc8.jar; OracleJDBC b 2 01-JAN-2021 31-DEC-2022

            OREAO CREAM BISCUIT     410