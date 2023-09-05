USE TriumphPay;

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT
    u.LoginName,
    u.Name,
    u.PhoneNumber,
    STUFF((SELECT ', ' + c.Name
           FROM Company c
           JOIN
           (
               SELECT u.CompanyId
               UNION
               SELECT uc.CompanyId
               FROM auth.UserAuthorizedCompany UC
               WHERE uc.UserGuid = u.UserGuid
                 AND uc.IsActive = 1
           ) t ON t.CompanyId = c.CompanyId
           FOR XML PATH('')
          ), 1, 2, '') AS Companies,
    STUFF((SELECT ', ' + r.Name
           FROM auth.UserRole ur
           JOIN auth.Role r ON r.RoleId = ur.RoleId
           WHERE ur.IsActive = 1
             AND ur.AuthUserId = u.AuthUserId
           FOR XML PATH('')
          ), 1, 2, '') AS Roles
FROM auth.AuthUser u
WHERE u.CompanyId IN (62672, 33661, 34098)
      AND u.IsTriumphInternal = 0
      AND u.IsBlocked = 0
ORDER BY u.LoginName;