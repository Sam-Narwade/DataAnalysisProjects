SELECT * FROM portfolioproject1.nashville_housing;

---------------------------------------------------------------------------------------------------

-- Standardize Date Format

Select SaleDate, date (str_to_date(SaleDate, '%m/%d/%Y'))
From portfolioproject1.nashville_housing;

Update portfolioproject1.nashville_housing
Set SaleDate = date (str_to_date(SaleDate, '%m/%d/%Y'));
SET SQL_SAFE_UPDATES = 0;

---------------------------------------------------------------------------------------------------

-- Populate Property  Address data

Select *
From portfolioproject1.nashville_housing
Where PropertyAddress is null;


---------------------------------------------------------------------------------------------------

-- Breaking out address into Individual Columns (Address, City, State)

-- Property Address
Select PropertyAddress,
substring(PropertyAddress, 1, locate(',',PropertyAddress)-1) As PropertySplitAddress,
substring(PropertyAddress, locate(',',PropertyAddress)+1, length(PropertyAddress)) As PropertySplitCity
From portfolioproject1.nashville_housing;

Alter table portfolioproject1.nashville_housing
Add (PropertySplitAddress varchar(255),
PropertySplitCity varchar(255));

Update portfolioproject1.nashville_housing
Set PropertySplitAddress = substring(PropertyAddress, 1, locate(',',PropertyAddress)-1),
PropertySplitCity = substring(PropertyAddress, locate(',',PropertyAddress)+1, length(PropertyAddress));

-- Owner's Address 
SELECT Substring_index(OwnerAddress,',',1) As OwnerSplitAddress,
Substring_index(Substring_index(OwnerAddress, ',', 2), ',', -1) As OwnerSplitCity,
Substring_index(OwnerAddress,',',-1) As OwnerSplitState
From portfolioproject1.nashville_housing;

Alter table portfolioproject1.nashville_housing
Add (OwnerSplitAddress varchar(255),
	 OwnerSplitCity varchar(255),
     OwnerSplitState varchar(255));
     
Set SQL_SAFE_UPDATES = 0;     
     
Update portfolioproject1.nashville_housing
Set OwnerSplitAddress = Substring_index(OwnerAddress,',',1),
    OwnerSplitCity = Substring_index(Substring_index(OwnerAddress, ',', 2), ',', -1),
    OwnerSplitState = Substring_index(OwnerAddress,',',-1);
    
    
Select * from portfolioproject1.nashville_housing;

------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select SoldAsVacant, count(SoldAsVacant),
	   Case When SoldAsVacant = 'Y' then 'Yes'
			When SoldAsVacant = 'N' then 'No'
            Else SoldAsVacant
            End
from portfolioproject1.nashville_housing;

Update portfolioproject1.nashville_housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
						When SoldAsVacant = 'N' then 'No'
						Else SoldAsVacant
						End;
                        
------------------------------------------------------------------------------------------------------

-- Remove Duplicates                        

With RowNumCTE as (
	Select * ,
		row_number() Over( 
			partition by ParcelID,
						 PropertyAddress,
						 SaleDate,
						 SalePrice,
						 LegalReference
		) As row_num
	From portfolioproject1.nashville_housing
	-- Order By ParcelID;
)
Select COUNT(*) 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress;

-- Optional method

Select t1.ParcelID
From portfolioproject1.nashville_housing t1
Join portfolioproject1.nashville_housing t2
	On t1.ParcelID = t2.ParcelID
	And t1.PropertyAddress = t2.PropertyAddress
    And t1.SaleDate = t2.SaleDate
    And t1.SalePrice = t2.SalePrice
    And t1.LegalReference = t2.LegalReference
    And t1.UniqueID > t2.UniqueID;

Set SQL_Safe_Updates = 0;

Delete t1
From portfolioproject1.nashville_housing t1
Join portfolioproject1.nashville_housing t2
	On t1.ParcelID = t2.ParcelID
	And t1.PropertyAddress = t2.PropertyAddress
    And t1.SaleDate = t2.SaleDate
    And t1.SalePrice = t2.SalePrice
    And t1.LegalReference = t2.LegalReference
    And t1.UniqueID > t2.UniqueID;
    
-------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns












