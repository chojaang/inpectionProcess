package com.inspection.dao;

import com.inspection.dto.MiInspectionDTO;
import com.inspection.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MiInspectionDAO {

    public List<MiInspectionDTO> findAll(String startDate, String endDate, String prodLot) throws SQLException {
        List<MiInspectionDTO> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder(
            "SELECT * FROM Master_Mi_Inspection WHERE 1=1 "
        );

        List<Object> params = new ArrayList<>();

        if (startDate != null && !startDate.isEmpty()) {
            sql.append("AND DATE(`date`) >= ? ");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append("AND DATE(`date`) <= ? ");
            params.add(endDate);
        }
        if (prodLot != null && !prodLot.isEmpty()) {
            sql.append("AND prod_lot LIKE ? ");
            params.add("%" + prodLot + "%");
        }

        sql.append("ORDER BY `date` DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }
        }

        return list;
    }

    public boolean insert(MiInspectionDTO dto) throws SQLException {
        String sql = "INSERT INTO Master_Mi_Inspection ("
            + "prod_lot, ba_1, ba_2, ba_3, ba_4, ba_5, "
            + "ps_1, ps_2, ps_3, ps_4, ps_5, "
            + "cs_1, cs_2, cs_3, cs_4, cs_5, remarks, user_name"
            + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            bindData(ps, dto, false);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean update(MiInspectionDTO dto) throws SQLException {
        String sql = "UPDATE Master_Mi_Inspection SET "
            + "ba_1=?, ba_2=?, ba_3=?, ba_4=?, ba_5=?, "
            + "ps_1=?, ps_2=?, ps_3=?, ps_4=?, ps_5=?, "
            + "cs_1=?, cs_2=?, cs_3=?, cs_4=?, cs_5=?, "
            + "remarks=?, user_name=? WHERE prod_lot=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            bindData(ps, dto, true);
            return ps.executeUpdate() > 0;
        }
    }

    private void bindData(PreparedStatement ps, MiInspectionDTO dto, boolean forUpdate) throws SQLException {
        int idx = 1;
        if (!forUpdate) {
            ps.setString(idx++, dto.getProdLot());
        }
        ps.setBigDecimal(idx++, dto.getBa1());
        ps.setBigDecimal(idx++, dto.getBa2());
        ps.setBigDecimal(idx++, dto.getBa3());
        ps.setBigDecimal(idx++, dto.getBa4());
        ps.setBigDecimal(idx++, dto.getBa5());

        ps.setBigDecimal(idx++, dto.getPs1());
        ps.setBigDecimal(idx++, dto.getPs2());
        ps.setBigDecimal(idx++, dto.getPs3());
        ps.setBigDecimal(idx++, dto.getPs4());
        ps.setBigDecimal(idx++, dto.getPs5());

        ps.setString(idx++, dto.getCs1());
        ps.setString(idx++, dto.getCs2());
        ps.setString(idx++, dto.getCs3());
        ps.setString(idx++, dto.getCs4());
        ps.setString(idx++, dto.getCs5());

        ps.setString(idx++, dto.getRemarks());
        ps.setString(idx++, dto.getUserName());

        if (forUpdate) {
            ps.setString(idx, dto.getProdLot());
        }
    }

    private MiInspectionDTO mapRow(ResultSet rs) throws SQLException {
        MiInspectionDTO dto = new MiInspectionDTO();
        dto.setProdLot(rs.getString("prod_lot"));

        dto.setBa1(rs.getBigDecimal("ba_1"));
        dto.setBa2(rs.getBigDecimal("ba_2"));
        dto.setBa3(rs.getBigDecimal("ba_3"));
        dto.setBa4(rs.getBigDecimal("ba_4"));
        dto.setBa5(rs.getBigDecimal("ba_5"));

        dto.setPs1(rs.getBigDecimal("ps_1"));
        dto.setPs2(rs.getBigDecimal("ps_2"));
        dto.setPs3(rs.getBigDecimal("ps_3"));
        dto.setPs4(rs.getBigDecimal("ps_4"));
        dto.setPs5(rs.getBigDecimal("ps_5"));

        dto.setCs1(rs.getString("cs_1"));
        dto.setCs2(rs.getString("cs_2"));
        dto.setCs3(rs.getString("cs_3"));
        dto.setCs4(rs.getString("cs_4"));
        dto.setCs5(rs.getString("cs_5"));

        dto.setRemarks(rs.getString("remarks"));
        dto.setUserName(rs.getString("user_name"));
        dto.setDate(rs.getTimestamp("date"));
        return dto;
    }
}
