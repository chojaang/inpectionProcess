package com.inspection.dto;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class MiInspectionDTO {
    private String prodLot;

    private BigDecimal ba1;
    private BigDecimal ba2;
    private BigDecimal ba3;
    private BigDecimal ba4;
    private BigDecimal ba5;

    private BigDecimal ps1;
    private BigDecimal ps2;
    private BigDecimal ps3;
    private BigDecimal ps4;
    private BigDecimal ps5;

    private String cs1;
    private String cs2;
    private String cs3;
    private String cs4;
    private String cs5;

    private String remarks;
    private String userName;
    private Timestamp date;

    public String getProdLot() { return prodLot; }
    public void setProdLot(String prodLot) { this.prodLot = prodLot; }

    public BigDecimal getBa1() { return ba1; }
    public void setBa1(BigDecimal ba1) { this.ba1 = ba1; }
    public BigDecimal getBa2() { return ba2; }
    public void setBa2(BigDecimal ba2) { this.ba2 = ba2; }
    public BigDecimal getBa3() { return ba3; }
    public void setBa3(BigDecimal ba3) { this.ba3 = ba3; }
    public BigDecimal getBa4() { return ba4; }
    public void setBa4(BigDecimal ba4) { this.ba4 = ba4; }
    public BigDecimal getBa5() { return ba5; }
    public void setBa5(BigDecimal ba5) { this.ba5 = ba5; }

    public BigDecimal getPs1() { return ps1; }
    public void setPs1(BigDecimal ps1) { this.ps1 = ps1; }
    public BigDecimal getPs2() { return ps2; }
    public void setPs2(BigDecimal ps2) { this.ps2 = ps2; }
    public BigDecimal getPs3() { return ps3; }
    public void setPs3(BigDecimal ps3) { this.ps3 = ps3; }
    public BigDecimal getPs4() { return ps4; }
    public void setPs4(BigDecimal ps4) { this.ps4 = ps4; }
    public BigDecimal getPs5() { return ps5; }
    public void setPs5(BigDecimal ps5) { this.ps5 = ps5; }

    public String getCs1() { return cs1; }
    public void setCs1(String cs1) { this.cs1 = cs1; }
    public String getCs2() { return cs2; }
    public void setCs2(String cs2) { this.cs2 = cs2; }
    public String getCs3() { return cs3; }
    public void setCs3(String cs3) { this.cs3 = cs3; }
    public String getCs4() { return cs4; }
    public void setCs4(String cs4) { this.cs4 = cs4; }
    public String getCs5() { return cs5; }
    public void setCs5(String cs5) { this.cs5 = cs5; }

    public String getRemarks() { return remarks; }
    public void setRemarks(String remarks) { this.remarks = remarks; }
    public String getUserName() { return userName; }
    public void setUserName(String userName) { this.userName = userName; }
    public Timestamp getDate() { return date; }
    public void setDate(Timestamp date) { this.date = date; }
}
