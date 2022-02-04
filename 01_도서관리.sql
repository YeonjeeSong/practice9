-- 1. 4개 테이블에 포함된 데이터 건 수를 구하는 SQL 구문을 만드는 SQL 구문을 작성하시오.
SELECT 
       'SELECT COUNT(*) FROM '||TABLE_NAME||';' AS " "
  FROM  USER_TABLES UT;

-- 2. 4개 테이블의 구조를 파악하려고 한다. 제시된 결과처럼 TABLE_NAME,
--    COLUMN_NAME, DATA_TYPE, DATA_DEFAULT, NULLABLE, CONSTRAINT_NAME,
--    CONSTRAINT_TYPE, R_CONSTRAINT_NAME 값을 조회하는 SQL 구문을 작성하시오.
-- 2-1. 현재 이 계정이 가지고 있는 테이블 조회
SELECT
       UT.*
  FROM USER_TABLES UT;

-- 2-2. 테이블이 가지고 있는 컬럼들 조회
SELECT
       UTC.*
  FROM USER_TAB_COLUMNS UTC;

-- 2-3. 제약 조건 조회 - 제약 조건 이름 기준
SELECT
       UC.*
  FROM USER_CONSTRAINTS UC;

-- 2-4. 제약 조건 조회 - 테이블 컬럼 기준
SELECT
       UCC.*
  FROM USER_CONS_COLUMNS UCC;

-- 2-5. 현재 이 계정이 가지고 있는 컬럼들 조회
SELECT
       UTC.*
  FROM USER_TAB_COLS UTC;

-- 2-6. 테이블이 가지고 있는 컬럼들 중 원하는 컬럼, 제약 조건 조회
--SELECT
--       TABLE_NAME
--     , COLUMN_NAME
--     , DATA_TYPE
--     , DATA_DEFAULT
--     , NULLABLE
--     , CONSTRAINT_NAME
--     , CONSTRAINT_TYPE
--     , R_CONSTRAINT_NAME
--  FROM USER_TAB_COLS
--  LEFT JOIN USER_CONS_COLUMNS USING (TABLE_NAME, COLUMN_NAME) 
--  LEFT JOIN USER_CONSTRAINTS USING  (TABLE_NAME, CONSTRAINT_NAME)
-- ORDER BY 1;

SELECT
       UTC.TABLE_NAME
     , UTC.COLUMN_NAME
     , UTC.DATA_TYPE
     , UTC.DATA_DEFAULT
     , UTC.NULLABLE
     , UCC.CONSTRAINT_NAME
     , UC.CONSTRAINT_TYPE
     , UC.R_CONSTRAINT_NAME
  FROM USER_TAB_COLS UTC
  LEFT OUTER JOIN USER_CONS_COLUMNS UCC ON(UTC.TABLE_NAME = UCC.TABLE_NAME)
  LEFT OUTER JOIN USER_CONS_COLUMNS UCC ON(UTC.COLUMN_NAME = UCC.COLUMN_NAME)
  LEFT OUTER JOIN USER_CONSTRAINTS UC ON(UCC.TABLE_NAME = UC.TABLE_NAME)
  LEFT OUTER JOIN USER_CONSTRAINTS UC ON(UCC.CONSTRAINT_NAME = UC.CONSTRAINT_NAME)
 ORDER BY 1;

-- 3. 도서명이 25자 이상인 책 번호와 도서명을 화면에 출력하는 SQL 문을 작성하시오.
SELECT
       BOOK_NO
     , BOOK_NM
  FROM TB_BOOK
 WHERE BOOK_NM LIKE '_________________________%';

SELECT
       BOOK_NO
     , BOOK_NM
  FROM TB_BOOK
 WHERE LENGTH(BOOK_NM) >= 25;

-- 4. 휴대폰 번호가 '019'로 시작하는 김씨 성을 가진 작가를 이름순으로 정렬했을 때
--    가장 먼저 표시되는 작가 이름과 사무실 전화번호, 집 전화번호,
--    휴대폰 전화번호를 표시하는 SQL 구문을 작성하시오.
SELECT
       WRITER_NM
     , OFFICE_TELNO
     , HOME_TELNO
     , MOBILE_NO
  FROM TB_WRITER
 WHERE MOBILE_NO LIKE '019%'
   AND WRITER_NM LIKE '김%'
 ORDER BY 1;

-- 1. ROWNUM 이용
SELECT
       ROWNUM
     , V.WRITER_NM
     , V.OFFICE_TELNO
     , V.HOME_TELNO
     , V.MOBILE_NO
  FROM (SELECT
               WRITER_NM
             , OFFICE_TELNO
             , HOME_TELNO
             , MOBILE_NO
          FROM TB_WRITER
         WHERE MOBILE_NO LIKE '019%'
           AND WRITER_NM LIKE '김%'
         ORDER BY 1
       )V
 WHERE ROWNUM = 1;

-- 2. RANK() OVER 이용
SELECT
       V.WRITER_NM
     , V.OFFICE_TELNO
     , V.HOME_TELNO
     , V.MOBILE_NO
  FROM (SELECT
               WRITER_NM
             , OFFICE_TELNO
             , HOME_TELNO
             , MOBILE_NO
             , RANK() OVER(ORDER BY WRITER_NM) 순위
          FROM TB_WRITER
         WHERE MOBILE_NO LIKE '019%'
           AND WRITER_NM LIKE '김%'
       )V
 WHERE V.순위 = 1;

-- 5. 저작 형태가 "옮김"에 해당하는 작가들이 총 몇 명인지 계산하는
--    SQL 구문을 작성하시오. (결과 헤더는 "작가(명)"으로 표시되도록 할 것)
SELECT
       COUNT(DISTINCT W.WRITER_NM) "작가(명)"
  FROM TB_WRITER W
 -- JOIN TB_BOOK_AUTHOR BA ON(W.WRITER_NO = BA.WRITER_NO)
  JOIN TB_BOOK_AUTHOR BA USING(WRITER_NO)
 WHERE COMPOSE_TYPE = '옮김';

-- 6. 300권 이상 등록된 도서의 저작 형태 및 등록된 도서 수량을 표시하는
--    SQL 구문을 작성하시오.(저작 형태가 등록되지 않은 경우는 제외할 것)
SELECT
       COMPOSE_TYPE
     , COUNT(BOOK_NO)
  FROM TB_BOOK_AUTHOR
 WHERE COMPOSE_TYPE IS NOT NULL
 GROUP BY COMPOSE_TYPE
HAVING COUNT(BOOK_NO) >= 300;

-- 7. 가장 최근에 발간된 최신작 이름과 발행일자, 출판사 이름을 표시하는
--    SQL 구문을 작성하시오.
SELECT
       BOOK_NM
     , ISSUE_DATE
     , PUBLISHER_NM
  FROM TB_BOOK
 ORDER BY 2 DESC;

-- 1. ROWNUM 이용
SELECT
       ROWNUM
     , V.BOOK_NM
     , V.ISSUE_DATE
     , V.PUBLISHER_NM
  FROM (SELECT
               BOOK_NM
             , ISSUE_DATE
             , PUBLISHER_NM
          FROM TB_BOOK
         ORDER BY 2 DESC
       )V
 WHERE ROWNUM = 1;

-- 2. RANK() OVER 이용
SELECT
       V.BOOK_NM
     , V.ISSUE_DATE
     , V.PUBLISHER_NM
  FROM (SELECT
               BOOK_NM
             , ISSUE_DATE
             , PUBLISHER_NM
             , RANK() OVER(ORDER BY ISSUE_DATE DESC) 순위
          FROM TB_BOOK
       )V
 WHERE V.순위 = 1;

-- MAX 함수 사용
SELECT
       BOOK_NM
     , ISSUE_DATE
     , PUBLISHER_NM
  FROM TB_BOOK
 WHERE ISSUE_DATE = (SELECT
                            MAX(ISSUE_DATE)
                       FROM TB_BOOK);

-- 8. 가장 많은 책을 쓴 작가 3명의 이름과 수량을 표시하되, 많이 쓴 순서대로 표시하는
--    SQL 구문을 작성하시오. 단, 동명이인(同名異人) 작가는 없다고 가정한다.
--    (결과 헤더는 "작가 이름", "권 수"로 표시되도록 할 것)
SELECT
       W.WRITER_NM
     , COUNT(BOOK_NO)
  FROM TB_WRITER W
 -- JOIN TB_BOOK_AUTHOR BA ON(W.WRITER_NO = BA.WRITER_NO)
  JOIN TB_BOOK_AUTHOR BA USING(WRITER_NO)
 GROUP BY W.WRITER_NM
 ORDER BY 2 DESC;

-- 1. ROWNUM 이용
SELECT
       ROWNUM
     , V."작가 이름"
     , V."권 수"
  FROM (SELECT
               W.WRITER_NM "작가 이름"
             , COUNT(BOOK_NO) "권 수"
          FROM TB_WRITER W
          JOIN TB_BOOK_AUTHOR BA USING(WRITER_NO)
         GROUP BY W.WRITER_NM
         ORDER BY 2 DESC
       )V
 WHERE ROWNUM <= 3;

-- 2. RANK() OVER 이용
SELECT
       V."작가 이름"
     , V."권 수"
  FROM (SELECT
               W.WRITER_NM "작가 이름"
             , COUNT(BOOK_NO) "권 수"
             , RANK() OVER(ORDER BY COUNT(BOOK_NO) DESC) 순위
          FROM TB_WRITER W
          JOIN TB_BOOK_AUTHOR BA USING(WRITER_NO)
         GROUP BY W.WRITER_NM
       )V
 WHERE V.순위 <= 3;

-- 9. 작가 정보 테이블의 모든 등록일자 항목이 누락되어 있는 걸 발견하였다.
--    누락된 등록일자 값을 각 작가의 '최초 출판도서의 발행일과 동일한 날짜'로
--    변경시키는 SQL 구문을 작성하시오. (COMMIT 처리할 것)
UPDATE
       TB_WRITER W
   SET W.REGIST_DATE = (SELECT
                               MIN(B.ISSUE_DATE)
                          FROM TB_BOOK B
                          JOIN TB_BOOK_AUTHOR BA ON(B.BOOK_NO = BA.BOOK_NO)
                         WHERE W.WRITER_NO = BA.WRITER_NO);
-- 1,052개 행 이(가) 업데이트되었습니다.
COMMIT;

-- 10. 현재 도서저자 정보 테이블은 저서와 번역서를 구분 없이 관리하고 있다.
--     앞으로는 번역서는 따로 관리하려고 한다. 제시된 내용에 맞게
--     "TB_BOOK_TRANSLATOR" 테이블을 생성하는 SQL 구문을 작성하시오.
--     (Primary Key 제약 조건 이름은 "PK_BOOK_TRANSLATOR"로 하고,
--      Reference 제약 조건 이름은 "FK_BOOK_TRANSLATOR_01",
--      "FK_BOOK_TRANSLATOR_02"로 할 것)
CREATE TABLE TB_BOOK_TRANSLATOR(
    BOOK_NO VARCHAR2(10) NOT NULL,
    WRITER_NO VARCHAR2(10) NOT NULL,
    TRANS_LANG VARCHAR2(60),
    CONSTRAINT PK_BOOK_TRANSLATOR PRIMARY KEY(BOOK_NO, WRITER_NO),
    CONSTRAINT FK_BOOK_TRANSLATOR_01 FOREIGN KEY(BOOK_NO) REFERENCES TB_BOOK,
    CONSTRAINT FK_BOOK_TRANSLATOR_02 FOREIGN KEY(WRITER_NO) REFERENCES TB_WRITER
);
-- Table TB_BOOK_TRANSLATOR이(가) 생성되었습니다.

COMMENT ON COLUMN TB_BOOK_TRANSLATOR.BOOK_NO IS '도서 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.WRITER_NO IS '작가 번호';
COMMENT ON COLUMN TB_BOOK_TRANSLATOR.TRANS_LANG IS '번역 언어';

-- 11. 도서 저작 형태(compose_type)가 '옮김', '역주', '편역', '공역'에 해당하는
--     데이터는 도서 저자 정보 테이블에서 도서 역자 정보 테이블(TB_BOOK_ TRANSLATOR)로
--     옮기는 SQL 구문을 작성하시오. 단, "TRANS_LANG" 컬럼은 NULL 상태로 두도록 한다.
--     (이동된 데이터는 더 이상 TB_BOOK_AUTHOR 테이블에 남아 있지 않도록 삭제할 것)
INSERT
  INTO TB_BOOK_TRANSLATOR BT
(
  BT.BOOK_NO
, BT.WRITER_NO
)
(
  SELECT
         BA.BOOK_NO
       , BA.WRITER_NO
    FROM TB_BOOK_AUTHOR BA
   WHERE BA.COMPOSE_TYPE IN('옮김', '역주', '편역', '공역')
);
-- 169개 행 이(가) 삽입되었습니다.

DELETE
  FROM TB_BOOK_AUTHOR
 WHERE COMPOSE_TYPE IN('옮김', '역주', '편역', '공역');
-- 169개 행 이(가) 삭제되었습니다.

COMMIT;

-- 12. 2007년도에 출판된 번역서 이름과 번역자(역자)를 표시하는 SQL 구문을 작성하시오.
SELECT
       B.BOOK_NM
     , W.WRITER_NM
  FROM TB_BOOK B
  JOIN TB_BOOK_TRANSLATOR BT ON(B.BOOK_NO = BT.BOOK_NO)
  JOIN TB_WRITER W ON(BT.WRITER_NO = W.WRITER_NO)
 WHERE TO_CHAR(B.ISSUE_DATE, 'RRRR') = '2007';

-- 13. 12번 결과를 활용하여 대상 번역서들의 출판일을 변경할 수 없도록 하는 뷰를
--     생성하는 SQL 구문을 작성하시오. (뷰 이름은 "VW_BOOK_TRANSLATOR"로 하고
--     도서명, 번역자, 출판일이 표시되도록 할 것)

-- <시스템 계정으로 실행>
GRANT CREATE VIEW TO C##BOOK;

CREATE OR REPLACE VIEW VW_BOOK_TRANSLATOR
AS
SELECT BOOK_NM
     , WRITER_NM 
  FROM TB_WRITER
  JOIN TB_BOOK_TRANSLATOR USING (WRITER_NO)
  JOIN TB_BOOK USING (BOOK_NO)
 WHERE TO_CHAR(ISSUE_DATE, 'RRRR') = '2007'
  WITH CHECK OPTION;

-- 14. 새로운 출판사(춘 출판사)와 거래 계약을 맺게 되었다. 제시된 다음 정보를 입력하는
--     SQL 구문을 작성하시오. (COMMIT 처리할 것)
INSERT
  INTO TB_PUBLISHER
(
  PUBLISHER_NM
, PUBLISHER_TELNO
, DEAL_YN
)
VALUES
(
  '춘 출판사'
, '02-6710-3737'
, DEFAULT
);

COMMIT;

-- 15. 동명이인(同名異人) 작가의 이름을 찾으려고 한다. 이름과 동명이인 숫자를 표시하는
--     SQL 구문을 작성하시오.
SELECT
       WRITER_NM
     , COUNT(*)
  FROM TB_WRITER
 GROUP BY WRITER_NM
 HAVING COUNT(*) > 1;

-- 16. 도서의 저자 정보 중 저작 형태(compose_type)가 누락된 데이터들이 적지 않게
--     존재한다. 해당 컬럼이 NULL인 경우 '지음'으로 변경하는 SQL 구문을 작성하시오.
--     (COMMIT 처리할 것)
UPDATE
       TB_BOOK_AUTHOR
   SET COMPOSE_TYPE = '지음'
 WHERE COMPOSR_TYPE IS NULL;

COMMIT;

-- 17. 서울지역 작가 모임을 개최하려고 한다. 사무실이 서울이고, 사무실 전화 번호 국번이
--     3자리인 작가의 이름과 사무실 전화 번호를 표시하는 SQL 구문을 작성하시오.
SELECT
       WRITER_NM
     , OFFICE_TELNO
  FROM TB_WRITER
 WHERE OFFICE_TELNO LIKE '02%'
   AND OFFICE_TELNO LIKE '___________';

SELECT
       WRITER_NM
     , OFFICE_TELNO
  FROM TB_WRITER
 WHERE OFFICE_TELNO LIKE '02-___-%';

-- 18. 2006년 1월 기준으로 등록된 지 31년 이상 된 작가 이름을 이름순으로 표시하는
--     SQL 구문을 작성하시오.
SELECT
       WRITER_NM
     , REGIST_DATE
  FROM TB_WRITER
 WHERE MONTHS_BETWEEN('060101', REGIST_DATE) >= 372
 ORDER BY 1;

-- 19. 요즘 들어 다시금 인기를 얻고 있는 '황금가지' 출판사를 위한 기획전을 열려고 한다.
--     '황금가지' 출판사에서 발행한 도서 중 재고 수량이 10권 미만인 도서명과 가격,
--     재고상태를 표시하는 SQL 구문을 작성하시오. 재고 수량이 5권 미만인 도서는
--     '추가주문필요'로, 나머지는 '소량보유'로 표시하고,
--     재고수량이 많은 순, 도서명 순으로 표시되도록 한다.
SELECT
       BOOK_NM
     , PRICE
     , STOCK_QTY
     , CASE
         WHEN STOCK_QTY < 5 THEN '추가주문필요'
         ELSE '소량보유'
       END AS 재고상태
  FROM TB_BOOK
 WHERE PUBLISHER_NM = '황금가지'
   AND STOCK_QTY < 10
 ORDER BY 3 DESC, 1;

-- 20. '아타트롤' 도서 작가와 역자를 표시하는 SQL 구문을 작성하시오.
--     (결과 헤더는 '도서명', '저자', '역자'로 표시할 것)
SELECT
       B.BOOK_NM 도서명
     , W1.WRITER_NM 저자
     , W2.WRITER_NM 역자
  FROM TB_BOOK B
  JOIN TB_BOOK_AUTHOR BA ON(B.BOOK_NO = BA.BOOK_NO)
  JOIN TB_WRITER W1 ON(BA.WRITER_NO = W1.WRITER_NO)
  JOIN TB_BOOK_TRANSLATOR BT ON(B.BOOK_NO = BT.BOOK_NO)
  JOIN TB_WRITER W2 ON(BT.WRITER_NO = W2.WRITER_NO)
 WHERE B.BOOK_NM = '아타트롤';

-- 21. 현재 기준으로 최초 발행일로부터 만 30년이 경과되고, 재고 수량이 90권 이상인
--     도서에 대해 도서명, 재고 수량, 원래 가격, 20% 인하 가격을 표시하는 SQL 구문을
--     작성하시오. (결과 헤더는 "도서명", "재고 수량", "가격(Org)", "가격(New)"로
--     표시할 것. 재고 수량이 많은 순, 할인 가격이 높은 순,
--     도서명 순으로 표시되도록 할 것)
SELECT
       BOOK_NM 도서명
     , STOCK_QTY "재고 수량"
     , TO_CHAR(PRICE, '99,999') "가격(Org)"
     , TO_CHAR(PRICE * 0.8, '99,999') "가격(New)"
  FROM TB_BOOK
 WHERE MONTHS_BETWEEN(SYSDATE, ISSUE_DATE) >= 360
   AND STOCK_QTY >= 90
 ORDER BY 2 DESC, 4 DESC, 1;
