package com.yc.model;

import java.math.BigDecimal;

public class Product {
    private int productId;
    private int categoryId;
    private int createdBy;
    private int updatedBy;
    private String name;
    private String description;
    private double price;
    private int stockQty;
    private String image;
    private String colors;
    

    public Product() {}

    public Product(int productId, String name, String description,
                   double price, String image) {
        this.productId = productId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.image = image;
    }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }

    public int getUpdatedBy() { return updatedBy; }
    public void setUpdatedBy(int updatedBy) { this.updatedBy = updatedBy; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStockQty() { return stockQty; }
    public void setStockQty(int stockQty) { this.stockQty = stockQty; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
    
    public String getColors(){ return colors; }
    public void setColors(String colors){ this.colors = colors; }

}

