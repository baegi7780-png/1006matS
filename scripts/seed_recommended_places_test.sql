-- 지도 추천 마커 테스트 데이터 (실제 장소 / 가상 리뷰)
-- 추천 점수는 실제 이용자의 평가가 아닌 테스트용 5점입니다.
-- 기존 리뷰와 스키마를 수정하지 않으며 같은 테스트 리뷰를 중복 추가하지 않습니다.
USE motjip_db;
SET NAMES utf8mb4;
START TRANSACTION;

INSERT INTO reviews
    (place_id, place_name, latitude, longitude, member_id,
     rating, revisit, content, tags, image_url)
SELECT p.place_id, p.place_name, p.latitude, p.longitude, m.member_id,
       5, 1,
       '[MAP_RECOMMEND_TEST_20261006] 지도 추천 표시 확인용 가상 리뷰입니다. 실제 방문 후기나 실제 평점이 아닙니다.',
       '테스트용,추천마커', NULL
FROM (
    SELECT 10551889 AS place_id, '송정삼대국밥' AS place_name,
           35.15557363642001 AS latitude, 129.0584983963701 AS longitude
    UNION ALL SELECT 830551376, '라멘야', 35.15687272922043, 129.06117011701247
    UNION ALL SELECT 26781763, '고기굽는남자 서면점', 35.1571014047599, 129.061500686073
    UNION ALL SELECT 2137238065, '83해치', 35.1580061934798, 129.061075821305
    UNION ALL SELECT 1267334650, '칸다소바 부산서면점', 35.1581645215946, 129.062150788192
    UNION ALL SELECT 26772618, '서면밀면', 35.15800469892669, 129.06248691761562
) AS p
JOIN members m ON m.member_id = (
    SELECT MIN(member_id) FROM members WHERE email_id = 'baegi7780@gmail.com'
)
WHERE NOT EXISTS (
    SELECT 1 FROM reviews r
    WHERE r.place_id = p.place_id
      AND r.member_id = m.member_id
      AND r.content LIKE '[MAP_RECOMMEND_TEST_20261006]%'
);

COMMIT;

SELECT review_id, place_id, place_name, latitude, longitude, rating
FROM reviews
WHERE content LIKE '[MAP_RECOMMEND_TEST_20261006]%'
ORDER BY review_id;

-- 추후 제거 시 위 고유 표시가 붙은 테스트 리뷰 6건만 대상으로 별도 확인 후 제거합니다.
