CREATE OR REPLACE PROCEDURE UPDATE_COUNTRY (
    COUNTRY_ID NUMBER,
    COUNTRY_NAME VARCHAR2)
    AS  LINE_COUNT NUMBER(4);
        CURSOR UPDATECOUNTRY IS
            SELECT COUNTRYID FROM W_COUNTRY WHERE COUNTRYID = COUNTRY_ID
            UNION ALL
            SELECT COUNTRYID FROM W_CONCERT WHERE COUNTRYID = COUNTRY_ID;
    UPDATE_COUNTRY_ROW UPDATECOUNTRY%ROWTYPE;

BEGIN
    LINE_COUNT := 0;
    OPEN UPDATECOUNTRY;

        LOOP
            FETCH UPDATECOUNTRY
            INTO UPDATE_COUNTRY_ROW;
            EXIT WHEN UPDATECOUNTRY%NOTFOUND;
            LINE_COUNT := LINE_COUNT+1;
        END LOOP;
    IF LINE_COUNT>1 THEN
        DBMS_OUTPUT.PUT_LINE('Cannot change country name');
    ELSE
        UPDATE W_COUNTRY
        SET COUNTRYNAME = COUNTRY_NAME WHERE COUNTRYID = COUNTRY_ID;
        DBMS_OUTPUT.PUT_LINE('COUNTRY UPDATED SUCCESSFULLY');
    END IF;
CLOSE UPDATECOUNTRY;
END UPDATE_COUNTRY;



CREATE OR REPLACE PROCEDURE UPDATE_GENRE 
(
  GENRE_ID IN NUMBER,
  NEW_DESCRIPTION VARCHAR2
) AS LINE_COUNT NUMBER(4);
        CURSOR GENRE_CURSOR IS
            SELECT GENREID FROM W_STAGEGENRE WHERE GENREID = GENRE_ID
            UNION ALL
            SELECT GENREID FROM W_ARTIST WHERE GENREID = GENRE_ID;
        GENRE_ROW GENRE_CURSOR%ROWTYPE;
        
BEGIN
    LINE_COUNT := 0;
    OPEN GENRE_CURSOR;
        LOOP 
            FETCH GENRE_CURSOR INTO GENRE_ROW;
            EXIT WHEN GENRE_CURSOR%NOTFOUND;
            LINE_COUNT := LINE_COUNT +1;
         END LOOP;
         IF LINE_COUNT > 1 THEN
            DBMS_OUTPUT.PUT_LINE('CANNOT UPDATE GENRE NAME');
        ELSE
            UPDATE W_GENRE
            SET DESCRIPTION = NEW_DESCRIPTION
            WHERE GENREID = GENRE_ID;
             DBMS_OUTPUT.PUT_LINE('GENRE UPDATED SUCCESSFULLY ');
        END IF;
CLOSE GENRE_CURSOR;

END UPDATE_GENRE;

CREATE OR REPLACE PROCEDURE ONE_GENRE (
  GENRE_ID IN NUMBER) AS
  CURSOR GENRE_CURSOR IS
    SELECT * FROM W_GENRE WHERE GENREID = GENRE_ID;

  CURSOR OTHER_DETAILS_CURSOR IS
    SELECT
        S.STAGEID AS S_STAGEID,
        WAS.STAGEID AS WAS_STAGEID,
        A.ARTISTID AS A_ARTISTID,
        WAS.ARTISTID AS WAS_ARTISTID,
        C.CONCERTID AS C_CONCERTID,
        S.CONCERTID AS S_CONCERTID,
        C.VENUENAME AS C_VENUENAME,
        A.ARTISTNAME AS A_ARTISTNAME,
        S.STAGENAME AS S_STAGENAME,
        A.FEE AS A_FEE,
        A.RANKING AS A_RANKING
          
    FROM W_STAGE S, W_ARTIST A, W_ARTISTSTAGE WAS, W_CONCERT C
        WHERE S.STAGEID = WAS.STAGEID AND A.ARTISTID = WAS.ARTISTID 
        AND C.CONCERTID = S.CONCERTID AND A.GENREID = GENRE_ID;

  GENRE_ROW GENRE_CURSOR%ROWTYPE;
  OTHER_DETAILS_ROW OTHER_DETAILS_CURSOR%ROWTYPE;
  OTHER_DETAILS_ROW2 OTHER_DETAILS_CURSOR%ROWTYPE;

BEGIN
    OPEN GENRE_CURSOR;
        LOOP
            FETCH GENRE_CURSOR INTO GENRE_ROW;
            EXIT WHEN GENRE_CURSOR%NOTFOUND;
            DBMS_OUTPUT.PUT_LINE('THE GENRE DESCRIPTION IS : '||GENRE_ROW.DESCRIPTION);
            OPEN OTHER_DETAILS_CURSOR;
                LOOP
                    FETCH OTHER_DETAILS_CURSOR INTO OTHER_DETAILS_ROW;
                    EXIT WHEN OTHER_DETAILS_CURSOR%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE('STAGE NAME: '||OTHER_DETAILS_ROW.S_STAGENAME||' AT THE VENUE : '||OTHER_DETAILS_ROW.C_VENUENAME);
                END LOOP;

                LOOP 
                    FETCH OTHER_DETAILS_CURSOR INTO OTHER_DETAILS_ROW2;
                    EXIT WHEN OTHER_DETAILS_CURSOR%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE('ARTIST NAME: '||OTHER_DETAILS_ROW2.A_ARTISTNAME||' FEE: '||OTHER_DETAILS_ROW2.A_FEE||' RANKING: '||OTHER_DETAILS_ROW2.A_RANKING);
                END LOOP;
            CLOSE OTHER_DETAILS_CURSOR;
        OPEN OTHER_DETAILS_CURSOR;
            LOOP 
                    FETCH OTHER_DETAILS_CURSOR INTO OTHER_DETAILS_ROW2;
                    EXIT WHEN OTHER_DETAILS_CURSOR%NOTFOUND;
                    DBMS_OUTPUT.PUT_LINE('ARTIST NAME: '||OTHER_DETAILS_ROW2.A_ARTISTNAME||' FEE: '||OTHER_DETAILS_ROW2.A_FEE||' RANKING: '||OTHER_DETAILS_ROW2.A_RANKING);
                END LOOP;
        CLOSE OTHER_DETAILS_CURSOR;
        END LOOP;
    CLOSE GENRE_CURSOR;

END ONE_GENRE;



