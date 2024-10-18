drop table if exists housing
create table housing 
(
	UniqueID serial primary key,
	ParcelID varchar(100) ,
	LandUse varchar(50) ,
	PropertyAddress varchar(200) ,
	SaleDate date ,
	SalePrice bigint,
	LegalReference varchar(200),
	SoldAsVacant varchar(5),
	OwnerName varchar(200) ,
	OwnerAddress varchar(200) ,
	Acreage numeric ,
	TaxDistrict varchar(200) ,
	LandValue numeric ,
	BuildingValue numeric ,
	TotalValue numeric ,
	YearBuilt numeric ,
	Bedrooms int ,
	FullBath int ,
	HalfBath int
)

now, we import the data into the table and check if it's been imported

select * from housing

Next step is data cleaning :

1.Same parcel Ids have multiple info with null value. we substitute null values with the original address

 							Checking Null Values
							
select a.uniqueid,a.parcelid,a.propertyaddress,a.uniqueid,
	   b.parcelid,b.propertyaddress 
from housing as a
join housing as b
				on a.parcelid = b.parcelid
				and	a.uniqueid <> b.uniqueid
		where a.propertyaddress is null

							Updating and cleaning null values
							
UPDATE housing AS a
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
FROM housing AS b
WHERE a.parcelid = b.parcelid
    AND a.uniqueid <> b.uniqueid
    AND a.propertyaddress IS NULL;
							Breaking down address into indivual columns
							
ALTER TABLE housing 
ADD COLUMN	property_address varchar(50)
	UPDATE housing
	set property_address = SUBSTRING( propertyaddress, 1, POSITION(',' in propertyaddress)-1 )

ALTER TABLE housing
ADD COLUMN property_city varchar(50);
	UPDATE housing
	SET property_city = SUBSTRING( propertyaddress, POSITION(',' in propertyaddress)+2 )



ALTER TABLE housing 
ADD COLUMN	owner_address varchar(50)
	UPDATE housing
	SET owner_address = SPLIT_PART(owneraddress,',',1)

ALTER TABLE housing 
ADD COLUMN	owner_city varchar(50)
	UPDATE housing
	SET owner_city = SPLIT_PART(owneraddress,',',2)
	
ALTER TABLE housing 
ADD COLUMN	owner_state varchar(50)
	UPDATE housing
	SET owner_state = SPLIT_PART(owneraddress,',',3)

select distinct(soldasvacant) from housing

update housing
set soldasvacant =  	
	case soldasvacant
		when 'Y' then 'Yes'
		when 'N' then 'No'
		when 'Yes' then 'Yes'
		else 'No'
	END

                        Remove Unused Columns
						
ALTER TABLE housing
DROP COLUMN propertyaddress, 
DROP COLUMN owneraddress

select * from housing
