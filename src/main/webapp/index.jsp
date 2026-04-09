<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>MI Inspection Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container-fluid py-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="fw-bold"><i class="fa-solid fa-vial-circle-check me-2"></i>MI 검사 현황</h3>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#writeModal"><i class="fa-solid fa-plus"></i> 신규 등록</button>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-body">
            <div class="row g-2 align-items-end">
                <div class="col-md-2"><label class="form-label">시작일</label><input id="startDate" type="date" class="form-control"></div>
                <div class="col-md-2"><label class="form-label">종료일</label><input id="endDate" type="date" class="form-control"></div>
                <div class="col-md-3"><label class="form-label">LOT</label><input id="lotKeyword" type="text" class="form-control" placeholder="LOT 검색"></div>
                <div class="col-md-5">
                    <label class="form-label d-block">항목 표시</label>
                    <div class="btn-group" role="group">
                        <input class="btn-check" type="radio" name="columnFilter" id="fAll" value="all" checked><label class="btn btn-outline-secondary" for="fAll">전체</label>
                        <input class="btn-check" type="radio" name="columnFilter" id="fBa" value="ba"><label class="btn btn-outline-secondary" for="fBa">붕산</label>
                        <input class="btn-check" type="radio" name="columnFilter" id="fPs" value="ps"><label class="btn btn-outline-secondary" for="fPs">필력</label>
                        <input class="btn-check" type="radio" name="columnFilter" id="fCs" value="cs"><label class="btn btn-outline-secondary" for="fCs">응집</label>
                    </div>
                </div>
            </div>
            <div class="mt-3 d-flex gap-2">
                <button class="btn btn-dark" id="searchBtn"><i class="fa-solid fa-magnifying-glass"></i> 검색</button>
                <button class="btn btn-success" id="excelBtn"><i class="fa-solid fa-file-excel"></i> Excel 다운로드</button>
            </div>
        </div>
    </div>

    <div class="card shadow-sm mb-3">
        <div class="card-header bg-white fw-bold">LOT별 추이 차트</div>
        <div class="card-body"><canvas id="trendChart" height="80"></canvas></div>
    </div>

    <div class="card shadow-sm">
        <div class="card-body table-responsive">
            <table class="table table-bordered table-hover align-middle text-center" id="inspectionTable">
                <thead class="table-light">
                <tr>
                    <th>LOT</th>
                    <th class="ba-col">BA1</th><th class="ba-col">BA2</th><th class="ba-col">BA3</th><th class="ba-col">BA4</th><th class="ba-col">BA5</th>
                    <th class="ps-col">PS1</th><th class="ps-col">PS2</th><th class="ps-col">PS3</th><th class="ps-col">PS4</th><th class="ps-col">PS5</th>
                    <th class="cs-col">CS1</th><th class="cs-col">CS2</th><th class="cs-col">CS3</th><th class="cs-col">CS4</th><th class="cs-col">CS5</th>
                    <th>비고</th><th>작성자</th><th>일시</th><th>수정</th>
                </tr>
                </thead>
                <tbody id="tableBody"></tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal fade" id="writeModal" tabindex="-1"><div class="modal-dialog modal-xl"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title">신규 등록</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
    <div class="modal-body"><form id="writeForm"></form></div>
    <div class="modal-footer"><button class="btn btn-primary" id="saveBtn">저장</button></div>
</div></div></div>

<div class="modal fade" id="editModal" tabindex="-1"><div class="modal-dialog modal-xl"><div class="modal-content">
    <div class="modal-header"><h5 class="modal-title">수정</h5><button class="btn-close" data-bs-dismiss="modal"></button></div>
    <div class="modal-body"><form id="editForm"></form></div>
    <div class="modal-footer"><button class="btn btn-warning" id="updateBtn">수정 저장</button></div>
</div></div></div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
<script src="assets/js/app.js"></script>
</body>
</html>
