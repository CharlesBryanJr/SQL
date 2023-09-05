-- I'm tying to export a list of users for
-- Redwood Multimodal, Redwood SCS, and Redwood Simplified.
-- Needing (names/rolls/company ID access)

-- REDWOOD SCS (TriumphPay Broker) 38481
-- REDWOOD MULTIMODAL (TriumphPay Broker) 38453
-- SIMPLIFIED LOGISTICS DBA REDWOOD LOGISTICS (TriumphPay Broker) 66375

USE TriumphPay
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @UserName varchar(100)
DECLARE @LoginName varchar(100)
DECLARE @CompanyName varchar(250)
DECLARE @CompanyIds TABLE (CompanyId INT)

SET @LoginName = NULL
SET @CompanyName = 'Redwood'
INSERT INTO @CompanyIds (CompanyId) VALUES (38481), (38453), (66375)

SELECT
    c.Name AS CompanyName,
    au.Name AS UserName,
    au.LoginName,
    r.Name AS RoleName

FROM auth.UserAuthorizedCompany uac
    INNER JOIN auth.AuthUser au ON uac.UserGuid = au.UserGuid
    INNER JOIN Company c ON uac.CompanyId = c.CompanyId
    LEFT JOIN auth.UserRole ur ON ur.AuthUserId = au.AuthUserId
    LEFT JOIN auth.Role r ON ur.RoleId = r.RoleId

WHERE (@LoginName IS NULL OR au.LoginName = @LoginName)
    AND (@UserName IS NULL OR au.Name = @UserName)
    AND ((NOT EXISTS (SELECT 1 FROM @CompanyIds)) OR (uac.CompanyId IN (SELECT CompanyId FROM @CompanyIds)))
    AND (@CompanyName IS NULL OR c.Name LIKE '%' + @CompanyName + '%')

ORDER BY c.Name, au.Name