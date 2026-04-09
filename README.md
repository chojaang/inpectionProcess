# MI Inspection (JSP/Tomcat)

## 구성
- Server: Apache Tomcat
- Language: JSP + Java (Maven 미사용)
- DB: MySQL (`Master_Mi_Inspection`)
- Frontend: Bootstrap 5, Chart.js, FontAwesome

## 배포 방법
1. 프로젝트를 Tomcat webapps 경로에 배치
2. MySQL JDBC 드라이버(`mysql-connector-j`)를 Tomcat `lib/`에 복사
3. `schema.sql` 실행
4. `src/main/webapp/WEB-INF/classes/com/inspection/util/DBConnection.java`의 접속 정보 수정

## 주요 기능
- 날짜/LOT 검색
- 컬럼 동적 표시(전체/붕산/필력/응집)
- 신규/수정(LOT readonly)
- 상태 강조(BA>=5, PS>=10, CS 상태별 색상)
- 필터 결과 Excel(.xlsx) 다운로드
- LOT별 BA1/PS1 추이 차트
