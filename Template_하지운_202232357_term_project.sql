/* 
 * 데이터베이스 시스템 Term Project
 * 제출자: [하지운]
 * 학번: [202232357]
 * 날짜: [제출일]
 */

-- ----------------------------------------------------
-- 0. 외래 키 의존성 이해도 체크 (객관식 문제)
-- ----------------------------------------------------

-- 아래 객관식 문제를 풀어 외래 키 의존성과 순서의 이유를 이해했는지 확인하세요.
-- 각 문제의 정답을 주석으로 작성하세요.
-- 문제 1: 왜 regions 테이블을 가장 먼저 생성해야 하는가?
-- a) 외래 키로 다른 테이블을 참조하기 때문
-- b) 다른 테이블에서 regions를 참조하기 때문
-- c) regions가 가장 많은 데이터를 포함하기 때문
-- d) 순서와 상관없음
-- 답안: b

-- 문제 2: employees와 departments 테이블 간 상호 참조 관계를 해결하기 위해 어떤 순서로 작업해야 하는가?
-- a) employees를 생성하고 바로 외래 키를 설정한 후 departments 생성
-- b) departments를 생성하고 바로 외래 키를 설정한 후 employees 생성
-- c) 두 테이블을 모두 생성한 후 외래 키를 설정
-- d) 상호 참조 관계는 설정할 수 없음
-- 답안: c

-- 문제 3: job_history 테이블을 employees, jobs, departments 테이블보다 나중에 생성해야 하는 이유는?
-- a) job_history가 이 세 테이블을 외래 키로 참조하기 때문
-- b) job_history가 가장 많은 데이터를 포함하기 때문
-- c) 순서와 상관없음
-- d) job_history가 외래 키를 참조하지 않기 때문
-- 답안: a

-- 문제 4: 왜 employees 테이블을 외래 키 없이 먼저 생성해야 하는가?
-- a) 데이터가 많아서 먼저 생성해야 하기 때문
-- b) 자기 참조 관계(manager_id)와 상호 참조 관계(departments)가 있기 때문
-- c) 외래 키 설정이 필요 없기 때문
-- d) 순서와 상관없기 때문
-- 답안: b

-- 문제 5: jobs 테이블이 다른 테이블을 참조하지 않음에도 불구하고 employees와 job_history 전에 생성되는 이유는?
-- a) jobs 테이블이 가장 간단하기 때문
-- b) employees와 job_history가 jobs.job_id를 참조하기 때문
-- c) 데이터 크기가 작기 때문
-- d) 순서와 상관없기 때문
-- 답안: b

-- ----------------------------------------------------
-- 1. 데이터베이스 구축 (DDL 작성)
-- 테이블 생성 순서는 외래 키 의존성을 고려해야 합니다.
-- ----------------------------------------------------

-- 1.1 regions 테이블 생성
CREATE TABLE regions (
    region_id INT UNSIGNED NOT NULL,
	region_name VARCHAR(25),
	PRIMARY KEY (region_id)
);

-- 1.2 countries 테이블 생성
CREATE TABLE countries (
    country_id CHAR(2) NOT NULL,
	country_name VARCHAR(40),
	region_id INT UNSIGNED NOT NULL,
	PRIMARY KEY (country_id)
);

-- 1.3 locations 테이블 생성
CREATE TABLE locations (
    location_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
	street_address VARCHAR(40),
	postal_code VARCHAR(12),
	city VARCHAR(30) NOT NULL,
	state_province VARCHAR(25),
	country_id CHAR(2) NOT NULL,
	PRIMARY KEY (location_id)
);

-- 1.4 departments 테이블 생성
CREATE TABLE departments (
    department_id INT UNSIGNED NOT NULL,
	department_name VARCHAR(30) NOT NULL,
	manager_id INT UNSIGNED,
	location_id INT UNSIGNED,
	PRIMARY KEY (department_id)
);

-- 1.5 jobs 테이블 생성
CREATE TABLE jobs (
    job_id VARCHAR(10) NOT NULL,
	job_title VARCHAR(35) NOT NULL,
	min_salary DECIMAL(8,0) UNSIGNED,
	max_salary DECIMAL(8,0) UNSIGNED,
	PRIMARY KEY (job_id)
);

-- 1.6 employees 테이블 생성
CREATE TABLE employees (
    employee_id INT UNSIGNED NOT NULL,
	first_name VARCHAR(20),
	last_name VARCHAR(25) NOT NULL,
	email VARCHAR(25) NOT NULL,
	phone_number VARCHAR(20),
	hire_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	salary DECIMAL(8,2) NOT NULL,
	commission_pct DECIMAL(2,2),
	manager_id INT UNSIGNED,
	department_id INT UNSIGNED,
	PRIMARY KEY (employee_id)
);

-- 1.7 job_history 테이블 생성
CREATE TABLE job_history (
    employee_id INT UNSIGNED NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	job_id VARCHAR(10) NOT NULL,
	department_id INT UNSIGNED NOT NULL
);

-- 1.8 job_grades 테이블 생성
CREATE TABLE job_grades (
    grade_level CHAR(1) NOT NULL,
	lowest_sal INT NOT NULL,
	highest_sal INT NOT NULL,
	PRIMARY KEY (grade_level)
);

-- 1.9 job_history 테이블 UNIQUE 제약조건 추가
ALTER TABLE job_history ADD UNIQUE INDEX (
    employee_id, start_date
);

-- ----------------------------------------------------
-- 2. 외래 키 제약조건 설정
-- 상호 참조 관계(employees, departments)는 순서에 주의하세요.
-- ----------------------------------------------------

-- 2.1 countries 테이블 외래 키 설정
ALTER TABLE countries ADD FOREIGN KEY (
    region_id) 
    REFERENCES regions (region_id
);

-- 2.2 locations 테이블 외래 키 설정
ALTER TABLE locations ADD FOREIGN KEY (
    country_id) REFERENCES countries (country_id
);

-- 2.3 departments 테이블 외래 키 설정
ALTER TABLE departments ADD FOREIGN KEY (
    location_id) REFERENCES locations (location_id
);

-- 2.4 departments 테이블 추가 외래 키 설정 (manager_id)
-- 주석: employees 테이블과의 상호 참조 관계 해결
ALTER TABLE departments ADD FOREIGN KEY (
    manager_id) REFERENCES employees (employee_id
);

-- 2.5 employees 테이블 외래 키 설정 (job_id)
ALTER TABLE employees ADD FOREIGN KEY (
    job_id) REFERENCES jobs (job_id
);

-- 2.6 employees 테이블 외래 키 설정 (department_id)
-- 주석: departments 테이블 생성 후 설정 가능 (상호 참조 관계 고려)
ALTER TABLE employees ADD FOREIGN KEY (
    department_id) REFERENCES departments (department_id
);

-- 2.7 employees 테이블 외래 키 설정 (manager_id)
-- 주석: 자기 참조 관계
ALTER TABLE employees ADD FOREIGN KEY (
    manager_id) REFERENCES employees (employee_id
);


-- 2.8 job_history 테이블 외래 키 설정 (employee_id)
ALTER TABLE job_history ADD FOREIGN KEY (
    employee_id) REFERENCES employees (employee_id
);

-- 2.9 job_history 테이블 외래 키 설정 (job_id)
ALTER TABLE job_history ADD FOREIGN KEY (
    job_id) REFERENCES jobs (job_id
);

-- 2.10 job_history 테이블 외래 키 설정 (department_id)
ALTER TABLE job_history ADD FOREIGN KEY (
    department_id) REFERENCES departments (department_id
);

-- ----------------------------------------------------
-- 3. SQL 질의 문제 해결
-- ----------------------------------------------------

-- 문제 1: [쉬움] 급여가 높은 상위 5명 사원 조회
-- employees 테이블에서 salary가 가장 높은 상위 5명 사원의 first_name, last_name, salary를 조회하시오.
-- (급여 순으로 내림차순 정렬)

-- 답안:
SELECT first_name, last_name, salary
FROM employees
ORDER BY salary DESC
LIMIT 5;

-- 문제 2: [쉬움] Sales 부서 사원 조회
-- employees 테이블과 departments 테이블을 JOIN하여 'Sales' 부서(department_name)에 근무하는 
-- 모든 사원의 employee_id, first_name, last_name, job_id를 조회하시오.

-- 답안:
SELECT e.employee_id, e.first_name, e.last_name, e.job_id
FROM employees e
JOIN departments d 
ON e.department_id = d.department_id
WHERE d.department_name = 'Sales';

-- 문제 3: [중간] 부서별 사원 수와 평균 급여 계산
-- 각 부서(department_name)별 사원 수와 평균 급여(salary)를 계산하여 조회하시오.
-- 결과는 부서명을 알파벳 순으로 정렬하고, 사원이 없는 부서는 제외하시오.

-- 답안:
SELECT d.department_name, COUNT(e.employee_id), AVG(e.salary)
FROM employees e
JOIN departments d  
ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY d.department_name ASC;

-- 문제 4: [중간] 2000년 이후 입사 & 부서 평균보다 높은 급여 사원 조회
-- 2000년 이후(2000년 포함) 입사한 사원 중에서, 급여(salary)가 해당 부서의 평균 급여보다 높은 
-- 사원의 employee_id, first_name, last_name, department_id, salary를 조회하시오. (서브쿼리 활용)

-- 답안:
SELECT e.employee_id, e.first_name, e.last_name, e.department_id, e.salary
FROM employees e
JOIN (	SELECT department_id, AVG(salary) AS avg_dept_salary
		FROM employees
		WHERE department_id IS NOT NULL -- 부서가 없는 사원은 제외
		GROUP BY department_id) d_avg 
ON e.department_id = d_avg.department_id
WHERE YEAR(e.hire_date) >= 2000 AND e.salary > d_avg.avg_dept_salary
;

-- 문제 5: [어려움] 사원의 현재 급여와 이전 직무 제목 조회
-- 각 사원(employee_id, first_name, last_name)의 현재 급여(salary)와 직무 이력(job_history)에 
-- 기록된 이전 직무의 제목(job_title)을 함께 조회하시오. 이전 직무가 없는 사원도 결과에 포함하며, 
-- 이 경우 이전 직무 제목은 NULL로 표시하시오. (JOIN과 LEFT JOIN 활용)

-- 답안:
SELECT e.employee_id, e.first_name, e.last_name, e.salary, j.job_title AS previous_job_title
FROM employees e
LEFT JOIN (	SELECT employee_id, job_id, end_date, ROW_NUMBER() OVER(PARTITION BY employee_id ORDER BY end_date DESC) as rn
			FROM job_history) jh_latest 
ON e.employee_id = jh_latest.employee_id AND jh_latest.rn = 1 
LEFT JOIN jobs j 
ON jh_latest.job_id = j.job_id
;

-- 문제 6: [중급] 근속 연수 및 보너스 계산
-- 각 사원의 근속 연수를 계산하고, 근속 연수에 따른 보너스를 계산하는 쿼리를 작성하시오.
-- 근속 연수는 현재 날짜와 입사일(hire_date) 기준으로 계산하며, 다음 보너스 비율을 적용하시오:
--   * 25년 이상: 급여의 25%
--   * 20년 이상: 급여의 20%
--   * 15년 이상: 급여의 15%
--   * 10년 이상: 급여의 10%
--   * 그 외: 급여의 5%
-- 결과는 근속 연수를 기준으로 내림차순 정렬하시오.
-- (YEAR, DATEDIFF, ROUND, CONCAT, CASE 함수 활용)

-- 답안:
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS employee_name, hire_date,
TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS years_of_service, ROUND(DATEDIFF(CURDATE(), hire_date) / 365.25, 1) AS exact_years, salary,
CASE
WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 25 THEN salary * 0.25
WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 20 THEN salary * 0.20
WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 15 THEN salary * 0.15
WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) >= 10 THEN salary * 0.10
ELSE salary * 0.05
END AS service_bonus
FROM employees
ORDER BY years_of_service DESC, exact_years DESC
;

-- 문제 7: [중급-상급] 사원 위치 정보 뷰 생성 및 활용
-- 7-1: 먼저 아래와 같이 사원의 근무 위치 정보를 포함하는 뷰(employee_location_details)를 생성하시오.
-- 뷰는 employees, departments, locations, countries, regions, jobs 테이블을 JOIN하여 생성하시오.

-- CREATE VIEW는 새로운 뷰를 생성, 기존 VIEW가 존재하면 에러 발생
-- CREATE OR REPLACE VIEW는 뷰가 있으면 덮어쓰기, 없으면 새로 생성
CREATE OR REPLACE VIEW employee_location_details AS
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS employee_name, e.salary, j.job_title, 
d.department_name, l.city, c.country_name, r.region_name
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id -- 부서가 없는 사원도 포함 가능하도록 LEFT JOIN
LEFT JOIN locations l ON d.location_id = l.location_id -- 부서 위치가 없는 부서도 포함
LEFT JOIN countries c ON l.country_id = c.country_id
LEFT JOIN regions r ON c.region_id = r.region_id
JOIN jobs j ON e.job_id = j.job_id
;

-- 7-2: [초급] 위에서 생성한 뷰를 사용하여 'Americas' 지역(region_name)에 근무하는 
-- 사원 수를 조회하시오.

-- 답안:
SELECT region_name, COUNT(employee_id) AS employee_count
FROM employee_location_details
WHERE region_name = 'Americas'
GROUP BY region_name;

-- 7-3: [중초급] 위에서 생성한 뷰를 사용하여 국가별, 부서별 평균 급여를 조회하시오.
-- 결과는 국가명을 기준으로 오름차순 정렬하고, 각 국가 내에서는 평균 급여를 기준으로 내림차순 정렬하시오.

-- 답안:
SELECT country_name, department_name, ROUND(AVG(salary), 2) AS avg_salary
FROM employee_location_details
WHERE department_name IS NOT NULL 
GROUP BY country_name, department_name
ORDER BY country_name ASC, avg_salary DESC;

-- 7-4: [중급] 위에서 생성한 뷰를 사용하여 각 지역(region_name)별로 가장 높은 급여를 받는 
-- 사원의 정보(이름, 직무, 부서, 급여)를 조회하시오.

-- 답안:
SELECT eld.region_name, eld.employee_name, eld.job_title, eld.department_name, eld.salary
FROM employee_location_details eld
JOIN ( SELECT region_name, MAX(salary) AS max_region_salary
		FROM employee_location_details
		WHERE region_name IS NOT NULL 
		GROUP BY region_name) max_salaries 
ON eld.region_name = max_salaries.region_name AND eld.salary = max_salaries.max_region_salary;
;
