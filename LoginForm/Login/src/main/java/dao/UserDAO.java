package dao;

import model.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import utils.DBConnection;

public class UserDAO {
    public boolean validateUser(User user) {
        String query = "SELECT * FROM users WHERE user_id = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            ResultSet rs = stmt.executeQuery();
            return rs.next(); // 결과가 있으면 true 반환
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
