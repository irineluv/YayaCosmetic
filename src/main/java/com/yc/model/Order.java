
package com.yc.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Order {
    private int orderId;
    private int userId;
    private int addressId;
    private Integer handledBy;
    private BigDecimal totalAmount;
    private String status;
    private String paymentMethod;
    private String paymentStatus;

    private Timestamp orderDate;
    private Timestamp updatedAt;
    
    // Joined fields for display
    private String customerName;
    private String customerEmail;
    private String addressLine;
    private String city;
    private String state;
    private String postalCode;

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public Integer getHandledBy() { return handledBy; }
    public void setHandledBy(Integer handledBy) { this.handledBy = handledBy; }

    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }

    public Timestamp getOrderDate() { return orderDate; }
    public void setOrderDate(Timestamp orderDate) { this.orderDate = orderDate; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    // Joined field getters/setters
    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getCustomerEmail() { return customerEmail; }
    public void setCustomerEmail(String customerEmail) { this.customerEmail = customerEmail; }

    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String addressLine) { this.addressLine = addressLine; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPostalCode() { return postalCode; }
    public void setPostalCode(String postalCode) { this.postalCode = postalCode; }

    // Helper method for full address
    public String getFullAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressLine != null) sb.append(addressLine);
        if (city != null) sb.append(", ").append(city);
        if (state != null) sb.append(", ").append(state);
        if (postalCode != null) sb.append(" ").append(postalCode);
        return sb.toString();
    }
}

