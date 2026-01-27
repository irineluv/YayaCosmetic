package com.yc.dao;

import com.yc.model.Address;
import com.yc.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAO {

    public List<Address> getAddressesByUserId(int userId) {
        List<Address> addresses = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE userId = ? ORDER BY isDefault DESC, addressId";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Address a = mapResultSetToAddress(rs);
                addresses.add(a);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return addresses;
    }

    public Address getAddressById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE addressId = ?";
        Address address = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                address = mapResultSetToAddress(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return address;
    }

    public Address getDefaultAddress(int userId) {
        String sql = "SELECT * FROM addresses WHERE userId = ? AND isDefault = 1 LIMIT 1";
        Address address = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                address = mapResultSetToAddress(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return address;
    }

    public int addAddress(Address address) {
        String sql = "INSERT INTO addresses (userId, label, addressLine, city, state, postalCode, country, phone, isDefault) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            // If this is set as default, unset other defaults first
            if (address.isDefault()) {
                unsetDefaultAddresses(address.getUserId());
            }

            ps.setInt(1, address.getUserId());
            ps.setString(2, address.getLabel());
            ps.setString(3, address.getAddressLine());
            ps.setString(4, address.getCity());
            ps.setString(5, address.getState());
            ps.setString(6, address.getPostalCode());
            ps.setString(7, address.getCountry());
            ps.setString(8, address.getPhone());
            ps.setBoolean(9, address.isDefault());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean updateAddress(Address address) {
        String sql = "UPDATE addresses SET label = ?, addressLine = ?, city = ?, state = ?, " +
                     "postalCode = ?, country = ?, phone = ?, isDefault = ? WHERE addressId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // If this is set as default, unset other defaults first
            if (address.isDefault()) {
                unsetDefaultAddresses(address.getUserId());
            }

            ps.setString(1, address.getLabel());
            ps.setString(2, address.getAddressLine());
            ps.setString(3, address.getCity());
            ps.setString(4, address.getState());
            ps.setString(5, address.getPostalCode());
            ps.setString(6, address.getCountry());
            ps.setString(7, address.getPhone());
            ps.setBoolean(8, address.isDefault());
            ps.setInt(9, address.getAddressId());

            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteAddress(int addressId) {
        String sql = "DELETE FROM addresses WHERE addressId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, addressId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    private void unsetDefaultAddresses(int userId) {
        String sql = "UPDATE addresses SET isDefault = 0 WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Address mapResultSetToAddress(ResultSet rs) throws SQLException {
        Address a = new Address();
        a.setAddressId(rs.getInt("addressId"));
        a.setUserId(rs.getInt("userId"));
        a.setLabel(rs.getString("label"));
        a.setAddressLine(rs.getString("addressLine"));
        a.setCity(rs.getString("city"));
        a.setState(rs.getString("state"));
        a.setPostalCode(rs.getString("postalCode"));
        a.setCountry(rs.getString("country"));
        a.setPhone(rs.getString("phone"));
        a.setDefault(rs.getBoolean("isDefault"));
        return a;
    }
}
