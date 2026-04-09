const fields = {
  ba: ["ba_1","ba_2","ba_3","ba_4","ba_5"],
  ps: ["ps_1","ps_2","ps_3","ps_4","ps_5"],
  cs: ["cs_1","cs_2","cs_3","cs_4","cs_5"]
};
let chart;

function csLabel(v){ return ({"0":"O","1":"X","2":"약","3":"중"}[String(v)] || "-"); }
function csClass(v){ v=String(v); if(v==="0") return "cs-pass"; if(v==="1") return "cs-fail"; return "cs-warn"; }
function buildForm(formId, isEdit=false){
  const f = document.getElementById(formId);
  let html = `<div class="row g-2"><div class="col-md-3"><label class="form-label">LOT*</label><input name="prod_lot" class="form-control" ${isEdit?"readonly":""} required maxlength="15"></div><div class="col-md-3"><label class="form-label">작성자</label><input name="user_name" class="form-control" maxlength="50"></div><div class="col-md-6"><label class="form-label">비고</label><input name="remarks" class="form-control"></div></div><hr/>`;
  ["ba","ps"].forEach(t=>{
    html += `<div class="row g-2 mb-2">`;
    for(let i=1;i<=5;i++) html += `<div class="col"><label class="form-label text-uppercase">${t}${i}</label><input type="number" step="0.001" name="${t}_${i}" class="form-control"></div>`;
    html += `</div>`;
  });
  html += `<div class="row g-2">`;
  for(let i=1;i<=5;i++){
    html += `<div class="col"><label class="form-label">cs${i}</label><select name="cs_${i}" class="form-select"><option value="0">O</option><option value="1">X</option><option value="2">약</option><option value="3">중</option></select></div>`;
  }
  html += `</div>`;
  f.innerHTML = html;
}

function getFilters(){
  return {
    startDate: document.getElementById("startDate").value,
    endDate: document.getElementById("endDate").value,
    lotKeyword: document.getElementById("lotKeyword").value
  };
}

function showColumns(type){
  ["ba","ps","cs"].forEach(k=>document.querySelectorAll(`.${k}-col`).forEach(el=>el.classList.toggle("d-none", type!=="all"&&type!==k)));
}

function colorNum(v, limit){
  if(v===null || v===undefined || v==='') return '-';
  const n = Number(v);
  return `<span class="${n>=limit?'text-danger fw-bold':''}">${n.toFixed(3)}</span>`;
}

async function fetchData(){
  const q = new URLSearchParams({action:'list', ...getFilters()});
  const res = await fetch(`api.jsp?${q}`);
  const data = await res.json();
  renderTable(data.rows || []);
  renderChart(data.rows || []);
}

function renderTable(rows){
  const body = document.getElementById('tableBody');
  body.innerHTML = rows.map(r=>`<tr>
    <td>${r.prod_lot}</td>
    ${fields.ba.map(k=>`<td class="ba-col">${colorNum(r[k],5)}</td>`).join('')}
    ${fields.ps.map(k=>`<td class="ps-col">${colorNum(r[k],10)}</td>`).join('')}
    ${fields.cs.map(k=>`<td class="cs-col"><span class="badge ${csClass(r[k])}">${csLabel(r[k])}</span></td>`).join('')}
    <td>${r.remarks||''}</td><td>${r.user_name||''}</td><td>${r.date||''}</td>
    <td><button class="btn btn-sm btn-outline-primary" onclick='openEdit(${JSON.stringify(r).replace(/'/g,"&#39;")})'><i class="fa-solid fa-pen"></i></button></td>
  </tr>`).join('');
}

function renderChart(rows){
  const labels = rows.slice().reverse().map(x=>x.prod_lot);
  const ba = rows.slice().reverse().map(x=>x.ba_1 || null);
  const ps = rows.slice().reverse().map(x=>x.ps_1 || null);
  if(chart) chart.destroy();
  chart = new Chart(document.getElementById('trendChart'), {
    type:'line',
    data:{labels,datasets:[{label:'BA1',data:ba,borderColor:'#0d6efd'},{label:'PS1',data:ps,borderColor:'#198754'}]},
    options:{responsive:true,maintainAspectRatio:false}
  });
}

function formData(formId){
  const obj={};
  new FormData(document.getElementById(formId)).forEach((v,k)=>obj[k]=v);
  return obj;
}

async function save(isUpdate=false){
  const id = isUpdate?'editForm':'writeForm';
  const payload = formData(id);
  if(!payload.prod_lot){ alert('prod_lot는 필수입니다.'); return; }
  const body = new URLSearchParams({action:isUpdate?'update':'insert', ...payload});
  const res = await fetch('api.jsp', {method:'POST', headers:{'Content-Type':'application/x-www-form-urlencoded;charset=UTF-8'}, body});
  const data = await res.json();
  if(!data.success){ alert(data.message||'저장 실패'); return; }
  bootstrap.Modal.getInstance(document.getElementById(isUpdate?'editModal':'writeModal')).hide();
  fetchData();
}

function openEdit(row){
  const form = document.getElementById('editForm');
  Object.keys(row).forEach(k=>{ const el=form.querySelector(`[name='${k}']`); if(el) el.value = row[k] ?? ''; });
  new bootstrap.Modal(document.getElementById('editModal')).show();
}

buildForm('writeForm',false);
buildForm('editForm',true);
document.getElementById('searchBtn').addEventListener('click', fetchData);
document.getElementById('saveBtn').addEventListener('click', ()=>save(false));
document.getElementById('updateBtn').addEventListener('click', ()=>save(true));
document.querySelectorAll("input[name='columnFilter']").forEach(r=>r.addEventListener('change',e=>showColumns(e.target.value)));
document.getElementById('excelBtn').addEventListener('click', ()=>{
  const q = new URLSearchParams({action:'export', ...getFilters()});
  location.href = `api.jsp?${q}`;
});
showColumns('all');
fetchData();
