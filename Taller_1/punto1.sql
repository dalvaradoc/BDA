-- i. ##########################################################################################
SELECT
  a.MonthName,
  dbo.DimProduct.ProductName,
  a.TotalSales
from
  (
    select
      dbo.DimDate.MonthName,
      dbo.DimProduct.ProductKey,
      sum(dbo.FactProductSales.SalesTotalCost) as TotalSales
    from
      dbo.FactProductSales
      JOIN dbo.DimDate ON dbo.DimDate.DateKey = dbo.FactProductSales.SalesDateKey
      JOIN dbo.DimProduct ON dbo.DimProduct.ProductKey = dbo.FactProductSales.ProductID
    WHERE
      dbo.DimDate.Year = 2013
    group by
      dbo.FactProductSales.ProductID,
      dbo.DimDate.MonthName,
      dbo.DimProduct.ProductKey
  ) as a
  JOIN dbo.DimProduct ON dbo.DimProduct.ProductKey = a.ProductKey;

-- ii. ##########################################################################################
-- select a.ProductID, a.SalesPersonID, sum(a.Quantity) as 
-- TotalQuantity from dbo.FactProductSales as a group by a.ProductID, a.SalesPersonID;
--select a.ProductID, b.SalesPersonID, a.MaxTotalQuantity from (select a.ProductID, a.SalesPersonID, 
-- sum(a.Quantity) as TotalQuantity 
--	from dbo.FactProductSales as a group by a.ProductID, a.SalesPersonID) as b 
--	INNER JOIN (select a.ProductID, max(a.TotalQuantity) as MaxTotalQuantity from 
--	(select a.ProductID, a.SalesPersonID, sum(a.Quantity) as TotalQuantity 
--	from dbo.FactProductSales as a group by a.ProductID, a.SalesPersonID) as a group by a.ProductID) as a 
--	ON b.ProductID = a.ProductID and b.TotalQuantity = a.MaxTotalQuantity;
SELECT
  a.ProductID,
  b.SalesPersonID,
  a.MaxTotalQuantity
FROM
  (
    SELECT
      a.ProductID,
      a.SalesPersonID,
      SUM(a.Quantity) AS TotalQuantity
    FROM
      dbo.FactProductSales AS a
      INNER JOIN DimDate AS d ON a.SalesDateKey = d.DateKey
    WHERE
      d.Year = '2013'
    GROUP BY
      a.ProductID,
      a.SalesPersonID
  ) AS b
  INNER JOIN (
    SELECT
      a.ProductID,
      MAX(a.TotalQuantity) AS MaxTotalQuantity
    FROM
      (
        SELECT
          a.ProductID,
          a.SalesPersonID,
          SUM(a.Quantity) AS TotalQuantity
        FROM
          dbo.FactProductSales AS a
          INNER JOIN DimDate AS d ON a.SalesDateKey = d.DateKey
        WHERE
          d.Year = '2013'
        GROUP BY
          a.ProductID,
          a.SalesPersonID
      ) AS a
    GROUP BY
      a.ProductID
  ) AS a ON b.ProductID = a.ProductID
  AND b.TotalQuantity = a.MaxTotalQuantity;

-- iii. ##########################################################################################
select
  a.MonthName,
  DimProduct.ProductName,
  TotalQuantity
from
  (
    select
      DimDate.MonthName,
      FactProductSales.ProductID,
      sum(FactProductSales.Quantity) as TotalQuantity
    from
      FactProductSales
      join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
    WHERE
      DimDate.Year = 2013
    group by
      DimDate.Month,
      DimDate.MonthName,
      FactProductSales.ProductID
  ) as a
  INNER JOIN DimProduct ON a.ProductID = DimProduct.ProductKey
ORDER BY
  a.MonthName,
  a.TotalQuantity DESC;

-- iv ##########################################################################################
select
  DimProduct.ProductName,
  a.DayName,
  TotalQuantity
from
  (
    select
      DimDate.DayName,
      FactProductSales.ProductID,
      sum(FactProductSales.Quantity) as TotalQuantity
    from
      FactProductSales
      join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
    WHERE
      DimDate.Year = 2013
    group by
      DimDate.DayName,
      FactProductSales.ProductID
  ) as a
  INNER JOIN DimProduct ON a.ProductID = DimProduct.ProductKey
ORDER BY
  a.ProductID,
  a.TotalQuantity DESC;

-- v. ##########################################################################################
-- Esta fue una primera version de la respuesta, pero me pareció muy larga
-- select
--   *
-- from
--   (
--     select
--       DimDate.Year,
--       FactProductSales.ProductID,
--       sum(FactProductSales.Quantity) as TotalQuantity
--     from
--       FactProductSales
--       join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
--     where
--       DimDate.MonthName = 'Enero' -- aqui sería Abril
--       -- En vez de 12 se restarían 3 para los ultimos 3 años a partir de la fecha actual
--       and DimDate.Year >= DATEADD(year, -12, GETDATE())
--     group by
--       FactProductSales.ProductID,
--       DimDate.Year
--   ) as a
--   JOIN (
--     select
--       a.Year,
--       max(a.TotalQuantity) as MaxTotalQuantity
--     from
--       (
--         select
--           DimDate.Year,
--           FactProductSales.ProductID,
--           sum(FactProductSales.Quantity) as TotalQuantity
--         from
--           FactProductSales
--           join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
--         where
--           DimDate.MonthName = 'Enero' -- aqui sería Abril
--           -- En vez de 12 se restarían 3 para los ultimos 3 años a partir de la fecha actual
--           and DimDate.Year >= DATEADD(year, -12, GETDATE())
--         group by
--           FactProductSales.ProductID,
--           DimDate.Year
--       ) as a
--     group by
--       a.Year
--   ) as b on a.Year = a.Year
--   and b.MaxTotalQuantity = a.TotalQuantity;
with a as (
  select
    DimDate.Year,
    FactProductSales.ProductID,
    sum(FactProductSales.Quantity) as TotalQuantity
  from
    FactProductSales
    join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
  where
    DimDate.MonthName = 'Enero' -- aqui sería Abril, solo se tienen de Enero
    and DimDate.Year >= YEAR(GETDATE()) - 11 -- aquí sería 3 en vez de 11, solo se tienen del 2013
  group by
    FactProductSales.ProductID,
    DimDate.Year
)
select
  a.Year,
  a.ProductID,
  b.MaxTotalQuantity
from
  a
  join (
    select
      a.Year,
      max(a.TotalQuantity) as MaxTotalQuantity
    from
      a
    group by
      a.Year
  ) as b on a.Year = b.Year
  and a.TotalQuantity = b.MaxTotalQuantity;

-- vi. ##########################################################################################
select
  DimDate.Year,
  FactProductSales.ProductID,
  sum(FactProductSales.Quantity) as TotalQuantity
from
  FactProductSales
  join DimStores on DimStores.StoreID = FactProductSales.StoreID
  inner join DimDate on DimDate.DateKey = FactProductSales.SalesDateKey
where
  DimStores.City = 'Ahmedabad' -- Acá se especifica la ciudad
  and FactProductSales.ProductID = 4 -- Acá se especifica el id del producto
group by
  DimDate.Year,
  FactProductSales.ProductID;