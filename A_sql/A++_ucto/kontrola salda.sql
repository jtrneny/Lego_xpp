select ctext, sum(nkcmd), sum(nkcdal) from ucetsalk where nrok= 2016 and nobdobi = 6 and Left(cucetmd,3)='311' and not lisclose group by ctext 