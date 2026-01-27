
package com.yc.model;
import java.sql.Timestamp;

public class Cart {
    private int cartId;
    private int userId;
    private Timestamp updated_at;

    public Cart() {}

    public Cart(int cartId, int productId, int quantity) {
        this.cartId = cartId;
        this.userId = userId;
        this.updated_at = updated_at;
    }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public Timestamp getUpdated_at() { return updated_at; }
    public void setUpdated_at(Timestamp updated_at) { this.updated_at = updated_at; }
}

