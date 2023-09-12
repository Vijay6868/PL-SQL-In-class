-- procedure to delete artist
create or replace procedure delete_artist
(
    artist_id in number
) as
contract_status w_artist.contractstatus%type;

begin
select contractstatus into contract_status from w_artist
where artistid = artist_id;

if contract_status = 'signed' then 
    dbms_output.put_line('cannot delete signed artist');
else
	delete from w_artist where artistid = artist_id;
	commit;
	dbms_output.put_line('artist deleted successfully');
end if;
end delete_artist;




CREATE OR REPLACE PROCEDURE UPDATE_ARTIST 
(
  ARTIST_ID IN NUMBER 
, ARTIST_FEE IN NUMBER 
, ARTIST_NAME IN VARCHAR2 
, ARTIST_RANKING IN NUMBER 
, ARTIST_GENRE IN NUMBER 
, CONTRACT_STATUS IN VARCHAR2 
) AS 
BEGIN

select * FROM w_artist

where artistid = artist_id;
    if contractStatus != 'signed' and contract_status = 'released' then
         dbms_output.put_line('only artists with a contract status of unsigned can be updated tp signed');
    else if contractStatus = 'signed' and contract_status = 'released' then
        delete from w_artistStage where artistid= artist_id;
    else if contractStatus != 'unsigned' and contract_status = 'signed' then
        dbms_output.put_line('only artists with a contract status of unsigned can be updated tp signed');
    else
        update w_artist
        set ranking = artist_ranking
       where artistid = artist_id;
       commit;
       dbms_output.put_line('artist updated successfully');
    end if;
    
END UPDATE_ARTIST;



CREATE OR REPLACE PROCEDURE DELETE_CONCERT 
(
  CONCERT_ID IN NUMBER 
) AS concert_status w_concert.status%TYPE;
BEGIN
select status into concert_status from w_concert 
where concertid = concert_id;

if concert_status = 'confirmed' then
    dbms_output.put_line('cannot delete a confirmed concert');
else
    delete from w_concert where concertid = concert_id;
    commit;
            dbms_output.put_line('concert deleted succesfully');
end if;
  NULL;
END DELETE_CONCERT;



CREATE OR REPLACE PROCEDURE DELETE_CUSTOMER 
(
  CUSTOMER_ID IN NUMBER 
) AS booking_status w_booking.staus%type;
BEGIN
select status into booking_status from w_booking where customerid = customer_id;
if booking_status = 'unpaid' then
    dbms_output.put_line('cannot delete customer who still has unpaid bookings');
else
    delete from w_booking where customerid = customer_id;
    dbms_output.put_line('customer deleted successfully');
end if;
  NULL;
END DELETE_CUSTOMER;



CREATE OR REPLACE PROCEDURE UPDATE_CUSTOMER 
(
  CUSTOMER_ID IN NUMBER 
, FIRST_NAME IN VARCHAR2 
, LAST_NAME IN VARCHAR2 
, STREET_ADDRESS IN VARCHAR2 
, C_CITY IN VARCHAR2 
, COUNTRY_ID IN NUMBER 
, PHONE_NUMBER IN VARCHAR2 
, CREDIT_STATUS IN VARCHAR2
) AS c_status w_customer.creditstatus%TYPE;
BEGIN
select creditstatus INTO c_status from w_customer where customerid = customer_id;
if credit_status = 'bad' and c_status = 'good' then
   delete from w_booking where customerid = customer_id;
    delete from  w_customer where customerid = customer_id;

else
    update w_customer 
    set firstname = first_name,
            lastname = last_name,
            streetAdress = streed_address,
            city = c_city,
            countryid = country_id,
            phoneNumber = phone_number,
            creditStatus = credit_status,
            where customerid = customer_id;
            commit;
            dbms_output.put_line('Customer updated successfully');
end if;

  NULL;
END UPDATE_CUSTOMER;
