CREATE DEFINER=`root`@`localhost` PROCEDURE `checkout`(
	IN userId integer,
    IN addressId integer,
    IN cardPart integer,
    IN orderId varchar(64),
    OUT email varchar(64),
    OUT firstName varchar(64)
)
checkout:BEGIN
	DECLARE totalPrice DECIMAL(10, 2);
	DECLARE totalTax DECIMAL(10, 2);
    
	SELECT
		SUM(C.fldQuantity * p.fldPrice),
        SUM(C.fldQuantity * p.fldtax)
	INTO
		totalPrice,
        totalTax
	FROM
		tblCart C
	INNER JOIN tblProduct P ON P.fldProduct_ID = C.fldProductId AND P.fldActive = 1
	WHERE 
		C.fldUserId = userId;
        
	SELECT
		fldFirstName,
		fldEmail
	INTO
		firstName,
        email
	FROM
		tblUser
	WHERE
		fldUser_ID = userId;
	
    IF ROW_COUNT() = 0 OR totalPrice IS NULL OR totalTax IS NULL THEN
        ROLLBACK;
        LEAVE checkout;
    END IF;

    START TRANSACTION;

		INSERT INTO 
			tblOrder(
				fldOrder_ID,
				fldUserId,
				fldAddressId,
				fldTotalPrice,
				fldTotalTax,
				fldCardPart
			)VALUES(
				orderId,
				userId,
				addressId,
				totalPrice,
				totalTax,
				cardPart
		);

		INSERT INTO
			tblorderitems(
				fldOrderId,
				fldProductId,
				fldQuantity,
				fldUnitPrice,
				fldUnitTax
			)SELECT
				orderId,
				C.fldProductId,
				C.fldQuantity,
				P.fldPrice,
				P.fldTax
			FROM
				tblCart C
			INNER JOIN tblProduct P ON P.fldProduct_ID = C.fldProductId AND P.fldActive = 1
			WHERE 
				C.fldUserId = userId;

		DELETE FROM
			tblCart
		WHERE 
			fldUserId = userId;

		COMMIT;
END