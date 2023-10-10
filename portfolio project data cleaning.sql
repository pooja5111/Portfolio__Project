/* Cleaning Data in SQL Queries*/

select* 
from portfolio_project..NashvilleHousing


--Standarize Data Format 
select SaleDate, CONVERT(Date,SaleDate)
from portfolio_project..NashvilleHousing

update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateCoverted Date;

update NashvilleHousing
SET SaleDateCoverted = CONVERT(Date,SaleDate)

select SaleDateCoverted
from portfolio_project..NashvilleHousing


-- Populate property Address data 
 select*
 from portfolio_project..NashvilleHousing
 where PropertyAddress is null
 order by ParcelID

 select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
 from portfolio_project..NashvilleHousing as a
 Join portfolio_project..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	where a.PropertyAddress is null

update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from portfolio_project..NashvilleHousing as a
Join portfolio_project..NashvilleHousing as b
    on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual columns (address,city,state)

 select PropertyAddress
 from portfolio_project..NashvilleHousing
 --where PropertyAddress is null
 --order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) -- charindex is used of to search within a particular col, so in this query substring is staring from 1st index and going untill the comma 
 , SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) AS Address

from portfolio_project..NashvilleHousing

 
ALTER TABLE NashvilleHousing
Add PropertySplitAddress nvarchar(255);

update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
Add PropertySplitCity nvarchar(255);

update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1,LEN(PropertyAddress)) 

select*
from portfolio_project..NashvilleHousing



--ALternative way to separate the address 

select OwnerAddress
from portfolio_project..NashvilleHousing

select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)-- Parsename does everything from backwards
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)

from portfolio_project..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnertySplitAddress nvarchar(255);

update NashvilleHousing
SET OwnertySplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3) 


ALTER TABLE NashvilleHousing
Add OwnerSplitCity nvarchar(255);

update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState nvarchar(255);

update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1) 


select*
from portfolio_project..NashvilleHousing


-- change Y and N to Yes and NO in "Sold as vacant" field

select Distinct(SoldAsVacant), count(SoldAsVacant)
from portfolio_project..NashvilleHousing
group by SoldAsVacant
order by 2



select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from portfolio_project..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END





-- Remove Duplicates
WITH RowNumCTE AS (
select*,
   ROW_NUMBER() OVER (  -- ROW_NUMBER() is a function in the database language that assigns a unique sequential number to each row in the result set of a query
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				   UniqueID
				   ) as row_num


from portfolio_project..NashvilleHousing
--Order by ParcelID
)

select*
from RowNumCTE
where row_num >1




-- Remove Duplicates
WITH RowNumbCTE AS (
select*,
   ROW_NUMBER() OVER (  -- ROW_NUMBER() is a function in the database language that assigns a unique sequential number to each row in the result set of a query
   PARTITION BY ParcelID,
                PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY 
				   UniqueID
				   ) as row_num


from portfolio_project..NashvilleHousing
--Order by ParcelID
)
select*
from RowNumbCTE
where row_num >1

