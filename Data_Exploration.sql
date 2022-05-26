/*
This is a data cleaning project in sql, the dataset used is the 
nashvile data housing gotten from kaggle repository
*/

--standardize date format for the column 'SaleDate'
select SaleDate
from PortfolioProject..HousingData 

alter table HousingData
add SaleDateConverted Date

update HousingData
set SaleDateConverted = convert(Date,SaleDate)

select top 10 * from HousingData

--populate property address column where it is null
/*join table to itself to help filter rows with the same parcelID where one or

*/
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress
from PortfolioProject..HousingData a 
join PortfolioProject..HousingData b 
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<>b.[UniqueID ]
	 where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..HousingData a
join PortfolioProject..HousingData b 
     on a.ParcelID = b.ParcelID
	 and a.[UniqueID ]<> b.[UniqueID ]
	 where a.PropertyAddress is null


/*
Splitting address into address, city and state columns using 
Substring method
*/

select
substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) as Address
from PortfolioProject..HousingData

--creaate two new columns
alter table HousingData
add Property_Address nvarchar(255);

--check to see if the table has been updated with the columns
select Property_Address
from PortfolioProject..HousingData

--update the columns with respective data
update HousingData
set Property_Address = substring(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)


alter table HousingData
add City nvarchar(255);

--confirming  the table has been updated with the columns
select City 
from PortfolioProject..HousingData

--update the columns with respective data
update HousingData
set City = substring(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, len(PropertyAddress)) 

--confirming  the table has been updated with the columns
select Property_Address, City 
from HousingData


--Splitting OwnerAddress into address, city and state using Parsename
select
parsename(replace(OwnerAddress, ',', '.'), 3),
parsename(replace(OwnerAddress, ',', '.'), 2),
parsename(replace(OwnerAddress, ',', '.'), 1)
from PortfolioProject..HousingData

alter table HousingData
add Owner_Address nvarchar(255);
update HousingData
set Owner_Address = parsename(replace(OwnerAddress, ',', '.'), 3)


alter table HousingData
add Owner_City nvarchar(255);
update HousingData
set Owner_City = parsename(replace(OwnerAddress, ',', '.'), 2)



alter table HousingData
add Owner_State nvarchar(255);
update HousingData
set Owner_State = parsename(replace(OwnerAddress, ',', '.'), 1)


select top 10 *, Owner_Address, Owner_City,Owner_State 
from HousingData

select distinct(SoldAsVacant), count(SoldAsVacant)
from PortfolioProject..HousingData
group by SoldAsVacant
order by 2

update HousingData
set SoldAsVacant = 
      case when SoldAsVacant = 'Y' then 'Yes'
	       when SoldAsVacant = 'N' then 'No' 
		   Else SoldAsVacant
		   END


--Remove duplicates
with RowNumCTE as(
select *,
       row_number() over (
	   partition by ParcelID, PropertyAddress,
	                SalePrice,SaleDate,
					LegalReference
					order by UniqueID
					) row_num

from PortfolioProject..HousingData
)
delete from RowNumCTE
where row_num > 1

--delete unused columns
alter table HousingData
drop column OwnerAddress, TaxDistrict,
            PropertyAddress, SaleDate 
