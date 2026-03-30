-- removing duplicates

create table layoffs_copy like layoffs;
insert into layoffs_copy
select * from layoffs;

select * from layoffs_copy;

select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as  row_num
from layoffs_copy;

with duplicate_cte as (
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as  row_num
from layoffs_copy)
select * from duplicate_cte where row_num > 1;

select * from layoffs_copy where company = 'Casper';

CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_copy2
select *, row_number() over(partition by company, location, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) as  row_num
from  layoffs_copy;

select * from layoffs_copy2 where row_num > 1;

-- standardizing data

select * from layoffs_copy2;

update layoffs_copy2
set company = trim(company);

select industry from layoffs_copy2 where industry like "crypto%";

update layoffs_copy2 
set industry = "Crypto"
where industry like "crypto%";

update layoffs_copy2 
set country = "United States"
where country like "United States%";

select country from layoffs_copy2 where country like "United States";

update layoffs_copy2 
set `date` = str_to_date(`date`, '%m/%d/%Y');

select `date` from layoffs_copy2;


alter table layoffs_copy2
modify column `date` Date;


select * from layoffs_copy2 where industry = '' or industry is null;

update layoffs_copy2 
set industry = null
where industry = '';

select * from layoffs_copy2 where company = 'Airbnb';

select t1.company, t1.industry, t2.company, t2.industry from layoffs_copy2 t1
join layoffs_copy2 t2
on t1.company = t2.company and t1.location = t2.location
where (t1.industry = '' or t1.industry is null) and t2.industry is not null;

update layoffs_copy2 t1 
join layoffs_copy2 t2
 on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null 
and t2.industry is not null;

delete from layoffs_copy2 where total_laid_off is null and percentage_laid_off is null;

select * from layoffs_copy2 where total_laid_off is null and percentage_laid_off is null;

alter table layoffs_copy2 
drop column row_num;
