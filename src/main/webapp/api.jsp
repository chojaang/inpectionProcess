<%@ page import="com.inspection.dao.MiInspectionDAO" %>
<%@ page import="com.inspection.dto.MiInspectionDTO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipOutputStream" %>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%!
    private String nvl(String s){ return s == null ? "" : s; }
    private BigDecimal parseDecimal(String v){
        if (v == null || v.trim().isEmpty()) return null;
        try { return new BigDecimal(v.trim()); } catch(Exception e){ return null; }
    }
    private String esc(String s){
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    }
    private String escXml(String s){
        if (s == null) return "";
        return s.replace("&","&amp;").replace("<","&lt;").replace(">","&gt;").replace("\"", "&quot;").replace("'", "&apos;");
    }
    private String asJson(List<MiInspectionDTO> rows){
        StringBuilder sb = new StringBuilder();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        sb.append("{\"rows\":[");
        for(int i=0;i<rows.size();i++){
            MiInspectionDTO d = rows.get(i);
            if(i>0) sb.append(',');
            sb.append("{");
            sb.append("\"prod_lot\":\"").append(esc(d.getProdLot())).append("\",");
            sb.append("\"ba_1\":").append(d.getBa1()).append(",\"ba_2\":").append(d.getBa2()).append(",\"ba_3\":").append(d.getBa3()).append(",\"ba_4\":").append(d.getBa4()).append(",\"ba_5\":").append(d.getBa5()).append(',');
            sb.append("\"ps_1\":").append(d.getPs1()).append(",\"ps_2\":").append(d.getPs2()).append(",\"ps_3\":").append(d.getPs3()).append(",\"ps_4\":").append(d.getPs4()).append(",\"ps_5\":").append(d.getPs5()).append(',');
            sb.append("\"cs_1\":\"").append(esc(d.getCs1())).append("\",\"cs_2\":\"").append(esc(d.getCs2())).append("\",\"cs_3\":\"").append(esc(d.getCs3())).append("\",\"cs_4\":\"").append(esc(d.getCs4())).append("\",\"cs_5\":\"").append(esc(d.getCs5())).append("\",");
            sb.append("\"remarks\":\"").append(esc(d.getRemarks())).append("\",");
            sb.append("\"user_name\":\"").append(esc(d.getUserName())).append("\",");
            sb.append("\"date\":\"").append(d.getDate()==null?"":sdf.format(d.getDate())).append("\"");
            sb.append("}");
        }
        sb.append("]}");
        return sb.toString();
    }

    private void writeXlsx(javax.servlet.http.HttpServletResponse resp, List<MiInspectionDTO> rows) throws Exception {
        resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        resp.setHeader("Content-Disposition", "attachment; filename=mi_inspection.xlsx");
        ZipOutputStream zos = new ZipOutputStream(resp.getOutputStream());

        String sheetData = "";
        String[] headers = {"LOT","BA1","BA2","BA3","BA4","BA5","PS1","PS2","PS3","PS4","PS5","CS1","CS2","CS3","CS4","CS5","비고","작성자","일시"};
        sheetData += "<row r='1'>";
        for(int i=0;i<headers.length;i++) sheetData += "<c t='inlineStr' r='" + (char)('A'+i) + "1'><is><t>"+escXml(headers[i])+"</t></is></c>";
        sheetData += "</row>";

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        int r = 2;
        for(MiInspectionDTO d: rows){
            String[] vals = {
                d.getProdLot(), String.valueOf(d.getBa1()), String.valueOf(d.getBa2()), String.valueOf(d.getBa3()), String.valueOf(d.getBa4()), String.valueOf(d.getBa5()),
                String.valueOf(d.getPs1()), String.valueOf(d.getPs2()), String.valueOf(d.getPs3()), String.valueOf(d.getPs4()), String.valueOf(d.getPs5()),
                d.getCs1(), d.getCs2(), d.getCs3(), d.getCs4(), d.getCs5(), d.getRemarks(), d.getUserName(), d.getDate()==null?"":sdf.format(d.getDate())
            };
            sheetData += "<row r='"+r+"'>";
            for(int i=0;i<vals.length;i++) sheetData += "<c t='inlineStr' r='" + (char)('A'+i) + r + "'><is><t>"+escXml(vals[i])+"</t></is></c>";
            sheetData += "</row>";
            r++;
        }

        Map<String,String> files = new LinkedHashMap<>();
        files.put("[Content_Types].xml", "<?xml version='1.0' encoding='UTF-8'?><Types xmlns='http://schemas.openxmlformats.org/package/2006/content-types'><Default Extension='rels' ContentType='application/vnd.openxmlformats-package.relationships+xml'/><Default Extension='xml' ContentType='application/xml'/><Override PartName='/xl/workbook.xml' ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml'/><Override PartName='/xl/worksheets/sheet1.xml' ContentType='application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml'/></Types>");
        files.put("_rels/.rels", "<?xml version='1.0' encoding='UTF-8'?><Relationships xmlns='http://schemas.openxmlformats.org/package/2006/relationships'><Relationship Id='rId1' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument' Target='xl/workbook.xml'/></Relationships>");
        files.put("xl/workbook.xml", "<?xml version='1.0' encoding='UTF-8'?><workbook xmlns='http://schemas.openxmlformats.org/spreadsheetml/2006/main' xmlns:r='http://schemas.openxmlformats.org/officeDocument/2006/relationships'><sheets><sheet name='Inspection' sheetId='1' r:id='rId1'/></sheets></workbook>");
        files.put("xl/_rels/workbook.xml.rels", "<?xml version='1.0' encoding='UTF-8'?><Relationships xmlns='http://schemas.openxmlformats.org/package/2006/relationships'><Relationship Id='rId1' Type='http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet' Target='worksheets/sheet1.xml'/></Relationships>");
        files.put("xl/worksheets/sheet1.xml", "<?xml version='1.0' encoding='UTF-8'?><worksheet xmlns='http://schemas.openxmlformats.org/spreadsheetml/2006/main'><sheetData>" + sheetData + "</sheetData></worksheet>");

        for (Map.Entry<String, String> e : files.entrySet()) {
            zos.putNextEntry(new ZipEntry(e.getKey()));
            zos.write(e.getValue().getBytes("UTF-8"));
            zos.closeEntry();
        }
        zos.finish();
        zos.close();
    }
%>
<%
    request.setCharacterEncoding("UTF-8");
    String action = nvl(request.getParameter("action"));
    MiInspectionDAO dao = new MiInspectionDAO();

    try {
        if ("list".equals(action)) {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String lotKeyword = request.getParameter("lotKeyword");
            out.print(asJson(dao.findAll(startDate, endDate, lotKeyword)));
            return;
        }

        if ("export".equals(action)) {
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String lotKeyword = request.getParameter("lotKeyword");
            writeXlsx(response, dao.findAll(startDate, endDate, lotKeyword));
            return;
        }

        if ("insert".equals(action) || "update".equals(action)) {
            String prodLot = nvl(request.getParameter("prod_lot")).trim();
            if (prodLot.isEmpty()) {
                out.print("{\"success\":false,\"message\":\"prod_lot는 필수입니다.\"}");
                return;
            }
            MiInspectionDTO d = new MiInspectionDTO();
            d.setProdLot(prodLot);
            d.setUserName(request.getParameter("user_name"));
            d.setRemarks(request.getParameter("remarks"));

            d.setBa1(parseDecimal(request.getParameter("ba_1"))); d.setBa2(parseDecimal(request.getParameter("ba_2"))); d.setBa3(parseDecimal(request.getParameter("ba_3"))); d.setBa4(parseDecimal(request.getParameter("ba_4"))); d.setBa5(parseDecimal(request.getParameter("ba_5")));
            d.setPs1(parseDecimal(request.getParameter("ps_1"))); d.setPs2(parseDecimal(request.getParameter("ps_2"))); d.setPs3(parseDecimal(request.getParameter("ps_3"))); d.setPs4(parseDecimal(request.getParameter("ps_4"))); d.setPs5(parseDecimal(request.getParameter("ps_5")));
            d.setCs1(nvl(request.getParameter("cs_1"))); d.setCs2(nvl(request.getParameter("cs_2"))); d.setCs3(nvl(request.getParameter("cs_3"))); d.setCs4(nvl(request.getParameter("cs_4"))); d.setCs5(nvl(request.getParameter("cs_5")));

            boolean ok = "insert".equals(action) ? dao.insert(d) : dao.update(d);
            out.print("{\"success\":" + ok + "}");
            return;
        }

        out.print("{\"success\":false,\"message\":\"invalid action\"}");
    } catch(Exception e){
        out.print("{\"success\":false,\"message\":\"" + esc(e.getMessage()) + "\"}");
    }
%>
