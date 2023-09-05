USE TriumphPay;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT
    u.LoginName,
    (SELECT r.Name
    FROM auth.UserRole ur
    JOIN auth.Role r ON r.RoleId = ur.RoleId
    WHERE ur.IsActive = 1)
FROM auth.AuthUser u
WHERE ur.AuthUserId = u.AuthUserId