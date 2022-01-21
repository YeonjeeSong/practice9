-- JOIN 연습문제

-- 1. 이름에 '형'자가 들어가는 직원들의
-- 사번, 사원명, 직급명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
 -- JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING(JOB_CODE)
 WHERE EMP_NAME LIKE '%형%';

-- 오라클 전용
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND EMP_NAME LIKE '%형%';

-- 2. 주민번호가 70년대 생이면서 성별이 여자이고, 
--    성이 전씨인 직원들의 사원명, 주민번호, 부서명, 직급명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , E.EMP_NO 주민번호
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 -- JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING(JOB_CODE)
 WHERE SUBSTR(EMP_NO, 1, 2) LIKE '7%'
   AND SUBSTR(EMP_NO, 8, 1) = 2
   AND EMP_NAME LIKE '전%';

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , E.EMP_NO 주민번호
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND SUBSTR(EMP_NO, 1, 2) LIKE '7%'
   AND SUBSTR(EMP_NO, 8, 1) = 2
   AND EMP_NAME LIKE '전%';

-- 3. 가장 나이가 적은 직원의 사번, 사원명, 
--    나이, 부서명, 직급명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) "나이(만)"
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 -- JOIN JOB J USING(JOB_CODE)
 WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))) = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))))
                                                                                                     FROM EMPLOYEE
                                                                                              );

-- ORACLE 전용
SELECT
       E.EMP_ID 사번
     , E.EMP_NAME 사원명
     , EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR'))) "나이(만)"
     , D.DEPT_TITLE 부서명
     , J.JOB_NAME 직급명
  FROM EMPLOYEE E
     , DEPARTMENT D
     , JOB J
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND E.JOB_CODE = J.JOB_CODE
   AND EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(E.EMP_NO, 1, 2), 'RR'))) = (SELECT MIN(EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM(TO_DATE(SUBSTR(EMP_NO, 1, 2), 'RR'))))
                                                                                                   FROM EMPLOYEE
                                                                                                );

-- 4. 부서코드가 D2인 직원들의 사원명, 
--    직급명, 부서명, 근무지역명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
 -- JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING(JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.DEPT_CODE = 'D2';

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
     , LOCATION L
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND E.DEPT_CODE = 'D2';

-- 5. 보너스포인트가 없는 직원들 중에서 직급코드가 
--     J4와 J7인 직원들의 사원명, 직급명, 급여를 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
  FROM EMPLOYEE E
  JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
 -- JOIN JOB J USING(JOB_CODE)
 WHERE E.BONUS IS NULL
   AND E.JOB_CODE IN('J4', 'J7');
   -- ORA-25154: USING 절의 열 부분은 식별자를 가질 수 없음
   -- => USING에 사용된 식별자는 좌, 우측 테이블에 동시에 존재하는 컬럼이라는 것을
   --    전제로 작성하기 때문에 굳이 식별자를 붙일 이유가 없다.
   -- => AND JOB_CODE IN('J4', 'J7');

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
  FROM EMPLOYEE E
     , JOB J
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.BONUS IS NULL
   AND E.JOB_CODE IN('J4', 'J7');

-- * 조건에 맞는 모든 결과가 인출됐는지 확인 해야 한다. *
-- 6. 보너스포인트를 받는 직원들의 사원명, 
--    보너스포인트, 부서명, 근무지역명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , E.BONUS 보너스포인트
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
 -- LEFT OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 -- LEFT OUTER JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
  FULL OUTER JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  FULL OUTER JOIN LOCATION L ON(D.LOCATION_ID = L.LOCAL_CODE)
 WHERE E.BONUS IS NOT NULL;

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , E.BONUS 보너스포인트
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 근무지역명
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
 WHERE E.DEPT_CODE = D.DEPT_ID(+)
   AND D.LOCATION_ID = L.LOCAL_CODE(+)
   AND E.BONUS IS NOT NULL;
   -- 하동운의 BONUS가 0.1, DEPT_CODE값이 NULL => LOCATION_ID값도 NULL
   -- DEPT_CODE는 NULL이지만 BONUS 인출을 위해 LEFT OUTER JOIN을 해주고,
   -- (BONUS는 EMPLOYEE 테이블에 있으므로 LEFT OUTER JOIN을 해줘야 한다.)
   -- LOCATION_ID 인출을 위해 LEFT OUTER JOIN을 해준다.
   -- (LOCATION_ID는 DEPARTMENT 테이블에 있으므로 LEFT OUTER JOIN을 해줘야 한다.)

-- 7. 해외영업팀에 근무하는 사원명, 
--    직급명, 부서코드, 부서명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.DEPT_CODE 부서코드
     , D.DEPT_TITLE 부서명
  FROM EMPLOYEE E
 -- JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING(JOB_CODE)
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
 WHERE D.DEPT_TITLE LIKE '해외영업%';

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.DEPT_CODE 부서코드
     , D.DEPT_TITLE 부서명
  FROM EMPLOYEE E
     , JOB J
     , DEPARTMENT D
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.DEPT_CODE = D.DEPT_ID
   AND D.DEPT_TITLE LIKE '해외영업%';

-- 8. 본인 급여 등급의 최소급여(MIN_SAL)를 초과하여 급여를 받는 직원들의
--    사원명, 직급명, 급여, 보너스포함 연봉을 조회하세요.
--    연봉에 보너스포인트를 적용한다.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
     , (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12 "보너스 포함 연봉"
  FROM EMPLOYEE E
 -- JOIN JOB J ON(E.JOB_CODE = J.JOB_CODE)
  JOIN JOB J USING(JOB_CODE)
  JOIN SAL_GRADE S ON(E.SAL_LEVEL = S.SAL_LEVEL)
 WHERE SALARY > S.MIN_SAL;

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , J.JOB_NAME 직급명
     , E.SALARY 급여
     , (E.SALARY + (E.SALARY * NVL(E.BONUS, 0))) * 12 "보너스 포함 연봉"
  FROM EMPLOYEE E
     , JOB J
     , SAL_GRADE S
 WHERE E.JOB_CODE = J.JOB_CODE
   AND E.SAL_LEVEL = S.SAL_LEVEL
   AND SALARY > MIN_SAL;

-- 9. 한국과 일본에 근무하는 직원들의 
--    사원명, 부서명, 지역명, 국가명을 조회하세요.
-- ANSI 표준
SELECT
       E.EMP_NAME 사원명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 지역명
     , N.NATIONAL_NAME 국가명
  FROM EMPLOYEE E
  JOIN DEPARTMENT D ON(E.DEPT_CODE = D.DEPT_ID)
  JOIN LOCATION L ON(LOCATION_ID = LOCAL_CODE)
 -- JOIN NATIONAL N ON(L.NATIONAL_CODE = N.NATIONAL_CODE)
  JOIN NATIONAL N USING(NATIONAL_CODE)
 WHERE N.NATIONAL_NAME IN('한국', '일본');

-- 오라클 전용
SELECT
       E.EMP_NAME 사원명
     , D.DEPT_TITLE 부서명
     , L.LOCAL_NAME 지역명
     , N.NATIONAL_NAME 국가명
  FROM EMPLOYEE E
     , DEPARTMENT D
     , LOCATION L
     , NATIONAL N
 WHERE E.DEPT_CODE = D.DEPT_ID
   AND D.LOCATION_ID = L.LOCAL_CODE
   AND L.NATIONAL_CODE = N.NATIONAL_CODE
   AND N.NATIONAL_NAME IN('한국', '일본');

-- 10. 같은 부서에 근무하는 직원들의 사원명, 부서코드, 
--     동료이름을 조회하세요. self join 사용 (60행)
-- ANSI 표준
SELECT
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME
  FROM EMPLOYEE E1
  JOIN EMPLOYEE E2 ON(E1.DEPT_CODE = E2.DEPT_CODE)
 WHERE E1.EMP_NAME != E2.EMP_NAME
 ORDER BY 1;

-- 오라클 전용
SELECT
       E1.EMP_NAME
     , E1.DEPT_CODE
     , E2.EMP_NAME
  FROM EMPLOYEE E1
     , EMPLOYEE E2
 WHERE E1.DEPT_CODE = E2.DEPT_CODE
   AND E1.EMP_NAME != E2.EMP_NAME
 ORDER BY 1;