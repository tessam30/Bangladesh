use $pathout/violence.dta, clear

* What is the age difference between husband and wife? Chunk it out for plotting
g spouseAgeDiff = agehead - ageSpouse
egen spouseAgeDiffCat = cut(spouseAgeDiff), at(-63, 0, 5, 10, 15, 48) icodes
la def agdiff 0 "Wife older" 1 "Husband 0-4 yrs older" 2 "Husband 5-9 yrs older" /*
*/ 3 "Husband 10 - 14 yrs older" 4 "Husband 15+ years older"
la val spouseAgeDiffCat agdiff

g byte vfilt = (ageSpouse > 14 & ageSpouse < 50)

eststo verbal: mean verbalAbuse if vfilt
matrix stat1 = r(table)'


eststo verbal: mean verbalAbuse  if vfilt , over(divName)
matrix stat2 = r(table)'
matsort stat2 1 "down"

eststo verbal: mean physicalAbuse if vfilt
matrix stat3 = r(table)'

eststo verbal: mean physicalAbuse  if vfilt , over(divName)
matrix stat4 = r(table)'
matsort stat4 1 "down"

matrix A = (stat1\stat2\stat3\stat4)
matselrc A B, c(1 2 5 6)
mat2txt, matrix(B) saving("$pathexport/violence") replace

eststo verbal: mean verbalAbuse  if ageSpouse >14 & ageSpouse <50 , over(divName)
matrix verbal = r(table)'
matsort verbal 1 "down"
matrix verbal = verbal'
coefplot (matrix(verbal[1,])), ci((verbal[5,] verbal[6,])) /*
*/ title(Women report the most cases of verbal Abuse in Sylhet, size(small) color(black))  

eststo physical: mean physicalAbuse if ageSpouse >14 & ageSpouse <50 , over(divName)
matrix physical = r(table)'
matsort physical 1 "down"
matrix physical = physical'
coefplot (matrix(physical[1,])), ci((physical[5,] physical[6,]))/*
*/ title(Women report the most cases of physical abuse in Rangpur, size(small) color(black))  

eststo stat: mean verbalAbuse if ageSpouse >14 & ageSpouse <50 & spouseAgeDiffCat ! =  0, over(wealthDecile)
matrix stat = r(table)'
*matrix colnames stat = 1st 2nd 3rd 4th 5th 6th 7th 8th 9th 10th
*matsort stat 1 "down"
matrix stat = stat'
coefplot (matrix(stat[1,])), ci((stat[5,] stat[6,]))/*
*/ title(Verbal abuse declines with wealth (asset holdings), size(small) color(black)) 

mean physicalAbuse if verbalAbuse ==1 & vfilt ==1, over(divName)
matrix stat = r(table)'
matsort stat 1 "down"
matrix stat = stat'
coefplot (matrix(stat[1,])), ci((stat[5,] stat[6,]))/*
*/ title(For women reporting verbal abuse physical abuse is highest in Barisal, size(small) color(black)) 






twoway (lowess verbalAbuse wealthIndex)(lowess physicalAbuse wealthIndex)
twoway (lowess femaleOwnsOperatesCell wealthIndex), by(div_name, total row(2))
twoway (lowess mobile wealthIndex), by(div_name, total row(2))

eststo stat: mean mobile, over(divName)
matrix stat = r(table)'
matsort stat 1 "down"
matrix stat = stat'
coefplot (matrix(stat[1,])), ci((stat[5,] stat[6,]))/*
*/ title(Mobile phone ownership is lowest in Rangpur, size(small) color(black)) 



eststo stat: mean femWork  if ageSpouse >14 & ageSpouse <50 & spouseAgeDiffCat ! =  0, over(divName)
matrix stat = r(table)'
matsort stat 1 "down"
matrix stat = stat'
coefplot (matrix(stat[1,])), ci((stat[5,] stat[6,]))/*
*/ title(Women work more in Rangpur, size(small) color(black)) 



