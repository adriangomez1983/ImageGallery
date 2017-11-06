package com.imageupload.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.io.Serializable;
import java.sql.Timestamp;
import java.time.Instant;
import java.util.UUID;

@Entity
@Table(name = "image")
public class Image implements Serializable {
    @Id
    private UUID id;
    private String url;
    private String displayName;
    private Timestamp createdAt;
    private String description;
    private Boolean favorite;
    private Boolean main;
    private byte[] data;

    public Image() {
        this.id = UUID.randomUUID();
        this.url = "";
        this.displayName = "";
        this.createdAt = Timestamp.from(Instant.now());
        this.description = "";
        this.favorite = false;
        this.main = false;
        this.data = new byte[] {};
    }

    @Column(name = "id")
    public UUID getId() {
        return this.id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getUrl() {
        return this.url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getDisplayName() {
        return this.displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }

    public Timestamp getCreatedAt() {
        return this.createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getDescription() {
        return this.description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getFavorite() {
        return favorite;
    }

    public void setFavorite(Boolean favorite) {
        this.favorite = favorite;
    }

    public Boolean getMain() {
        return main;
    }

    public void setMain(Boolean main) {
        this.main = main;
    }

    public byte[] getData() {
        return this.data;
    }

    public void setData(byte[] data) {
        this.data = data;
    }

    @Override
    public String toString() {
        return "IMAGE: ID: "+id.toString();
    }
}
