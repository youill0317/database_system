## 1. 프로젝트 개요 및 목표

본 프로젝트는 교수자가 제공하는 인사관리(HR) 데이터셋을 활용하여, 기업 인사 데이터를 분석하고 실제 데이터베이스 시스템을 구축하는 경험을 제공하는 것을 목표로 합니다. 학생들은 이 과정을 통해 관계형 데이터베이스(MySQL)에 테이블을 생성하고 데이터를 적재하며, 다양한 SQL 질의를 통해 의미 있는 정보를 추출하고 분석하는 능력을 배양하게 됩니다.

- **주요 목표**:
	- 제공된 인사 관리 관련 테이블 구조를 이해한다.
	- 사원, 부서, 직무, 위치, 국가, 지역 등의 정보를 효율적으로 관리할 수 있는 관계형 데이터베이스 스키마를 구축한다.
	- 제공된 DML 스크립트로 MySQL 데이터베이스에 데이터를 적재한다.
	- 다양한 SQL 질의(SELECT, JOIN, 집계함수, 서브쿼리 등)를 작성하여 인사 데이터를 분석하고, 요구된 정보를 추출한다.
	- 데이터베이스 시스템 강의에서 배운 DDL, DML, 제약조건, SQL 쿼리 작성 및 데이터 처리 기술을 종합적으로 활용한다.

## 2. 사용 데이터셋 (교수자 제공)

#### 테이블 구조

1. **`regions`**: *기업이 활동하는 전 세계 주요 지역 정보*
	- `region_id` (INT; UNSIGNED; NOT NULL): 지역 ID (기본 키)
	- `region_name` (VARCHAR(25)): 지역 이름

2. **`countries`**: *회사가 사업을 운영하는 국가 정보*
	- `country_id` (CHAR(2); NOT NULL): 국가 ID (기본 키)
	- `country_name` (VARCHAR(40)): 국가 이름
	- `region_id` (INT; UNSIGNED; NOT NULL): 지역 ID (외래 키, `regions.region_id` 참조)

3. **`locations`**: *회사의 사무실과 부서가 위치한 정확한 주소 정보*
	- `location_id` (INT; UNSIGNED; NOT NULL; AUTO_INCREMENT): 위치 ID (기본 키)
	- `street_address` (VARCHAR(40)): 도로명 주소
	- `postal_code` (VARCHAR(12)): 우편번호
	- `city` (VARCHAR(30); NOT NULL): 도시 
	- `state_province` (VARCHAR(25)): 주/도
	- `country_id` (CHAR(2); NOT NULL): 국가 ID (외래 키, `countries.country_id` 참조)
	  
4. **`departments`**: *회사 내 모든 부서 정보*
	- `department_id` (INT; UNSIGNED; NOT NULL): 부서 ID (기본 키)
	- `department_name` (VARCHAR(30); NOT NULL): 부서명
	- `manager_id` (INT; UNSIGNED): 부서장 ID (외래 키, `employees.employee_id` 참조)
	- `location_id` (INT; UNSIGNED): 위치 ID (외래 키, `locations.location_id` 참조)
	  
5. **`jobs`**: *회사 내 모든 직무 정보*
	- `job_id` (VARCHAR(10); NOT NULL): 직무 ID (기본 키)
	- `job_title` (VARCHAR(35); NOT NULL): 직무명
	- `min_salary` (DECIMAL(8,0); UNSIGNED): 최소 급여
	- `max_salary` (DECIMAL(8,0); UNSIGNED): 최대 급여

6. **`employees`**: *모든 사원의 기본 정보*
	- `employee_id` (INT; UNSIGNED; NOT NULL): 사원 ID (기본 키)
	- `first_name` (VARCHAR(20)): 이름
	- `last_name` (VARCHAR(25); NOT NULL): 성
	- `email` (VARCHAR(25); NOT NULL): 이메일
	- `phone_number` (VARCHAR(20)): 전화번호
	- `hire_date` (DATE; NOT NULL): 입사일
	- `job_id` (VARCHAR(10); NOT NULL): 직무 ID (외래 키, `jobs.job_id` 참조)
	- `salary` (DECIMAL(8,2); NOT NULL): 급여
	- `commission_pct` (DECIMAL(2,2)): 커미션 비율
	- `manager_id` (INT; UNSIGNED): 관리자 ID (외래 키, `employees.employee_id` 참조)
	- `department_id` (INT; UNSIGNED): 부서 ID (외래 키, `departments.department_id` 참조)

7. **`job_history`**: *사원들의 과거 직무 이력 정보*
	- `employee_id` (INT; UNSIGNED; NOT NULL): 사원 ID (외래 키, `employees.employee_id` 참조)
	- `start_date` (DATE; NOT NULL): 시작일
	- `end_date` (DATE; NOT NULL): 종료일
	- `job_id` (VARCHAR(10); NOT NULL): 직무 ID (외래 키, `jobs.job_id` 참조)
	- `department_id` (INT; UNSIGNED; NOT NULL): 부서 ID (외래 키, `departments.department_id` 참조)
	  > 💡(`employee_id`, `start_date`)에 UNIQUE 제약조건 필수

8. **`job_grades`**: *급여 범위에 따른 등급 정보*
	- `grade_level` (CHAR(1)): 등급 (기본 키)
	- `lowest_sal` (INT; NOT NULL): 최소 급여
	- `highest_sal` (INT; NOT NULL): 최대 급여


## 3. 요구사항

### 3.1 외래 키 의존성 이해 및 분석

- **의존성 및 순서 참고**: 아래 테이블 생성 순서와 외래 키 참조 관계를 참고하여 DDL을 작성하시오.
	- **테이블 생성 순서**:
		- 1. `regions` - 외래 키 참조 없음
		- 2. `countries` - `regions` 테이블 참조
		- 3. `locations` - `countries` 테이블 참조
		- 4. `jobs` - 외래 키 참조 없음
		- 5. `employees` - 우선 외래 키 없이 생성 (자기 참조가 있으므로)
		- 6. `departments` - `locations` 및 `employees` 테이블 참조
		- 7. `job_history` - `employees`, `jobs`, `departments` 테이블 참조
		- 8. `job_grades` - 외래 키 참조 없음
		  
	- **외래 키 제약조건 설정 순서** (모든 테이블 생성 후 `ALTER TABLE`로 추가):
		- 1. `countries.region_id` → `regions.region_id`
		- 2. `locations.country_id` → `countries.country_id`
		- 3. `departments.location_id` → `locations.location_id`
		- 4. `departments.manager_id` → `employees.employee_id`
		- 5. `employees.job_id` → `jobs.job_id`
		- 6. `employees.department_id` → `departments.department_id`
		- 7. `employees.manager_id` → `employees.employee_id`
		- 8. `job_history.employee_id` → `employees.employee_id`
		- 9. `job_history.job_id` → `jobs.job_id`
		- 10. `job_history.department_id` → `departments.department_id`
		  
- - **이해도 체크 (객관식 문제)**: 아래 객관식 문제를 풀어 외래 키 의존성과 테이블 생성 순서의 이유를 이해하시오. 각 문제의 정답을 템플릿 파일에 주석으로 작성하시오.
  
    - **문제 1**: 왜 `regions` 테이블을 가장 먼저 생성해야 하는가?
        - a) 외래 키로 다른 테이블을 참조하기 때문
        - b) 다른 테이블에 `regions`를 참조하기 때문
        - c) `regions`가 가장 많은 데이터를 포함하기 때문
        - d) 순서와 상관없음
          
    - **문제 2**: `employees`와 `departments` 테이블 간 상호 참조 관계를 해결하기 위해 어떤 순서로 작업해야 하는가?
        - a) `employees`를 생성하고 바로 외래 키를 설정한 후 `departments` 생성
        - b) `departments`를 생성하고 바로 외래 키를 설정한 후 `employees` 생성
        - c) 두 테이블을 모두 생성한 후 외래 키를 설정
        - d) 상호 참조 관계는 설정할 수 없음
          
    - **문제 3**: `job_history` 테이블을 `employees`, `jobs`, `departments` 테이블보다 나중에 생성해야 하는 이유는?
        - a) `job_history`가 이 세 테이블을 외래 키로 참조하기 때문
        - b) `job_history`가 가장 많은 데이터를 포함하기 때문
        - c) 순서와 상관없음
        - d) `job_history`가 외래 키를 참조하지 않기 때문
          
    - **문제 4**: 왜 `employees` 테이블을 외래 키 없이 먼저 생성해야 하는가?
        - a) 데이터가 많아서 먼저 생성해야 하기 때문
        - b) 자기 참조 관계(`manager_id`)와 상호 참조 관계(`departments`)가 있기 때문
        - c) 외래 키 설정이 필요 없기 때문
        - d) 순서와 상관없기 때문
          
    - **문제 5**: `jobs` 테이블이 다른 테이블을 참조하지 않음에도 불구하고 `employees`와 `job_history` 전에 생성되는 이유는?
        - a) `jobs` 테이블이 가장 간단하기 때문
        - b) `employees`와 `job_history`가 `jobs.job_id`를 참조하기 때문
        - c) 데이터 크기가 작기 때문
        - d) 순서와 상관없기 때문
          
- **목표**: 외래 키 의존성과 상호 참조 관계를 이해하고, 테이블 생성 순서를 논리적으로 결정하는 설계 경험을 쌓는다.

### 3.2 데이터베이스 구축 (DDL 작성)

- 각 테이블(`regions`, `countries`, `locations`, `departments`, `jobs`, `employees`, `job_history`, `job_grades`)에 대해 `CREATE TABLE` 문 작성
- 테이블 정보를 참고하여 적절한 데이터 타입, 기본 키(PK), 외래 키(FK), NOT NULL, UNIQUE 등의 제약조건 정확히 반영
- 테이블 생성 순서와 외래 키 설정 순서를 3.1에서 제공된 순서를 기반으로 작성하시오.
- `job_history` 테이블에는 (`employee_id`, `start_date`)에 UNIQUE 제약조건 추가
- 외래 키 제약조건은 테이블 생성 후 `ALTER TABLE` 문을 사용하여 추가

### 3.3 데이터 적재 (DML)

- 교수자가 제공하는 DML 스크립트로 데이터 적재

### 3.4 SQL 질의 (Problems)

#### 다음 SQL 문제들을 해결하고 쿼리를 제출하세요:

1. **[초급]** `employees` 테이블에서 `salary`가 가장 높은 상위 5명 사원의 `first_name`, `last_name`, `salary`를 조회하시오. (급여 순으로 내림차순 정렬)
	- **출력 예시**: 
	  ```sql
| first_name | last_name | salary   |
| ---------- | --------- | -------- |
| Steven     | King      | 24000.00 |
| Neena      | Kochhar   | 17000.00 |
| Lex        | De Haan   | 17000.00 |
| John       | Russell   | 14000.00 |
| Karen      | Partners  | 13500.00 |	  
		```


2. **[초급]** `employees` 테이블과 `departments` 테이블을 (INNER) JOIN하여 'Sales' 부서(`department_name`)에 근무하는 모든 사원의 `employee_id`, `first_name`, `last_name`, `job_id`를 조회하시오.
	- **출력 예시**: 
	  ```sql
| employee_id | first_name | last_name | job_id |
|-------------|------------|-----------|--------|
| 145         | John       | Russell   | SA_MAN |
| 146         | Karen      | Partners  | SA_MAN |
| ... (Sales 부서의 다른 사원들) |	  
		```
	   

3. **[중급]** 각 부서(`department_name`)별 사원 수와 평균 급여(`salary`; 소수점 둘째 자리에서 반올림)를 계산하여 조회하시오. 결과는 부서명을 알파벳 순으로 정렬하고, 사원이 없는 부서는 제외하시오.
	- **출력 예시**:
	  ```sql
| department_name | employee_count | avg_salary |
|-----------------|----------------|------------|
| Accounting      | 2              | 10150.00  |
| Executive       | 3              | 19333.33  |
| ... (다른 부서들) |
		```


4. **[중급]** 2000년 이후(2000년 포함) 입사한 사원 중에서, 급여(`salary`)가 해당 부서의 평균 급여보다 높은 사원의 `employee_id`, `first_name`, `last_name`, `department_id`, `salary`를 조회하시오. (서브쿼리 활용 or `WITH` 절(CTE)[^1])
   [^1]: 인터넷에서 찾아서 활용해보세요. 어렵지 않아요. Give it a try!
	- **출력 예시**:
	  ```sql
| employee_id | first_name | last_name | department_id | salary |
|-------------|------------|-----------|---------------|--------|
| 179         | Charles    | Johnson   | 80            | 6200.00 |
| ... (다른 조건 만족 사원들) |
		```


5. **[상급]** 각 사원(`employee_id`, `first_name`, `last_name`)의 현재 급여(`salary`)와 직무 이력(`job_history`)에 기록된 이전 직무의 제목(`job_title`)을 함께 조회하시오. 이전 직무가 없는 사원도 결과에 포함하며, 이 경우 이전 직무 제목은 NULL로 표시하시오. (JOIN과 LEFT JOIN 활용)
	- **힌트**: 사원이 여러 직무 이력을 가질 수 있으므로, 가장 최근의 직무 이력만 가져오도록 조건을 추가해야 중복 결과가 발생하지 않습니다. 이를 위해 다음 단계로 접근하세요 (다른 방식도 가능):
	  1. `job_history` 테이블에서 각 `employee_id`별로 `MAX(end_date)`를 구하여 가장 최근 종료일을 찾습니다.
	  2. `WHERE (employee_id, end_date) IN (...)` 구문을 사용하여 해당 `employee_id`와 `end_date` 조합에 맞는 가장 최근 직무 이력의 `job_id`를 가져옵니다.
	  3. 이 결과를 `employees` 테이블과 `LEFT JOIN`하여 모든 사원을 포함시키고, 현재 급여 정보를 유지합니다.
	  4. `jobs` 테이블과 `LEFT JOIN`하여 이전 직무의 `job_title`을 가져옵니다. 이전 직무가 없는 경우 `NULL`로 표시됩니다.
	- **출력 예시**:
	  ```sql
| employee_id | first_name | last_name | salary   | previous_job_title |
|-------------|------------|-----------|----------|-------------------|
| 100         | Steven     | King      | 24000.00 | NULL              |
| 101         | Neena      | Kochhar   | 17000.00 | Accountant        |
| ... (다른 사원들) |
		```

6. **[중급]** 각 사원의 근속 연수를 계산하고, 근속 연수에 따른 보너스를 계산하는 쿼리를 작성하시오. 근속 연수는 현재 날짜와 입사일(hire_date) 기준으로 계산하며, 다음 보너스 비율을 적용하시오:
	- 25년 이상: 급여의 25%
	- 20년 이상: 급여의 20%
	- 15년 이상: 급여의 15%
	- 10년 이상: 급여의 10%
	- 그 외: 급여의 5%  
    결과는 근속 연수를 기준으로 내림차순 정렬하시오.
    - **힌트**: YEAR, DATEDIFF, ROUND, CONCAT, CASE 함수 등 내장함수를 이용하세요.
	- **출력 예시**:
	  ```sql
| employee_id | employee_name  | hire_date  | years_of_service | exact_years | salary   | service_bonus |
|-------------|----------------|------------|------------------|-------------|----------|---------------|
| 100         | Steven King    | 1987-06-17 | 38               | 38.0        | 24000.00 | 6000.0000     |
| 200         | Jennifer Whalen| 1987-09-17 | 38               | 37.7        | 4400.00  | 1100.0000     |
| 101         | Neena Kochhar  | 1989-09-21 | 36               | 35.7        | 17000.00 | 4250.0000     |
| 103         | Alexander Hunold| 1990-01-03| 35               | 35.4        | 9000.00  | 2250.0000     |
| ... (다른 사원들) |
		```


7. **[상급, 보너스 문제 20점]** 사원 위치 정보 뷰 생성 및 활용
	(1) 먼저 사원의 근무 위치 정보를 포함하는 뷰(employee_location_details)를 생성하시오. 뷰는 employees, departments, locations, countries, regions, jobs 테이블을 JOIN하여 생성하시오. 
	- **힌트**: 6개 테이블을 JOIN할 때는 적절한 조인 조건을 설정하여 모든 테이블이 정확히 연결되도록 해야 합니다.
	- **출력 예시** (뷰의 일부 컬럼만 표시):
	  ```sql
| employee_id | employee_name     | salary   | job_title  | department_name | city      | country_name           | region_name |
|-------------|-------------------|----------|------------|-----------------|-----------|------------------------|-------------|
| 103         | Alexander Hunold  | 9000.00  | Programmer | IT              | Southlake | United States of America| Americas    |
| 104         | Bruce Ernst       | 6000.00  | Programmer | IT              | Southlake | United States of America| Americas    |
| ... (다른 사원들) |
		```
    
	(2) 위에서 생성한 뷰를 사용하여 'Americas' 지역(region_name)에 근무하는 사원 수를 조회하시오. 
	- **힌트**: 뷰에서 region_name 조건으로 필터링하고 COUNT 함수를 사용하세요.
	- **출력 예시**:
	  ```sql
| region_name | employee_count |
|-------------|----------------|
| Americas    | 70             |
		```
    
	(3) 위에서 생성한 뷰를 사용하여 국가별, 부서별 평균 급여를 조회하시오. 결과는 국가명을 기준으로 오름차순 정렬하고, 각 국가 내에서는 평균 급여를 기준으로 내림차순 정렬하시오.
	- **힌트**: 뷰에서 country_name과 department_name으로 GROUP BY하고, AVG 함수로 급여 평균을 계산하세요.
	- **출력 예시**:
	  ```sql
| country_name           | department_name | avg_salary |
|------------------------|-----------------|------------|
| Canada                 | Marketing       | 9500.00    |
| Germany                | Public Relations| 10000.00   |
| United Kingdom         | Sales           | 8955.88    |
| United Kingdom         | Human Resources | 6500.00    |
| United States of America| Executive      | 19333.33   |
| ... (다른 국가와 부서들) |
		```
    
	(4) 위에서 생성한 뷰를 사용하여 각 지역(region_name)별로 가장 높은 급여를 받는 사원의 정보(이름, 직무, 부서, 급여)를 조회하시오.
	- **힌트**: 먼저 각 지역별 최고 급여를 구한 뒤, 이를 원래 뷰와 조인하여 해당 급여를 받는 사원 정보를 가져오세요.
	- **출력 예시**:
	  ```sql
| region_name | employee_name | job_title      | department_name | salary   |
|-------------|---------------|----------------|-----------------|----------|
| Americas    | Steven King   | President      | Executive       | 24000.00 |
| Europe      | John Russell  | Sales Manager  | Sales           | 14000.00 |
		```

## 4. 제출물

1. **외래 키 의존성 이해도 체크**: 객관식 문제 답안 포함
2. **DDL 스크립트**: `CREATE TABLE` 문과 `ALTER TABLE`을 사용한 외래 키 설정을 포함
3. **SQL 질의 응답**: 각 문제(3.4절)에 대한 SQL 쿼리문을 포함
4. **제출 형식**: `이름_학번_term_project.sql` 형식으로 제출
	- 1, 2, 3번을 `이름_학번_term_project.sql`에 작성 (제공한 `template` 참고)


## 5. 제출일

- **1차**: 2025년 6월 9일 (월) 23:59 까지
	- **2차**: 2025년 6월 16일 (월) 23:59 (50% 감점)
	  
- **제출 방법**:
	- 제출 파일은 `이름_학번_term_project.sql` 형식으로 저장하여 제출합니다.
	- 파일 형식 및 이름 규칙을 반드시 준수해야 하며, 미준수 시 감점(-2점)이 적용될 수 있습니다.
	  
- **주의사항**:
	- 제출 전 파일 내 모든 코드가 정상적으로 실행되는지 확인하세요.
	- DDL 스크립트 및 SQL 질의 응답에 충분한 주석을 포함하여 코드의 목적과 로직을 설명해야 하며, 주석 미비 시 감점(-2점)이 적용될 수 있습니다.
	- 늦은 제출은 1차 마감 이후 2차 마감까지 50% 감점 적용 후 접수됩니다. 2차 마감 이후 제출은 접수되지 않습니다.