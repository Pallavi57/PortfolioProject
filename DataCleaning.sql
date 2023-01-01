/* Data Cleaning Project
1.Date Formating
2.Populating Property Address with same ParcelID
3.Breaking Property Address into more Useable format--Using SUBSTRING
4.Breaking Owner Address --Using ParseName
5.Update SoldAsVacant Column
6.Deleting Duplicates--USING CTE
7.Deleting Unused Columns*/

Select *
From PortfolioProject..NashvilleHousing;

---1. Date Formating


--SELECT  saledate, FORMAT (SaleDate, 'yyyy-mm-dd') as SaleDate
--From PortfolioProject..NashvilleHousing

Alter TABLE PortfolioProject..NashvilleHousing
ADD SaleDateFormatted Date;

Update PortfolioProject..NashvilleHousing
SET SaleDateFormatted =CONVERT(Date,SaleDate)


--2. Property Address 

--Select *
--From PortfolioProject..NashvilleHousing
--Where PropertyAddress is null
--Order by ParcelID

Select a.ParcelID,a.PropertyAddress, b.ParcelID,b.PropertyAddress ,ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null



--3.Breaking Address


--Select 
--Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address
--, Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as CITY 
--From PortfolioProject..NashvilleHousing

Alter TABLE PortfolioProject..NashvilleHousing
ADD Property_Address NVarCHar(255);

Update PortfolioProject..NashvilleHousing
SET Property_Address =Substring(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

Alter TABLE PortfolioProject..NashvilleHousing
ADD PropertyCITY NVarCHar(255);

Update PortfolioProject..NashvilleHousing
SET PropertyCITY =Substring(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) 




--4. Split Owner Address using Parsename


--Select
--PARSENAME(Replace(OwnerAddress,',','.'),3),
--PARSENAME(Replace(OwnerAddress,',','.'),2),
--PARSENAME(Replace(OwnerAddress,',','.'),1)
--From PortfolioProject..NashvilleHousing


--Owner Address
Alter TABLE PortfolioProject..NashvilleHousing
ADD Owner_Address NVarCHar(255);

Update PortfolioProject..NashvilleHousing
SET Owner_Address =PARSENAME(Replace(OwnerAddress,',','.'),3)

--Owner City
Alter TABLE PortfolioProject..NashvilleHousing
ADD Owner_CITY NVarCHar(255);

Update PortfolioProject..NashvilleHousing
SET Owner_CITY =PARSENAME(Replace(OwnerAddress,',','.'),2)

--Owner State
Alter TABLE PortfolioProject..NashvilleHousing
ADD Owner_State NVarCHar(255);

Update PortfolioProject..NashvilleHousing
SET Owner_State =PARSENAME(Replace(OwnerAddress,',','.'),1)



--5.SoldAsVacant Column update (Update Y to YES, N to NO)



Update PortfolioProject..NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y'  Then 'YES'
       WHEN SoldAsVacant = 'N'  Then 'NO'
	   Else SoldAsVacant
	   END

Select SoldAsVacant
From PortfolioProject..NashvilleHousing


Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2


--6.Remove Duplicates

With RowNumCTE as(
Select *,
       ROW_NUMBER() Over
	   (Partition By ParcelID,
	   PropertyAddress,
	   SaleDate,
	   SalePrice,
	   LegalReference
	   Order By UniqueID
	   )row_num
From PortfolioProject..NashvilleHousing
)
--Select *
--From RowNumCTE
--where row_num >1
--Order BY ParcelID

Delete
From RowNumCTE
Where row_num >1


---7.Deleting Unused Columns

Select *
From PortfolioProject..NashvilleHousing

Alter table  PortfolioProject..NashvilleHousing
Drop Column OwnerAddress,PropertyAddress,TaxDistrict,SaleDate