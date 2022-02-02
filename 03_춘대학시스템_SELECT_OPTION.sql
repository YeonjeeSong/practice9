-- ADDITIONAL SELECT - OPTION

-- 1. 학생이름과 주소지를 표시하시오. 단, 출력 헤더는 "학생 이름", "주소지"로 하고,
--    정렬은 이름으로 오름차순 표시하도록 한다.
SELECT
       STUDENT_NAME "학생 이름"
     , STUDENT_ADDRESS 주소지
  FROM TB_STUDENT
 ORDER BY 1;

-- 2. 휴학중인 학생들의 이름과 주민번호를 나이가 적은 순서로 화면에 출력하시오.
SELECT
       STUDENT_NAME
     , STUDENT_SSN
  FROM TB_STUDENT
 WHERE ABSENCE_YN = 'Y'
 ORDER BY STUDENT_SSN DESC;

-- 3. 주소지가 강원도나 경기도인 학생들 중 1900년대 학번을 가진 학생들의 이름과 학번,
--    주소를 이름의 오름차순으로 화면에 출력하시오.
--    단, 출력 헤더에는 "학생 이름", "학번", "거주지 주소"가 출력되도록 한다.
SELECT
       STUDENT_NAME "학생 이름"
     , STUDENT_NO 학번
     , STUDENT_ADDRESS "거주지 주소"
  FROM TB_STUDENT
 WHERE (STUDENT_ADDRESS LIKE '%강원도%'
    OR STUDENT_ADDRESS LIKE '%경기도%')
   AND SUBSTR(ENTRANCE_DATE, 1, 2) LIKE '9%';

-- 4. 현재 법학과 교수 중 가장 나이가 많은 사람부터 이름을 확인 할 수 있는
--    SQL 문장을 작성하시오. (법학과의 '학과코드'는
--    학과 테이블(TB_DEPARTMENT)을 조회해서 찾아내도록 하자)
-- 방법1.
SELECT
       DEPARTMENT_NO
  FROM TB_DEPARTMENT
 WHERE DEPARTMENT_NAME = '법학과'; -- 005

SELECT
       PROFESSOR_NAME
     , PROFESSOR_SSN
  FROM TB_PROFESSOR
 WHERE DEPARTMENT_NO = 005
 ORDER BY 2;

-- 방법2.
SELECT
       P.PROFESSOR_NAME
     , P.PROFESSOR_SSN
  FROM TB_PROFESSOR P
 -- JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '법학과'
 ORDER BY 2;

-- 5. 2004년 2학기에 'C3118100' 과목을 수강한 학생들의 학점을 조회하려고 한다.
--    학점이 높은 학생부터 표시하고, 학점이 같으면 학번이 낮은 학생부터 표시하는
--    구문을 작성해 보시오.
SELECT
       STUDENT_NO
     , TO_CHAR(POINT, '9.99') POINT
  FROM TB_GRADE
 WHERE TERM_NO = '200402'
   AND CLASS_NO = 'C3118100'
 ORDER BY 2 DESC, 1;

-- 6. 학생 번호, 학생 이름, 학과 이름을 학생 이름으로 오름차순 정렬하여 출력하는
--    SQL 문을 작성하시오.
SELECT
       S.STUDENT_NO
     , S.STUDENT_NAME
     , D.DEPARTMENT_NAME
  FROM TB_STUDENT S
 -- JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 ORDER BY 2;

-- 7. 춘 기술대학교의 과목 이름과 과목의 학과 이름을 출력하는 SQL 문장을 작성하시오.
SELECT
       C.CLASS_NAME
     , D.DEPARTMENT_NAME
  FROM TB_CLASS C
 -- JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO);

-- 8. 과목별 교수 이름을 찾으려고 한다. 과목 이름과 교수 이름을 출력하는
--    SQL 문을 작성하시오.
SELECT
       C.CLASS_NAME
     , P.PROFESSOR_NAME
  FROM TB_CLASS C
 -- JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
  JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO)
 -- JOIN TB_PROFESSOR P ON(CP.PROFESSOR_NO = P.PROFESSOR_NO)
  JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
 ORDER BY 1;

-- 9. 8번의 결과 중 ‘인문사회’ 계열에 속한 과목의 교수 이름을 찾으려고 한다.
--    이에 해당하는 과목 이름과 교수 이름을 출력하는 SQL 문을 작성하시오.
-- 방법1.
-- 1. '인문사회' 계열에 속한 과목의 교수 이름 조회
SELECT
       P.PROFESSOR_NAME
  FROM TB_PROFESSOR P
 -- JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.CATEGORY = '인문사회';

-- 2. 1에 해당하는 과목 이름과 교수 이름 조회
SELECT
       C.CLASS_NAME
     , P.PROFESSOR_NAME
  FROM TB_CLASS C
 -- JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
  JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO)
 -- JOIN TB_PROFESSOR P ON(CP.PROFESSOR_NO = P.PROFESSOR_NO)
  JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
 WHERE P.PROFESSOR_NAME IN (SELECT
                                   P.PROFESSOR_NAME
                              FROM TB_PROFESSOR P
                              JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
                             WHERE D.CATEGORY = '인문사회');

-- 방법2.
SELECT
       C.CLASS_NAME
     , P.PROFESSOR_NAME
  FROM TB_CLASS C
 -- JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
  JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO)
 -- JOIN TB_PROFESSOR P ON(CP.PROFESSOR_NO = P.PROFESSOR_NO)
  JOIN TB_PROFESSOR P USING(PROFESSOR_NO)
  JOIN TB_DEPARTMENT D ON(P.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.CATEGORY = '인문사회'
 ORDER BY 1;

-- 10. ‘음악학과’ 학생들의 평점을 구하려고 한다. 음악학과 학생들의 "학번", "학생 이름",
--     "전체 평점"을 출력하는 SQL 문장을 작성하시오.
--     (단, 평점은 소수점 1자리까지만 반올림하여 표시한다.)
SELECT
       S.STUDENT_NO 학번
     , S.STUDENT_NAME "학생 이름"
     , ROUND(AVG(G.POINT), 1) "전체 평점"
  FROM TB_STUDENT S
  JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
  JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '음악학과'
 GROUP BY S.STUDENT_NO, S.STUDENT_NAME
 ORDER BY 1;

SELECT
       STUDENT_NO 학번
     , S.STUDENT_NAME "학생 이름"
     , ROUND(AVG(G.POINT), 1) "전체 평점"
  FROM TB_STUDENT S
  JOIN TB_GRADE G USING(STUDENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '음악학과'
 GROUP BY STUDENT_NO, S.STUDENT_NAME
 ORDER BY 1;

-- 11. 학번이 A313047인 학생이 학교에 나오고 있지 않다. 지도 교수에게 내용을 전달하기
--     위한 학과 이름, 학생 이름과 지도 교수 이름이 필요하다. 이때 사용할 SQL 문을
--     작성하시오. 단, 출력 헤더는 "학과 이름", "학생 이름", "지도 교수 이름"으로
--     출력되도록 한다.
SELECT
       D.DEPARTMENT_NAME "학과 이름"
     , S.STUDENT_NAME "학생 이름"
     , P.PROFESSOR_NAME "지도 교수 이름"
  FROM TB_DEPARTMENT D
 -- JOIN TB_STUDENT S ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
  JOIN TB_STUDENT S USING(DEPARTMENT_NO)
  JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
 WHERE S.STUDENT_NO = 'A313047';

-- 12. 2007년도에 '인간관계론' 과목을 수강한 학생을 찾아 학생 이름과
--     수강 학기를 표시하는 SQL 문장을 작성하시오.
SELECT
       S.STUDENT_NAME
     , G.TERM_NO TERM_NAME
  FROM TB_STUDENT S
 -- JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
  JOIN TB_GRADE G USING(STUDENT_NO)
 -- JOIN TB_CLASS C ON(G.CLASS_NO = C.CLASS_NO)
  JOIN TB_CLASS C USING(CLASS_NO)
 WHERE C.CLASS_NAME = '인간관계론'
   AND SUBSTR(TERM_NO, 1, 4) = '2007'
 ORDER BY 1;

-- 13. 예체능 계열 과목 중 과목 담당 교수를 한 명도 배정 받지 못한 과목을 찾아
--     그 과목 이름과 학과 이름을 출력하는 SQL 문장을 작성하시오.
-- 과목 담당 교수를 한 명도 배정 받지 못한 과목
-- : TB_CLASS_PROFESSOR에는 과목 번호와 교수 번호가 매칭되어 있다. (776개)
--   TB_CLASS에서는 과목 번호가 882개이므로 교수 번호가 매칭되어 있지 않은 과목이 존재한다.
SELECT
       C.CLASS_NAME
     , D.DEPARTMENT_NAME
  FROM TB_CLASS C
 -- LEFT OUTER JOIN TB_CLASS_PROFESSOR CP ON(C.CLASS_NO = CP.CLASS_NO)
  LEFT OUTER JOIN TB_CLASS_PROFESSOR CP USING(CLASS_NO)
 -- JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.CATEGORY = '예체능'
   AND CP.PROFESSOR_NO IS NULL;

-- 14. 춘 기술대학교 서반아어학과 학생들의 지도 교수를 게시하고자 한다. 학생 이름과
--     지도 교수 이름을 찾고 만일 지도 교수가 없는 학생일 경우 "지도 교수 미지정"으로
--     표시하도록 하는 SQL 문을 작성하시오. 단, 출력 헤더는 "학생 이름",
--     "지도 교수"로 표시하며 고학번 학생이 먼저 표시되도록 한다.
SELECT
       S.STUDENT_NAME "학생 이름"
     , NVL(P.PROFESSOR_NAME, '지도 교수 미지정') "지도 교수"
  FROM TB_STUDENT S
  LEFT OUTER JOIN TB_PROFESSOR P ON(S.COACH_PROFESSOR_NO = P.PROFESSOR_NO)
  JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '서반아어학과'
 ORDER BY S.ENTRANCE_DATE;

-- 15. 휴학생이 아닌 학생 중 평점이 4.0 이상인 학생을 찾아 그 학생의 학번, 이름,
--     학과 이름, 평점을 출력하는 SQL 문을 작성하시오.
-- 방법1.
-- 1. 평점이 4.0 이상인 학생 조회
SELECT
       AVG(POINT)
  FROM TB_GRADE
 GROUP BY STUDENT_NO
HAVING AVG(POINT) >= 4.0;

-- 2. 1에 해당하는 휴학생이 아닌 학생 중 정보 조회
SELECT
       STUDENT_NO 학번
     , S.STUDENT_NAME 이름
     , D.DEPARTMENT_NAME "학과 이름"
     , AVG(G.POINT) 평점
  FROM TB_STUDENT S
 -- JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 -- JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
  JOIN TB_GRADE G USING(STUDENT_NO)
 WHERE S.ABSENCE_YN = 'N'
 GROUP BY STUDENT_NO, S.STUDENT_NAME, D.DEPARTMENT_NAME
HAVING AVG(G.POINT) IN (SELECT
                               AVG(G2.POINT)
                          FROM TB_GRADE G2
                         GROUP BY G2.STUDENT_NO
                        HAVING AVG(G2.POINT) >= 4.0)
 ORDER BY 1;

-- 방법2.
SELECT
       STUDENT_NO 학번
     , STUDENT_NAME 이름
     , DEPARTMENT_NAME "학과 이름"
     , AVG(POINT) 평점
  FROM TB_STUDENT
  JOIN TB_DEPARTMENT USING(DEPARTMENT_NO)
  JOIN TB_GRADE USING(STUDENT_NO)
 WHERE ABSENCE_YN = 'N'
 GROUP BY STUDENT_NO, STUDENT_NAME, DEPARTMENT_NAME
HAVING AVG(POINT) >= 4.0
 ORDER BY 1;

-- 16. 환경조경학과 전공 과목들의 과목 별 평점을 파악할 수 있는 SQL 문을 작성하시오.
SELECT
       C.CLASS_NO
     , C.CLASS_NAME
     , AVG(G.POINT)
  FROM TB_CLASS C
 -- JOIN TB_DEPARTMENT D ON(C.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
  JOIN TB_GRADE G ON(C.CLASS_NO = G.CLASS_NO)
 WHERE D.DEPARTMENT_NAME = '환경조경학과'
   AND C.CLASS_TYPE LIKE '전공%'
 GROUP BY C.CLASS_NO, C.CLASS_NAME
 ORDER BY 1;

-- 17. 춘 기술대학교에 다니고 있는 최경희 학생과 같은 과 학생들의 이름과 주소를
--     출력하는 SQL 문을 작성하시오.
-- 1. 최경의 학생의 과 조회
SELECT
       D.DEPARTMENT_NAME
  FROM TB_DEPARTMENT D
 -- JOIN TB_STUDENT S ON(D.DEPARTMENT_NO = S.DEPARTMENT_NO)
  JOIN TB_STUDENT S USING(DEPARTMENT_NO)
 WHERE S.STUDENT_NAME = '최경희'; -- 생태시스템공학과

-- 2. 1에 해당하는 학생들의 이름과 주소 조회
SELECT
       S.STUDENT_NAME
     , S.STUDENT_ADDRESS
  FROM TB_STUDENT S
 -- JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = (SELECT
                                   D2.DEPARTMENT_NAME
                              FROM TB_DEPARTMENT D2
                              JOIN TB_STUDENT S2 USING(DEPARTMENT_NO)
                             WHERE S2.STUDENT_NAME = '최경희');

-- 18. 국어국문학과에서 총 평점이 가장 높은 학생의 이름과 학번을 표시하는 SQL 문을
--     작성하시오.
-- 1. 국어국문학과 학생들 평점 조회
SELECT
       STUDENT_NO
     , S.STUDENT_NAME
     , AVG(G.POINT)
  FROM TB_STUDENT S
 -- JOIN TB_GRADE G ON(S.STUDENT_NO = G.STUDENT_NO)
  JOIN TB_GRADE G USING(STUDENT_NO)
 -- JOIN TB_DEPARTMENT D ON(S.DEPARTMENT_NO = D.DEPARTMENT_NO)
  JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
 WHERE D.DEPARTMENT_NAME = '국어국문학과'
 GROUP BY STUDENT_NO, S.STUDENT_NAME
 ORDER BY 3 DESC;

-- 2. 평점이 가장 높은 학생 구하기
-- 2-1. ROWNUM 이용
SELECT
       ROWNUM
     , V.STUDENT_NO
     , V.STUDENT_NAME
  FROM (SELECT
               STUDENT_NO
             , S.STUDENT_NAME
             , AVG(G.POINT)
          FROM TB_STUDENT S
          JOIN TB_GRADE G USING(STUDENT_NO)
          JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
         WHERE D.DEPARTMENT_NAME = '국어국문학과'
         GROUP BY STUDENT_NO, S.STUDENT_NAME
         ORDER BY 3 DESC
       ) V
 WHERE ROWNUM = 1;

-- 2-2. RANK() OVER 이용
SELECT
       V.STUDENT_NO
     , V.STUDENT_NAME
  FROM (SELECT
               STUDENT_NO
             , S.STUDENT_NAME
             , AVG(G.POINT)
             , RANK() OVER(ORDER BY AVG(G.POINT) DESC) 순위
          FROM TB_STUDENT S
          JOIN TB_GRADE G USING(STUDENT_NO)
          JOIN TB_DEPARTMENT D USING(DEPARTMENT_NO)
         WHERE D.DEPARTMENT_NAME = '국어국문학과'
         GROUP BY STUDENT_NO, S.STUDENT_NAME
       ) V
 WHERE V.순위 = 1;

-- 19. 춘 기술대학교의 "환경조경학과"가 속한 같은 계열 학과들의 학과 별 전공과목 평점을
--     파악하기 위한 적절한 SQL 문을 찾아내시오. 단, 출력헤더는 "계열 학과명",
--     "전공 평점"으로 표시되도록 하고, 평점은 소수점 한 자리까지만 반올림하여
--     표시되도록 한다.
-- 1. 환경조경학과가 속한 계열 조회
SELECT
       CATEGORY
  FROM TB_DEPARTMENT
 WHERE DEPARTMENT_NAME = '환경조경학과'; -- 자연과학

-- 2. 1에 해당하는 학과 조회
SELECT
       DEPARTMENT_NAME
  FROM TB_DEPARTMENT
 WHERE CATEGORY = (SELECT
                          CATEGORY
                     FROM TB_DEPARTMENT
                    WHERE DEPARTMENT_NAME = '환경조경학과')
 ORDER BY 1;

-- 3. 2에 해당하는 전공과목 평점 조회
SELECT
       D.DEPARTMENT_NAME "계열 학과명"
     , ROUND(AVG(G.POINT), 1) "전공 평점"
  FROM TB_DEPARTMENT D
 -- JOIN TB_CLASS C ON(D.DEPARTMENT_NO = C.DEPARTMENT_NO)
  JOIN TB_CLASS C USING(DEPARTMENT_NO)
 -- JOIN TB_GRADE G ON(C.CLASS_NO = G.CLASS_NO)
  JOIN TB_GRADE G USING(CLASS_NO)
 WHERE C.CLASS_TYPE LIKE '전공%'
 GROUP BY D.DEPARTMENT_NAME
HAVING DEPARTMENT_NAME IN (SELECT
                                  DEPARTMENT_NAME
                             FROM TB_DEPARTMENT
                            WHERE CATEGORY = (SELECT
                                                     CATEGORY
                                                FROM TB_DEPARTMENT
                                               WHERE DEPARTMENT_NAME = '환경조경학과'))
 ORDER BY 1;
