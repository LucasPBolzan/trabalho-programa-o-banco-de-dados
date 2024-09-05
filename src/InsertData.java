import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Random;

public class InsertData {

    // Informações de conexão
    private static final String DB_URL = "jdbc:postgresql://localhost:5432/nome-do-banco";
    private static final String USER = "postgres";
    private static final String PASS = "123";

    public static void main(String[] args) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        Random random = new Random();

        try {
            // Conectar ao banco de dados
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            conn.setAutoCommit(false); // Usar transação para melhorar a performance

            // Marcar o início do processo de inserção
            long startTime = System.currentTimeMillis();

            // Inserir dados na tabela CarModels
            String insertCarModelSQL = "INSERT INTO CarModels (brand, model, capacity) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertCarModelSQL);

            for (int i = 1; i <= 100; i++) {
                pstmt.setString(1, "Brand" + i);
                pstmt.setString(2, "Model" + i);
                pstmt.setInt(3, random.nextInt(5) + 2); // Capacidade entre 2 e 7
                pstmt.addBatch();
            }
            pstmt.executeBatch();

            // Inserir dados na tabela Customers
            String insertCustomerSQL = "INSERT INTO Customers (name, phone, email) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertCustomerSQL);

            for (int i = 1; i <= 999900; i++) {
                pstmt.setString(1, "Customer" + i);
                pstmt.setString(2, "555-000" + i);
                pstmt.setString(3, "customer" + i + "@email.com");
                pstmt.addBatch();

                if (i % 10000 == 0) { // Commit a cada 10 mil registros para evitar sobrecarga
                    pstmt.executeBatch();
                    conn.commit();
                }
            }
            pstmt.executeBatch();

            // Inserir dados na tabela Cars
            String insertCarSQL = "INSERT INTO Cars (model_id, year, plate, status) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertCarSQL);

            for (int i = 1; i <= 100; i++) {
                pstmt.setInt(1, random.nextInt(100) + 1); // Modelos entre 1 e 100
                pstmt.setInt(2, random.nextInt(22) + 2000); // Anos entre 2000 e 2022
                pstmt.setString(3, "ABC" + i);
                pstmt.setString(4, "available");
                pstmt.addBatch();
            }
            pstmt.executeBatch();

            // Inserir dados na tabela Reservations
            String insertReservationSQL = "INSERT INTO Reservations (car_id, customer_id, pickup_date, return_date) VALUES (?, ?, ?, ?)";
            pstmt = conn.prepareStatement(insertReservationSQL);

            for (int i = 1; i <= 1000000; i++) {
                pstmt.setInt(1, random.nextInt(100) + 1); // Carros entre 1 e 100
                pstmt.setInt(2, random.nextInt(999900) + 1); // Clientes entre 1 e 999900
                pstmt.setDate(3, java.sql.Date.valueOf("2023-01-01"));
                pstmt.setDate(4, java.sql.Date.valueOf("2023-01-10"));
                pstmt.addBatch();

                if (i % 10000 == 0) {
                    pstmt.executeBatch();
                    conn.commit();
                }
            }
            pstmt.executeBatch();

            // Finalizar a transação
            conn.commit();

            // Marcar o final do processo de inserção
            long endTime = System.currentTimeMillis();

            // Calcular e exibir o tempo total
            long totalTime = endTime - startTime;
            System.out.println("Tempo total para inserir 2 milhões de registros: " + totalTime + " ms");

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
