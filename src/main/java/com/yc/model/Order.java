
package com.yc.model;

import java.math.BigDecimal;

public class Order {
    private int orderId;
    private int userId;
    private int addressId;
    private Integer handledBy;
    private BigDecimal totalAmount;
    private String status;
    private String paymentMethod;
    private String paymentStatus;

    public Order() {}

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
}

