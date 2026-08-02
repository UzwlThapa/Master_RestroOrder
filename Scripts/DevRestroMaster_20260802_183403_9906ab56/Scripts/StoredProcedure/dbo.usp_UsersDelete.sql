SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[usp_UsersDelete] 
 (@ApplicationName NVARCHAR (256),
 @UserName NVARCHAR (256),
 @PortalID INT,
 @StoreID INT,
 @DeletedBy NVARCHAR (256))
  WITH EXECUTE AS CALLER AS
BEGIN
-- DECLARE
--  @UserID UNIQUEIDENTIFIER SELECT
--   @UserID = UserID
--  FROM
--   PortalUser
--  WHERE
--   PortalID =@PortalID or UserId in (SELECT au.UserId  FROM PortalUser P1 INNER JOIN aspnet_usersinroles au
--ON P1.UserID=AU.UserId INNER JOIN aspnet_roles AR ON AR.RoleId=AU.RoleId AND AR.RoleName='Super User' AND p1.IsActive=1 AND (p1.IsDeleted =0 OR p1.ISDeleted IS NULL ))
--  AND Username =@UserName

 DECLARE
  @UserID UNIQUEIDENTIFIER SELECT
   @UserID = UserID
  FROM
   PortalUser
  WHERE
  PortalID=@PortalID and Username=@UserName
  
   DELETE
  FROM
   dbo.aspnet_UsersInRoles
  WHERE
   dbo.aspnet_UsersInRoles.UserId = @UserID DELETE
  FROM
   dbo.aspnet_membership
  WHERE
   dbo.aspnet_membership.UserId = @UserID DELETE
  FROM
   dbo.aspnet_users
  WHERE
   dbo.aspnet_users.UserId = @UserID DELETE
  FROM
   dbo.portaluser
  WHERE
   dbo.portaluser.UserId = @UserID DELETE
  FROM
   dbo.Users
  WHERE
   dbo.Users.UserName = @UserName --------For DELETETING CUSTOMER--------------
  IF EXISTS (
   SELECT
    *
   FROM
    sys.objects
   WHERE
    object_id = OBJECT_ID(N'[dbo].[Aspx_Customer]')
   AND type IN (N'U')
  )
  BEGIN
   DECLARE
    @CustomerID INT SELECT
     @CustomerID = CustomerID
    FROM
     dbo.Aspx_Customer
    WHERE
     StoreID =@StoreID
    AND PortalID =@PortalID
    AND UserName =@UserName
    IF (@CustomerID IS NOT NULL)
    BEGIN
     UPDATE [dbo].[Aspx_Customer]
    SET IsDeleted = 1,
    DeletedOn = getdate(),
    DeletedBy = @UserName
   WHERE
    [CustomerID] = @CustomerID
   AND StoreID = @StoreID
   AND PortalID = @PortalID --     DELETE [dbo].[Aspx_Customer] 
   --     WHERE
   --       [CustomerID] = @CustomerID AND StoreID = @StoreID AND PortalID = @PortalID
   END UPDATE dbo.Aspx_Address
   SET IsDeleted = 1,
   DeletedOn = getdate(),
   DeletedBy = @UserName
  WHERE
   StoreID =@StoreID
  AND PortalID =@PortalID
  AND AddedBy =@UserName DELETE dbo.Aspx_Cart
  WHERE
   StoreID =@StoreID
  AND PortalID =@PortalID
  AND CustomerID =@CustomerID UPDATE dbo.Aspx_CartItems
  SET IsDeleted = 1,
  DeletedOn = getdate(),
  DeletedBy = @UserName
 WHERE
  CartID IN (
   SELECT
    cartID
   FROM
    Aspx_Cart
   WHERE
    StoreID =@StoreID
   AND PortalID =@PortalID
   AND CustomerID =@CustomerID
  ) UPDATE dbo.Aspx_CompareItemDetails
 SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND UserName =@userName DELETE dbo.Aspx_CompareItems
WHERE
 CompareItemID IN (
  SELECT
   CompareItemID
  FROM
   Aspx_CompareItemDetails
  WHERE
   StoreID =@StoreID
  AND PortalID =@PortalID
  AND UserName =@UserName
 ) UPDATE dbo.Aspx_EmailAFriend
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND SenderName =@UserName UPDATE dbo.Aspx_EmailShareWishList
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND SenderName =@UserName UPDATE dbo.Aspx_ItemRating
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND UserName =@UserName UPDATE dbo.Aspx_ItemReview
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND UserName =@UserName UPDATE dbo.Aspx_ItemTags
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND AddedBy =@UserName UPDATE dbo.Aspx_RecentlyComparedItems
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND AddedBy =@UserName UPDATE dbo.Aspx_RecentlyViewedItems
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND UserName =@UserName UPDATE dbo.Aspx_UserBillingAddress
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND AddedBy =@UserName UPDATE dbo.Aspx_UserShippingAddress
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND AddedBy =@UserName UPDATE dbo.Aspx_WishItemDetails
SET IsDeleted = 1,
 DeletedOn = getdate(),
 DeletedBy = @UserName
WHERE
 StoreID =@StoreID
AND PortalID =@PortalID
AND UserName =@UserName DELETE dbo.Aspx_WishItems
WHERE
 WishItemID IN (
  SELECT
   WishItemID
  FROM
   Aspx_WishItemDetails
  WHERE
   StoreID =@StoreID
  AND PortalID =@PortalID
  AND UserName =@UserName
 )
END
END





GO
