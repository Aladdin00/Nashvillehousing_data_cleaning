/* 

Cleaning Data in SQL Queries


*/
 


 Select *
 FROM [project 1].dbo.NashvilleHousing


-- Standardize Data Fromat


 Select SaleDateConverted, CONVERT (Date,SaleDate)
 FROM [project 1].dbo.NashvilleHousing


 UPDATE NashvilleHousing
 SET SaleDate = CONVERT(Date,SaleDate)


 ALTER TABLE NashvilleHousing
 ADD SaleDateConverted Date;


 UPDATE NashvilleHousing
 SET SaleDateConverted = CONVERT(Date,SaleDate)


 -- Populate Property Address data

 SELECT *
 FROM [project 1].dbo.NashvilleHousing
-- WHERE PropertyAddress is null
 ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [project 1].dbo.NashvilleHousing a
JOIN [project 1].dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


UPDATE a
SET PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM [project 1].dbo.NashvilleHousing a
JOIN [project 1].dbo.NashvilleHousing b
   ON a.ParcelID = b.ParcelID
   AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null



-- Breaking out address into Individual Columns (Address, City, State)


 SELECT PropertyAddress
 FROM [project 1].dbo.NashvilleHousing
 --WHERE PropertyAddress is null
 --ORDER BY ParcelID

 SELECT 
 SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
 , SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress)+1,LEN(propertyaddress)) as Address
 FROM [project 1].dbo.NashvilleHousing


 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress NVARCHAR(255);


 UPDATE NashvilleHousing
 SET PropertySplitAddress =  SUBSTRING(propertyaddress, 1, CHARINDEX(',', PropertyAddress)-1)



 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity NVARCHAR(255);


 UPDATE NashvilleHousing
 SET PropertySplitCity = SUBSTRING(propertyaddress, CHARINDEX(',', PropertyAddress)+1,LEN(propertyaddress))

 SELECT * 
 FROM [project 1].dbo.NashvilleHousing





 SELECT OwnerAddress
 FROM [project 1].dbo.NashvilleHousing



SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM [project 1].dbo.NashvilleHousing


 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress NVARCHAR(255);


 UPDATE NashvilleHousing
 SET OwnerSplitAddress =  PARSENAME(REPLACE(OwnerAddress,',','.'),3)



 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity NVARCHAR(255);


 UPDATE NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

  ALTER TABLE NashvilleHousing
 ADD OwnerSplitState NVARCHAR(255);


 UPDATE NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



 SELECT *
 FROM [project 1].dbo.NashvilleHousing



 -- Change Y and N to Yes and No in "Sold as vacant" field


 SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
 FROM [project 1].dbo.NashvilleHousing
 GROUP BY SoldAsVacant
 ORDER BY 2



 SELECT SoldAsVacant
 , CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END
 FROM [project 1].dbo.NashvilleHousing

  UPDATE NashvilleHousing
  SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
        When SoldAsVacant = 'N' THEN 'No'
        ELSE SoldAsVacant
        END


-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *,
ROW_NUMBER() OVER(
 PARTITION BY ParcelID,
              PropertyAddress,
              SalePrice,
              SaleDate,
              LegalReference
ORDER BY      UniqueID
                 ) row_num

FROM [project 1].dbo.NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num >1
ORDER BY PropertyAddress


-- Delete Unused Columns


SELECT *
FROM [project 1].dbo.NashvilleHousing


ALTER TABLE [project 1].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [project 1].dbo.NashvilleHousing
DROP COLUMN SaleDate