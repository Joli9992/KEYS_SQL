SELECT PropertyId, [Name] PropertyName, OwnerId
FROM [dbo].[Property]
INNER JOIN [dbo].[OwnerProperty] ON [dbo].[OwnerProperty].[PropertyId] = [dbo].[Property].[Id]
WHERE [OwnerId] =1426

----//----

SELECT [dbo].[OwnerProperty].[PropertyId], [Name] PropertyName, OwnerId, [Value] HomeValue
FROM [dbo].[Property]
INNER JOIN [dbo].[OwnerProperty] ON [dbo].[OwnerProperty].[PropertyId] = [dbo].[Property].[Id]
INNER JOIN [dbo].[PropertyHomeValue] ON [dbo].[OwnerProperty].[PropertyId] = [dbo].[PropertyHomeValue].[PropertyId]
WHERE [OwnerId] =1426

-----//----

SELECT [dbo].[PropertyRentalPayment].[PropertyId],[FrequencyType], OwnerId,[StartDate],[EndDate], [PaymentAmount]
FROM [dbo].[PropertyRentalPayment] 
INNER JOIN [dbo].[OwnerProperty] ON [dbo].[OwnerProperty].[PropertyId] = [dbo].[PropertyRentalPayment].PropertyId
INNER JOIN [dbo].[TenantProperty] ON [dbo].[PropertyRentalPayment].PropertyId = [dbo].[TenantProperty].[PropertyId]
WHERE [OwnerId] =1426

-----//----

SELECT P.Name 'PropertyName', TP.[PropertyId] 'PropertyID', RT.Name 'RentPaymentMode', TP.[StartDate], TP.[EndDate], TP.[PaymentAmount],

       CASE
           WHEN RT.Name = 'Weekly' THEN PaymentAmount*52
           WHEN RT.Name = 'Fortnightly' THEN PaymentAmount*26
           WHEN RT.Name = 'Monthly' THEN PaymentAmount*12
           ELSE Null END as TotalRent
        
FROM [dbo].[TenantProperty] as TP
INNER JOIN [dbo].[Property] as P on P.id = TP.PropertyId
INNER JOIN [dbo].[TargetRentType] as RT on RT.[Id] = TP.PaymentFrequencyId
WHERE TP.[PropertyId] IN ('5597','5637','5638')
GROUP BY p.[Name], tp.[PropertyId], RT.[Name], TP.[StartDate], TP.[EndDate], TP.[PaymentAmount]




SELECT P.Name 'PropertyName', TP.[PropertyId] 'PropertyID', RT.Name 'RentPaymentMode', TP.[StartDate], TP.[EndDate], TP.[PaymentAmount],

       CASE
           WHEN RT.Name = 'Weekly' THEN DATEDIFF(week, StartDate, EndDate)*[PaymentAmount]
           WHEN RT.Name = 'Fortnightly' THEN DATEDIFF(week, StartDate, EndDate)*([PaymentAmount]/2)
           WHEN RT.Name = 'Monthly' THEN DATEDIFF(Month,StartDate,EndDate)*[PaymentAmount]
           ELSE Null END as TotalRent
        
FROM [dbo].[TenantProperty] as TP
INNER JOIN [dbo].[Property] as P on P.id = TP.PropertyId
INNER JOIN [dbo].[TargetRentType] as RT on RT.[Id] = TP.PaymentFrequencyId
WHERE TP.[PropertyId] IN ('5597','5637','5638')
GROUP BY p.[Name], tp.[PropertyId], RT.[Name], TP.[StartDate], TP.[EndDate], TP.[PaymentAmount]

 -----//----

 Select TP.PropertyId,
 ((CASE
           WHEN [PaymentFrequencyId] = '1' THEN DATEDIFF(week, StartDate, EndDate)*[PaymentAmount]
           WHEN [PaymentFrequencyId]  = '2' THEN DATEDIFF(week, StartDate, EndDate)*([PaymentAmount]/2)
           WHEN [PaymentFrequencyId] = '3' THEN DATEDIFF(Month,StartDate,EndDate)*[PaymentAmount]
		        END) - [Amount])/[CurrentHomeValue]*100 as Yield
 FROM [dbo].[TenantProperty] TP 
 INNER JOIN [dbo].[PropertyExpense] PE ON PE.[PropertyId] = TP.PropertyId
 INNER JOIN [dbo].[PropertyFinance] PF ON PE.[PropertyId] = PF.[PropertyId]
 WHERE TP.[PropertyId] IN ('5597','5637','5638')

 -----//----

 SELECT JM.PropertyId,Job.Id,JobDescription,JOB.JobStatusId,JS.Status
 FROM [dbo].[Job] Job
 Inner Join [dbo].[JobMedia] JM ON JOb.id = JM.Jobid
 Inner Join [dbo].[JobStatus] JS ON JOB.jobstatusId = JS.Id
 Where JOB.JobStatusId = 1 
 
 -----//----

 Display all property names, current tenants first and last names and rental payments per week/ fortnight/month for the properties in question a)

 -----//-----
 SELECT OP.PropertyId,P.Name PropertyName,[FirstName],[LastName], PR.Amount, PF.Name RentalPaymnt
FROM [dbo].[OwnerProperty] OP
INNER JOIN [dbo].[PropertyRentalPayment] PR ON OP.PropertyId = PR.PropertyId
INNER JOIN [dbo].[Property] P ON P.ID = PR.PropertyId
INNER JOIN [dbo].[TenantPaymentFrequencies] PF ON PF.ID = PR.FrequencyType
INNER JOIN [dbo].[TenantProperty] TP ON TP.PropertyId = PR.PropertyId
INNER JOIN [dbo].[Person] PE ON PE.ID =TP.TenantId
WHERE OP.[OwnerId] =1426


-------//-----




---
SELECT 

pro.[Name] AS 'Property Name',

ps.[FirstName] AS 'Current Owner',

CONCAT (ad.Number,'',ad.Street,'',ad.City) AS 'Property Address',

CONCAT (pro.[Bedroom], ' ',pro.[Bathroom]) AS 'Property Details',

prenp.[Amount] AS 'Rental payment',

prenp.[FrequencyType] AS 'Rental payment Frequency type',

[dbo].[TenantPaymentFrequencies].[Name] as 'Rental payment Frequency',

pex.[Amount],

pex.[Date],

pex.[Description] AS 'Expense'

FROM dbo.[Property] pro

INNER JOIN dbo.[OwnerProperty] op

ON pro.[Id] = op.[PropertyId]

INNER JOIN dbo.[PropertyRentalPayment] prenp

ON op.[PropertyId]=prenp.[PropertyId]

INNER JOIN dbo.[PropertyExpense] pex

ON op.[PropertyId] = pex.[PropertyId]

INNER JOIN dbo.[Person] ps

ON ps.[Id] = op.[OwnerId]

INNER JOIN dbo.[Address] ad

ON  ad.[AddressId] = pro.[AddressId]

Inner join [dbo].[TenantPaymentFrequencies] on [dbo].[TenantPaymentFrequencies].id = prenp.FrequencyType

WHERE pro.[Name] = 'Property A' 
 
 